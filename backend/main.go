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

	_ "github.com/go-sql-driver/mysql"
	"golang.org/x/crypto/bcrypt"
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

	//Choosing the appropiate Handlers for the right sub-directories
	mux.HandleFunc("/", rootHandler)
	mux.HandleFunc("/auth/login", loginHandler)
	//mux.HandleFunc("/auth/tokenLogin", tokenLoginHandler)
	mux.HandleFunc("/auth/register", registerHandler)
	mux.HandleFunc("/site/", folderHandler)
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
	enableCors(&w)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	w.Write([]byte("This is a test server.\n"))
}

func folderHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	http.ServeFile(w, req, "."+req.URL.Path)
}

/*
The Login Handler handles the user login (pretty obvious)
and delivers specific messages depending on the access type
*/
func loginHandler(w http.ResponseWriter, req *http.Request) {
	//First we have to enable cors and STS
	enableCors(&w)
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

		fmt.Println(token)

		//Then the data gets passed into the login-function
		displaymsg(logUserIn(username[0], password[0], token[0]), &w)

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
	enableCors(&w)
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

	//Creating a default user
	fmt.Println(createUser("Tester", "geheim", "Beater", ""))

	fmt.Println(logUserIn("Tester", "geheim", "fauwhwaduwdawdf"))

	username, action := tokenLogIn("fauwhwaduwdawdf")

	fmt.Printf("%v, %v\n", username, action)
}

//Small function to enable cors
func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
	(*w).Header().Set("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT")
	(*w).Header().Set("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, token")
}

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

//The login function
func logUserIn(username, password, token string) string {

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
