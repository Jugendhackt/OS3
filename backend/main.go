package main

import (
	"crypto/tls"
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"regexp"
	_ "github.com/go-sql-driver/mysql"
	"golang.org/x/crypto/bcrypt"
	"strings"
	"os"
	"path/filepath"
)

var database *sql.DB

/*Struct for storing the userdata*/
type SLogin struct {
	Username  string `json:"username"`
	Passsword string `json:"passsword"`
	Address   string `json:"address"`
	Dbname    string `json:"dbname"`
	Charset   string `json:"charset"`
}

func main() {

	logindata, err := ioutil.ReadFile("./login.json")

	fmt.Println(string(logindata))

	var login []SLogin

	json.Unmarshal(logindata, &login)

	if err != nil {
		login[0].Username = "root"
		login[0].Passsword = "root"
		login[0].Address = "localhost"
		login[0].Dbname = "OS3"
		login[0].Charset = "uft8"

		fmt.Println(err.Error())
	} else {
		fmt.Printf("\n%v\n", login)
	}

	//Openng the Connection to the mysql data base,
	//checking for errors and setting the data base as global variable
	db, err := sql.Open("mysql", login[0].Username+":"+login[0].Passsword+"@tcp("+login[0].Address+")/"+login[0].Dbname+"?charset="+login[0].Charset)
	if db != nil {
		fmt.Println(db)
	}
	checkErr(err)

	database = db

	//Setting the defaults if theyy don't exist
	checkDataBase(db)

	//Defining mux as Handler
	mux := http.NewServeMux()

	//TODO Check incoming requests for SQL-Code

	//Choosing the appropiate Handlers for the right sub-directories
	mux.HandleFunc("/", rootHandler)
	mux.HandleFunc("/auth/login", loginHandler)
	mux.HandleFunc("/auth/tokenLogin", tokenLoginHandler)
	mux.HandleFunc("/auth/register", registerHandler)
	mux.HandleFunc("/user/listUsers", listUsersHandler)
	//mux.HandleFunc("/user/meta", userMetaHandler)
	mux.HandleFunc("/site/", siteHandler)
	mux.HandleFunc("/layout/", folderHandler)
	mux.HandleFunc("/data/", folderHandler)

	//Configuring the TLS Transmission
	cfg := &tls.Config{
		MinVersion:               tls.VersionTLS12,
		CurvePreferences:         []tls.CurveID{tls.CurveP521, tls.CurveP384, tls.CurveP256},
		PreferServerCipherSuites: true,
		CipherSuites: []uint16{
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,
			tls.TLS_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_RSA_WITH_AES_256_CBC_SHA,
		},
	}

	//Starting the Server
	srv := &http.Server{
		Addr:         ":443",
		Handler:      mux,
		TLSConfig:    cfg,
		TLSNextProto: make(map[string]func(*http.Server, *tls.Conn, http.Handler), 0),
	}
	log.Fatal(srv.ListenAndServeTLS("server.rsa.crt", "server.rsa.key"))

}

/*
The root handler simply allows cors for the frontend, adds the STS Header(HTTPS only)
and Prints a String to the Screen
*/
func rootHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w, req)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	w.Write([]byte("This is a test server.\n"))
}

func folderHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w, req)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	http.ServeFile(w, req, "."+req.URL.Path)
}

func siteHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w, req)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")

	s := strings.Split(strings.Split(req.URL.Path, "/")[2], ".")[0]
	fmt.Println(s)

	match, _ := regexp.MatchString("^[0-9]*$", s)

	fmt.Println(match)
	fmt.Println(req.Header.Get("token"))

	if match {
		w.Header().Add("title", s)
		s = "/site/" + s + ".oll"
		fmt.Println(s)
		dir, _ := filepath.Abs(filepath.Dir(os.Args[0]))

		if _, err := os.Stat(dir + s); err == nil {
			fmt.Println("EXIST")
		} else {

			fmt.Println("NOTEXIST")
			s = "/site/error_404.oll"
		}
	} else {
		site, title := getSiteTroughAlias(s);
		s = "/site/" + site + ".oll"
		fmt.Println(s)
		fmt.Println(title)
		w.Header().Set("title", title)

	}
	w.Header().Set("test", "value")
	http.ServeFile(w, req, "."+s)
}

/*
The Login Handler handles the user login (pretty obvious)
and delivers specific messages depending on the access type
*/
func loginHandler(w http.ResponseWriter, req *http.Request) {
	//First we have to enable cors and STS
	enableCors(&w, req)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")

	//the action is chosen based on the request method
	switch req.Method {

	//In case of a post request the program continues the login
	case "POST":

		//The request form gets parsed and then for the
		//sake of debugging printed into the console
		req.ParseForm()
		fmt.Printf("\n\n%v\n", req.Form)

		//Then the data the user sent is fetched and stored
		//in variables to work with them
		username := req.Form["username"]
		password := req.Form["password"]
		token := req.Form["token"]
		autoLoginTokenArray := req.Form["autoLoginToken"]
		autoLoginToken := ""
		if len(autoLoginTokenArray) != 0 {
			autoLoginToken = autoLoginTokenArray[0]
		}
		fmt.Println(token)
		fmt.Println(autoLoginToken)

		//Then the data gets passed into the login-function
		displaymsg(logUserIn(username[0], password[0], token[0], autoLoginToken), &w)

		//for any other request type the requestor simply gets a message saying access denied.
	default:
		fmt.Printf("\n\n%v\n", req)
		fmt.Println(req.Form)
		w.Write([]byte("\nAccess denied!\n\n"))

	}

}
func listUsersHandler(w http.ResponseWriter, req *http.Request) {
	//First we have to enable cors and STS
	enableCors(&w, req)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")

	//the action is chosen based on the request method
	switch req.Method {

	//In case of a post request the program continues the login
	case "GET":

		//The request form gets parsed and then for the
		//sake of debugging printed into the console
		/*		req.ParseForm()
		*/fmt.Printf("\n\n%v\n", req.Form)

		s := req.Header.Get("token")

		uid := getUserAuth(s)

		if uid == 0 {
			displaymsg("Access denied!", &w)
			return

		} else {

			rows, err := database.Query("SELECT username,email,displayname FROM user")

			if err != nil {
				displaymsg("Error", &w)
				return
			}
			defer rows.Close()
			columns, err := rows.Columns()
			if err != nil {
				displaymsg("Error", &w)
				return
			}
			count := len(columns)
			tableData := make([]map[string]interface{}, 0)
			values := make([]interface{}, count)
			valuePtrs := make([]interface{}, count)
			for rows.Next() {
				for i := 0; i < count; i++ {
					valuePtrs[i] = &values[i]
				}
				rows.Scan(valuePtrs...)
				entry := make(map[string]interface{})
				for i, col := range columns {
					var v interface{}
					val := values[i]
					b, ok := val.([]byte)
					if ok {
						v = string(b)
					} else {
						v = val
					}
					entry[col] = v
				}
				tableData = append(tableData, entry)
			}
			jsonData, err := json.Marshal(tableData)
			if err != nil {
				displaymsg("Error", &w)
				return
			}
			fmt.Println(string(jsonData))
			displaymsg(string(jsonData), &w)
			return
		}
		//Then the data the user sent is fetched and stored
		//in variables to work with them

		//Then the data gets passed into the login-function

		//for any other request type the requestor simply gets a message saying access denied.
	default:
		fmt.Printf("\n\n%v\n", req)
		fmt.Println(req.Form)
		w.Write([]byte("\nAccess denied!\n\n"))

	}

}
func getUserAuth(s string) int64 {
	uid, err := database.Query("SELECT userId FROM tokens WHERE token = \"" + s + "\"")

	//if it would accur that there are several people with that username
	//we choose the first one (it wouldn#t matter but cannot be number 0)
	var usid int64
	if uid != nil {
		uid.Next()
		uid.Scan(&usid)
	}

	//if there was an error a message is thrown
	if err != nil {
		fmt.Println("point 1" + err.Error())
		return 0

		//if not it  will continue
	} else if usid == 0 {
		return 0
	} else {
		return usid
	}
}

func tokenLoginHandler(w http.ResponseWriter, req *http.Request) {
	//First we have to enable cors and STS
	enableCors(&w, req)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")

	//the action is chosen based on the request method
	switch req.Method {

	//In case of a post request the program continues the login
	case "POST":

		//The request form gets parsed and then for the
		//sake of debugging printed into the console
		req.ParseForm()
		fmt.Printf("\n\n%v\n", req.Form)

		//Then the data the user sent is fetched and stored
		//in variables to work with them
		token := req.Form["token"]
		autoLoginToken := req.Form["autoLoginToken"]

		fmt.Println(token)

		//Then the data gets passed into the login-function
		displaymsg(logUserInWithToken(autoLoginToken[0], token[0]), &w)

		//for any other request type the requestor simply gets a message saying access denied.
	default:
		fmt.Printf("\n\n%v\n", req)
		fmt.Println(req.Form)
		w.Write([]byte("\nAccess denied!\n\n"))

	}

}

/*
The register Handler handles the user account creation
and delivers specific messages depending on the access type
*/
func registerHandler(w http.ResponseWriter, req *http.Request) {
	//First we have to enable cors and STS
	enableCors(&w, req)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")

	//the action is chosen based on the request method
	switch req.Method {

	//In case of a post request the program continues the login
	case ("POST"):

		//The request form gets parsed and then for the
		//sake of debugging printed into the console
		req.ParseForm()
		fmt.Printf("\n\n%v\n", req.Form)

		//Then the data the user sent is fetched and stored
		//in variables to work with them
		username := req.Form["username"]
		password := req.Form["password"]
		token := req.Form["token"]
		displayname := req.Form["displayname"]
		email := req.Form["email"]

		fmt.Println(token)

		//Then the data gets passed into the createUser-function
		displaymsg(createUser(username[0], password[0], displayname[0], email[0]), &w)

		//for any other request type the requestor simply gets a message saying access denied.
	default:
		fmt.Printf("\n\n%v\n", req)
		fmt.Println(req.Form)
		w.Write([]byte("Access denied!"))

	}

}

//The function for generating the bare minimum of the data base
func checkDataBase(db *sql.DB) {
	//Setting up the main user data base
	db.Exec("CREATE TABLE IF NOT EXISTS user(userid int NOT NULL AUTO_INCREMENT PRIMARY KEY,username VARCHAR(32) NOT NULL,password CHAR(64) NOT NULL,displayname VARCHAR(32),email VARCHAR(64),profilePicture MEDIUMBLOB)")

	db.Exec("CREATE TABLE IF NOT EXISTS tokens(tokenid int NOT NULL AUTO_INCREMENT PRIMARY KEY,userid int NOT NULL,token VARCHAR(36) NOT NULL,currentTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY (userid) REFERENCES user(userid) )")

	db.Exec("CREATE TABLE IF NOT EXISTS autoLoginTokens(tokenid int NOT NULL AUTO_INCREMENT PRIMARY KEY,userid int NOT NULL,token VARCHAR(108) NOT NULL,currentTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY (userid) REFERENCES user(userid) )")

	db.Exec("CREATE TABLE IF NOT EXISTS siteAliases(siteAliasId int NOT NULL AUTO_INCREMENT PRIMARY KEY,alias VARCHAR(32) NOT NULL,siteId int NOT NULL)")

	//Permissions and groups
	db.Exec("CREATE TABLE IF NOT EXISTS perms(permId int NOT NULL AUTO_INCREMENT PRIMARY KEY,userOrGroupId int NOT NULL,isUser bit NOT NULL DEFAULT 0,permission int NOT NULL)")

	db.Exec("CREATE TABLE IF NOT EXISTS permNames(permNameId int NOT NULL AUTO_INCREMENT PRIMARY KEY,permId int NOT NULL, permName VARCHAR(32) NOT NULL)")

	db.Exec("CREATE TABLE IF NOT EXISTS groups(groupId int NOT NULL AUTO_INCREMENT PRIMARY KEY,groupName VARCHAR(32) NOT NULL,groupVisible bit NOT NULL default 0)")

	db.Exec("CREATE TABLE IF NOT EXISTS userGroups(userGroupId int NOT NULL AUTO_INCREMENT PRIMARY KEY,userId int NOT NULL,groupId int NOT NULL)")

	db.Exec("CREATE TABLE IF NOT EXISTS groupPerms(groupPermId int NOT NULL AUTO_INCREMENT PRIMARY KEY,userId int NOT NULL,permId int NOT NULL)")

	//Creating a default user
	fmt.Println(createUser("root", "geheim", "The Root", ""))
	fmt.Println(createGroup("Admin", true))
	fmt.Println(addUserToGroup(1, 1))
	fmt.Println(addPerm( /*userOrGroupId*/ 1, /*isUser*/ 0, /*permissions*/ []int64{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}))
	fmt.Println(hasPerm( /*userId*/ 1, /*permission*/ 10))
	fmt.Println(getPerms( /*userId*/ 1))

	/*
		perms	create_user		1	Create a new user
		perms	delete_user		2	Delete any user
		perms	list_users		3	List all users
		perms	edit_user		4	Edit any user
		perms	create_group	5	Create a new group
		perms	delete_group	6	Delete any group
		perms	list_groups		7	List all groups
		perms	edit_group		8	Edit any group
		perms	edit_perms		9	Edit the name and description of perms
		perms	change_perms	10	Change the global perms for users and groups
	*/

	/*	fmt.Println(logUserIn("root", "geheim", "fauwhwaduwdawdf", "saddfsdfsdf"))
	*/

	/*for i := 0; i < 10000; i++ {
			createGroup(strconv.Itoa(rand.Int()), true)
		}*/
	username, action := tokenLogIn("fauwhwaduwdawdf")

	fmt.Printf("%v, %v\n", username, action)
}

func getPerms(userId int64) []int64 {
	rows, err := database.Query("SELECT permission FROM perms WHERE userOrGroupId = " + strconv.FormatInt(userId, 10) + " AND isUser = 1")

	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var pids []int64
	for rows.Next() {
		var pid int64
		if err := rows.Scan(&pid); err != nil {
			log.Fatal(err)
		}
		pids = append(pids, pid)
	}
	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}

	rows, err = database.Query("SELECT groupId FROM userGroups WHERE userId = " + strconv.FormatInt(userId, 10))

	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		var gid int64
		if err := rows.Scan(&gid); err != nil {
			log.Fatal(err)
		}
		rows, err := database.Query("SELECT permission FROM perms WHERE userOrGroupId = " + strconv.FormatInt(gid, 10) + " AND isUser = 0")

		if err != nil {
			log.Fatal(err)
		}

		for rows.Next() {
			var pid int64
			if err := rows.Scan(&pid); err != nil {
				log.Fatal(err)
			}
			pids = append(pids, pid)
		}
		if err := rows.Err(); err != nil {
			log.Fatal(err)
		}
		rows.Close()

	}
	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}

	return pids
}
func addPerm(userOrGroupId int64, isUser int64, permissions []int64) string {
	for _, element := range permissions {
		/*		fmt.Println(element)
		*/
		uid, err := database.Query("SELECT permId FROM perms WHERE userOrGroupId = " + strconv.FormatInt(userOrGroupId, 10) + " AND isUser = " + strconv.FormatInt(isUser, 10) + " AND permission = " + strconv.FormatInt(element, 10))
		/*	fmt.Println(element)

			fmt.Println("SELECT permId FROM perms WHERE userOrGroupId = " + strconv.FormatInt(userOrGroupId, 10) + " AND isUser = " + strconv.FormatInt(isUser, 10) + " AND permission = " + strconv.FormatInt(element, 10))
			*/

		var gid int
		if uid != nil {
			uid.Next()
			uid.Scan(&gid)
		}

		if gid == 0 && err == nil {

			if err == nil {
				fmt.Println(element)
				database.Exec("INSERT INTO perms (userOrGroupId,isUser,permission) VALUES (" + strconv.FormatInt(userOrGroupId, 10) + "," + strconv.FormatInt(isUser, 10) + "," + strconv.FormatInt(element, 10) + ")")
				/*				return "\n\nUser added to group.\n\n"
				*/
				//Otherwise a message is produced
			} else {
				fmt.Print(err.Error())
				return "\n\nSomething went wrong.\n\n"
			}

		} else if uid != nil && err == nil {
			/*			return "User with id " + strconv.FormatInt(userId, 10) + " already in group " + strconv.FormatInt(groupId, 10) + "."
			*/
		} else if err != nil {
			fmt.Println(err.Error())
			return "Something went wrong."
		} else {

		}

	}
	return ""

}
func hasPerm(userId int64, permission int64) bool {
	/*		fmt.Println(element)
	*/
	uid, err := database.Query("SELECT permId FROM perms WHERE userOrGroupId = " + strconv.FormatInt(userId, 10) + " AND isUser = 1 AND permission = " + strconv.FormatInt(permission, 10))
	/*	fmt.Println(element)

		fmt.Println("SELECT permId FROM perms WHERE userOrGroupId = " + strconv.FormatInt(userOrGroupId, 10) + " AND isUser = " + strconv.FormatInt(isUser, 10) + " AND permission = " + strconv.FormatInt(element, 10))
		*/

	var gid int
	if uid != nil {
		uid.Next()
		uid.Scan(&gid)
	}

	if gid == 0 && err == nil {

		rows, err := database.Query("SELECT groupId FROM userGroups WHERE userId = " + strconv.FormatInt(userId, 10))
		if err != nil {
			log.Fatal(err)
			return false
		}
		defer rows.Close()
		for rows.Next() {
			var groupId int64
			if err := rows.Scan(&groupId); err != nil {
				log.Fatal(err)
				return false
			}

			uid, err = database.Query("SELECT permId FROM perms WHERE userOrGroupId = " + strconv.FormatInt(groupId, 10) + " AND isUser = 0 AND permission = " + strconv.FormatInt(permission, 10))
			var gid int
			if uid != nil {
				uid.Next()
				uid.Scan(&gid)
			}
			if gid != 0 {
				return true
			}
			fmt.Println(groupId)
		}
		if err := rows.Err(); err != nil {
			log.Fatal(err)
			return false
		}

	} else if uid != nil && err == nil {
		/*			return "User with id " + strconv.FormatInt(userId, 10) + " already in group " + strconv.FormatInt(groupId, 10) + "."
		*/
		return true
	} else if err != nil {
		fmt.Println(err.Error())
		return false
	} else {
	}
	return false

}

//Small function to enable cors
func enableCors(w *http.ResponseWriter, r *http.Request) {
	if origin := r.Header.Get("Origin"); origin != "" {
		(*w).Header().Set("Access-Control-Allow-Origin", origin)
	}
	(*w).Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
	(*w).Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token,Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, token, title")
	(*w).Header().Set("Access-Control-Allow-Credentials", "true")

	/*	(*w).Header().Set("Access-Control-Allow-Origin", "*")
		(*w).Header().Set("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT")
		(*w).Header().Set("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, token, title")
	*/}

//Small function to find errors and then panic
func checkErr(err error) {
	if err != nil {
		fmt.Println(err.Error())
		panic(err)
	}
}

//A function to log in with just a valid token
func tokenLogIn(token string) (username string, action int) {
	//Now the Program does a query to ask if there is a Person that alreadly
	//has this token
	uid, err := database.Query("SELECT userid FROM tokens WHERE token = \"" + token + "\"")

	//if it would accur that there are several people with that username
	//we choose the first one (it wouldn#t matter but cannot be number 0)
	var usid int
	if uid != nil {
		uid.Next()
		uid.Scan(&usid)
	}

	if err == nil {
		pass, errr := database.Query("SELECT username FROM user WHERE userid = ?", usid)
		if errr == nil {
			var uname string
			for pass.Next() {
				errr = pass.Scan(&uname)
			}

			if uname != "" {
				return uname, 2
			} else {
				return "", 1
			}

		} else {
			fmt.Println(err.Error())
			return "", 0
		}
	} else {
		fmt.Println(err.Error())
		return "", 0
	}

}

func getSiteTroughAlias(alias string) (site string, title string) {
	fmt.Println("START")
	fmt.Println(alias)

	uid, err := database.Query("SELECT siteId FROM siteAliases WHERE alias = \"" + alias + "\"")

	var sid int
	if uid != nil {
		uid.Next()
		uid.Scan(&sid)
	}
	fmt.Println(sid)

	if err != nil {
		fmt.Println("point 1" + err.Error())
		return "error_500", "Error 500"

		//if not it  will continue
	} else if sid == 0 {
		return "error_404", "Error 404"
	} else {
		return strconv.Itoa(sid), title
	}

}

//The login function
func logUserIn(username, password, token string, autoLoginToken string) string {

	//Now the Program does a query to ask if there is a Person that alreadly
	//has this username
	uid, err := database.Query("SELECT userid FROM user WHERE username = \"" + username + "\"")

	//if it would accur that there are several people with that username
	//we choose the first one (it wouldn#t matter but cannot be number 0)
	var usid int
	if uid != nil {
		uid.Next()
		uid.Scan(&usid)
	}

	//if there was an error a message is thrown
	if err != nil {
		fmt.Println("point 1" + err.Error())
		return "\n\nLogin unsuccessful.\n\n"

		//if not it  will continue
	} else {

		//now i ask the server for the userpassword which is stored as hash.
		pass, errr := database.Query("SELECT password FROM user WHERE userid = ?", usid)

		//if no error happened everything stays normal
		if errr == nil {

			//Now a variable is created to store the encrypted password on it
			var hash string

			for pass.Next() {
				errr = pass.Scan(&hash)
			}

			//then a message is sent based on the input

			//if the password is right and no error accured the login is successful
			if checkPasswordHash(password, hash) && errr == nil {
				database.Exec("INSERT INTO tokens (userid,token) VALUES (" + strconv.Itoa(usid) + ",\"" + token + "\")")
				if autoLoginToken != "" {

					database.Exec("INSERT INTO autoLoginTokens (userid,token) VALUES (" + strconv.Itoa(usid) + ",\"" + autoLoginToken + "\")")
				}
				return "\n\nLogin successful.\n\n"

				//if no error happened but the password was wrong.
			} else if errr == nil {
				return "\n\nPassword wrong.\n\n"

				//if some error popped up a message is sent.
			} else {
				fmt.Println("Point 2" + errr.Error())
				return "\n\nLogin unsuccessful.\n\n"
			}
			//if some error popped up a message is sent.
		} else {
			fmt.Println("Point 3" + errr.Error())
			return "\n\nLogin unsuccessful.\n\n"
		}

	}

	return ""

}

//The login function
func logUserInWithToken(autoLoginToken string, token string, ) string {

	uid, err := database.Query("SELECT userid FROM autoLoginTokens WHERE token = \"" + autoLoginToken + "\"")
	var usid int
	if uid != nil {
		uid.Next()
		uid.Scan(&usid)
	}
	fmt.Println(usid)

	if err != nil {
		fmt.Println("point 1" + err.Error())
		return "FAILED_500"

		//if not it  will continue
	} else if usid == 0 {
		return "FAILED_INVALID"
	} else {
		uid, err := database.Query("SELECT username FROM user WHERE userid = \"" + strconv.Itoa(usid) + "\"")
		var username string
		if uid != nil {
			uid.Next()
			uid.Scan(&username)
		}
		fmt.Println(username)

		if err != nil {
			fmt.Println("point 1" + err.Error())
			return "FAILED_500"

			//if not it  will continue
		} else if username == "" {
			return "FAILED_USERREMOVED"
		} else {

			database.Exec("INSERT INTO tokens (userid,token) VALUES (" + strconv.Itoa(usid) + ",\"" + token + "\")")
			return "SUCCESS_" + username

		}
	}

}

//The createUser function
func createUser(username, password, displayname, email string) string {
	//Now the Program does a query to ask if there is a Person that alreadly
	//has this username
	uid, err := database.Query("SELECT userid FROM user WHERE username = '" + username + "'")

	//if it would accur that there are several people with that username
	//we choose the first one (it wouldn't matter but cannot be number 0)
	var usid int
	if uid != nil {
		uid.Next()
		uid.Scan(&usid)
	}

	//if there was no error and no other user a new one will be created
	if usid == 0 && err == nil {

		//It starts by hashing the Password
		hash, errr := hashPassword(password)

		//If there is no error the new account will be created
		if errr == nil {
			database.Exec("INSERT INTO user (username,password,displayname,email) VALUES (\"" + username + "\",\"" + hash + "\",\"" + displayname + "\",\"" + email + "\")")
			return "\n\nNew User Created.\n\n"

			//Otherwise a message is produced
		} else {
			return "\n\nSomething went wrong.\n\n"
			fmt.Print(errr.Error())
		}

		//If there is a user already a message with his name and userid will be displayed
	} else if uid != nil && err == nil {
		return "\n\nUsername " + username + " with uid " + strconv.Itoa(usid) + " already used.\n\n"

		//if there was an error an error message will be sent
	} else if err != nil {
		return "\n\nSomething went wrong.\n\n"
		fmt.Print(err.Error())

		//The same as the first case.
	} else {

		//It starts by hashing the Password
		hash, errr := hashPassword(password)

		//If there is no error the new account will be created
		if errr == nil {
			database.Exec("INSERT INTO user (username,password,displayname,email) VALUES (\"" + username + "\",\"" + hash + "\",\"" + displayname + "\",\"" + email + "\")")
			return "\n\nNew User Created.\n\n"

			//Otherwise a message is produced
		} else {
			fmt.Print(err.Error())
			return "\n\nSomething went wrong.\n\n"
		}

	}

	return ""
}

//The createGroup function
func addUserToGroup(userId int64, groupId int64) string {
	uid, err := database.Query("SELECT userId FROM userGroups WHERE userId = '" + strconv.FormatInt(userId, 10) + "' AND groupId = '" + strconv.FormatInt(groupId, 10) + "'")
	var gid int
	if uid != nil {
		uid.Next()
		uid.Scan(&gid)
	}

	if gid == 0 && err == nil {

		if err == nil {
			database.Exec("INSERT INTO userGroups (userId,groupId) VALUES (" + strconv.FormatInt(userId, 10) + "," + strconv.FormatInt(groupId, 10) + ")")
			return "\n\nUser added to group.\n\n"

			//Otherwise a message is produced
		} else {
			return "\n\nSomething went wrong.\n\n"
			fmt.Print(err.Error())
		}

	} else if uid != nil && err == nil {
		return "User with id " + strconv.FormatInt(userId, 10) + " already in group " + strconv.FormatInt(groupId, 10) + "."

	} else if err != nil {
		return "Something went wrong."
		fmt.Print(err.Error())
	} else {

	}

	return ""
}

func createGroup(groupname string, visible bool) string {
	uid, err := database.Query("SELECT groupId FROM groups WHERE groupName = '" + groupname + "'")
	var gid int
	if uid != nil {
		uid.Next()
		uid.Scan(&gid)
	}

	if gid == 0 && err == nil {

		if err == nil {
			database.Exec("INSERT INTO groups (groupName,groupVisible) VALUES (\"" + groupname + "\"," + strconv.FormatBool(visible) + ")")
			return "\n\nNew Group Created.\n\n"

			//Otherwise a message is produced
		} else {
			return "\n\nSomething went wrong.\n\n"
			fmt.Print(err.Error())
		}

	} else if uid != nil && err == nil {
		return "GroupName " + groupname + " already used."

	} else if err != nil {
		return "Something went wrong."
		fmt.Print(err.Error())
	} else {

	}

	return ""
}

//a small function to display a message either per http response or console
func displaymsg(msg string, w *http.ResponseWriter) {
	if w == nil {
		fmt.Println(msg)
	} else {
		(*w).Write([]byte(msg))
	}
}

//a magical function that does encryption
func hashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

//this function somehow checks if a certain password can be a specific hash
func checkPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
