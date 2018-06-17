package main

import (
	"crypto/tls"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"golang.org/x/crypto/bcrypt"
	//"encode/json"
	_ "github.com/go-sql-driver/mysql"
)

var database *sql.DB

func main() {
	//Openng the Connection to the mysql data base,
	//checking for errors and setting the data base as global variable
	db, err := sql.Open("mysql", "root:testdb@tcp(localhost)/OS3?charset=utf8")
	if db != nil {
		fmt.Println(db)
	}
	checkErr(err)

	database = db

	//Setting the defaults if theyy don't exist
	checkDataBase(db)

	db.Close()

	//Defining mux as Handler
	mux := http.NewServeMux()

	//Choosing the appropiate Handlers for the right sub-directories
	mux.HandleFunc("/", rootHandler)
	mux.HandleFunc("/auth/login", loginHandler)
	mux.HandleFunc("/auth/register", registerHandler)

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
        
        fmt.Println(token)

		//Then the data gets passed into the login-function
		logUserIn(username[0], password[0], &w)

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
		createUser(username[0], password[0], displayname[0], email[0], &w)

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
	db.Exec("CREATE TABLE IF NOT EXISTS user(userid int NOT NULL AUTO_INCREMENT PRIMARY KEY,username VARCHAR(32) NOT NULL,password CHAR(64) NOT NULL,displayname VARCHAR(32),email VARCHAR(64))")

	//Creating a default user
	createUser("Tester", "geheim", "Beater", "", nil)
}

//Small function to enable cors
func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
}

//Small function to find errors and then panic
func checkErr(err error) {
	if err != nil {
		fmt.Println(err.Error())
		panic(err)
	}
}

//The login function
func logUserIn(username, password string, w *http.ResponseWriter) {

    //Now the Program does a query to ask if there is a Person that alreadly
    //has this username 
	uid, err := database.Query("SELECT userid FROM user WHERE username = \"" + username + "\"")

    //if it would accur that there are several people with that username
    //we choose the first one (it wouldn#t matter but cannot be number 0)
	var usid int
	if uid != nil {
		uid.Next()
	}
	uid.Scan(&usid)

    //if there was an error a message iss thrown
	if err != nil {
        (*w).Write([]byte("\n\nLogin unsuccessful.\n\n"))
    
    //if not it  will
	} else {

        //now i ask the server for the userpassword which is stored as hash.
		pass, errr := database.Query("SELECT password FROM user WHERE userid = ?", uid)

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
                (*w).Write([]byte("\n\nLogin successful.\n\n"))
            
            //if no error happened but the password was wrong.
			} else if errr == nil {
				(*w).Write([]byte("\n\nPassword wrong.\n\n"))
            
            //if some error popped up a message is sent.
            }else {
				(*w).Write([]byte("\n\nLogin unsuccessful.\n\n"))
            }
        //if some error popped up a message is sent.
		} else {
			(*w).Write([]byte("\n\nLogin unsuccessful.\n\n"))
		}

	}

}

//The createUser function
func createUser(username, password, displayname, email string, w *http.ResponseWriter) {
    //Now the Program does a query to ask if there is a Person that alreadly
    //has this username 
	uid, err := database.Query("SELECT userid FROM user WHERE username = '" + username + "'")
    
    //if it would accur that there are several people with that username
    //we choose the first one (it wouldn't matter but cannot be number 0)
	var usid int
	if uid != nil {
		uid.Next()
	}
    uid.Scan(&usid)(usid)
    

	if usid == 0 && err == nil {

		fmt.Println(len(password))
		hash, errr := hashPassword(password)
		fmt.Println(hash)

		if errr == nil {
			database.Exec("INSERT INTO user (username,password,displayname,email) VALUES (\"" + username + "\",\"" + hash + "\",\"" + displayname + "\",\"" + email + "\")")
			displaymsg("\n\nNew User Created.\n\n", w)
		} else {
			displaymsg("\n\nSomething went wrong.\n\n", w)
			fmt.Print(errr.Error())
		}

	} else if uid != nil && err == nil {
		displaymsg("\n\nUsername "+username+" with uid "+strconv.Itoa(usid)+" already used.\n\n", w)
	} else if err != nil {
		displaymsg("\n\nSomething went wrong.\n\n", w)
		fmt.Print(err.Error())
	} else {

		fmt.Println(len(password))
		hash, errr := hashPassword(password)

		if errr == nil {
			database.Exec("INSERT INTO user (username,password,displayname,email) VALUES (\"" + username + "\",\"" + hash + "\",\"" + displayname + "\",\"" + email + "\")")
			displaymsg("\n\nNew User Created.\n\n", w)
		} else {
			displaymsg("\n\nSomething went wrong.\n\n", w)
			fmt.Print(err.Error())
		}

	}

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
