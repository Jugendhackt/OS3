package main

import (
	"strconv"
	"crypto/tls"
	"database/sql"
	"fmt"
	"log"
	"net/http"
    "io/ioutil"
	"golang.org/x/crypto/bcrypt"
	//"encode/json"

	_ "github.com/go-sql-driver/mysql"
)

var database *sql.DB

func main() {
	db, err := sql.Open("mysql", "root:testdb@tcp(localhost)/OS3?charset=utf8")
	if db != nil {
		fmt.Println(db)
	}
	checkErr(err)

	database = db

	checkDataBase(db)

	mux := http.NewServeMux()

	mux.HandleFunc("/", rootHandler)
	mux.HandleFunc("/auth/login", loginHandler)
	mux.HandleFunc("/auth/register", registerHandler)

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
	srv := &http.Server{
		Addr:         ":443",
		Handler:      mux,
		TLSConfig:    cfg,
		TLSNextProto: make(map[string]func(*http.Server, *tls.Conn, http.Handler), 0),
	}
	log.Fatal(srv.ListenAndServeTLS("server.rsa.crt", "server.rsa.key"))

	db.Close()
}

func rootHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	w.Write([]byte("This is a test server.\n"))
	//fmt.Printf("%v", req)
}

func loginHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	switch req.Method {
	case ("POST"):
		fmt.Println("\n\n\n")
		req.ParseForm()
		fmt.Printf("%v\n\n\n", req.Form)

		username := req.Form["username"]
		password := req.Form["password"]
		token := req.Form["token"]

		fmt.Println(username)
		fmt.Println(password)
		fmt.Println(token)

		uid, err := database.Query("SELECT userid FROM user WHERE username = \"" + username[0] + "\"")

        var usid int
        if uid != nil{uid.Next()}
        uid.Scan(&usid)

		if err != nil {
			w.Write([]byte("\n\nLogin unsuccessful.\n\n"))
		} else {
			pass, errr := database.Query("SELECT password FROM user WHERE userid = ?", uid)

			if errr == nil {

				var hash string

				for pass.Next() {
					errr = pass.Scan(&hash)
				}

				if checkPasswordHash(password[0], hash) && errr == nil {
					w.Write([]byte("\n\nLogin successful.\n\n"))
				} else if errr == nil {
					w.Write([]byte("\n\nPassword wrong.\n\n"))
				} else {
					w.Write([]byte("\n\nLogin unsuccessful.\n\n"))
				}
			} else {
				w.Write([]byte("\n\nLogin unsuccessful.\n\n"))
			}

		}

	default:
		fmt.Printf("\n\n%v\n", req)
		fmt.Println(req.Form)
		w.Write([]byte("\nLogging in...\n\n"))

	}

}

func registerHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")

	switch req.Method {
	case ("POST"):
		fmt.Println("\n\n\n")
		req.ParseForm()
		fmt.Printf("%v\n\n\n", req.Form)

		username := req.Form["username"]
		password := req.Form["password"]
		token := req.Form["token"]
		displayname := req.Form["displayname"]
		email := req.Form["email"]

		fmt.Println(username)
		fmt.Println(password)
		fmt.Println(token)
		fmt.Println(displayname)
		fmt.Println(email)

        createUser(username[0],password[0],displayname[0],email[0], &w)		

	default:
		fmt.Printf("\n\n%v\n", req)
        fmt.Println(req.Form)
        body, _ := ioutil.ReadFile("register.html")
		w.Write(body)

	}

}

func checkDataBase(db *sql.DB) {
	db.Exec("CREATE TABLE IF NOT EXISTS user(userid int NOT NULL AUTO_INCREMENT PRIMARY KEY,username VARCHAR(32) NOT NULL,password CHAR(64) NOT NULL,displayname VARCHAR(32),email VARCHAR(64))")

    createUser("Tester","geheim","Beater","",nil)

	/*
			if rows != nil {
		        fmt.Printf("%v\n", rows)

		        for rows.Next() {
		            var e1 int
		            var e2 int
		            var e3 int
		            var e4 int
		            err = rows.Scan(&e1, &e2, &e3, &e4)
		            checkErr(err)
		            fmt.Printf("%v;%v;%v;%v\n",e1,e2,e3,e4)
		        }
		    }

			checkErr(err)
	*/
}

func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
}

func checkErr(err error) {
	if err != nil {
		fmt.Println(err.Error())
		panic(err)
	}
}

func createUser(username,password,displayname,email string, w *http.ResponseWriter){
    uid, err := database.Query("SELECT userid FROM user WHERE username = '" + username + "'")
    fmt.Println("SELECT userid FROM user WHERE username = '" + username + "'")
    var usid int
    fmt.Println(username)
	fmt.Println(password)
	fmt.Println(displayname)
    fmt.Println(email)
    if uid != nil{uid.Next()}
    uid.Scan(&usid)
    fmt.Println(usid)
        if usid == 0 && err == nil{

            fmt.Println(len(password))
			hash, errr := hashPassword(password)
            fmt.Println(hash)

            if errr == nil{
                database.Exec("INSERT INTO user (username,password,displayname,email) VALUES (\"" + username + "\",\"" + hash + "\",\"" + displayname + "\",\"" + email + "\")")
                displaymsg("\n\nNew User Created.\n\n", w)
            }else{
                displaymsg("\n\nSomething went wrong.\n\n", w)
                fmt.Print(errr.Error())
            }

        }else if uid != nil && err == nil {
			displaymsg("\n\nUsername " + username + " with uid " + strconv.Itoa(usid) + " already used.\n\n", w)
		} else if err != nil {
            displaymsg("\n\nSomething went wrong.\n\n", w)
            fmt.Print(err.Error())
		} else {

            fmt.Println(len(password))
			hash, errr := hashPassword(password)

            if errr == nil{
                database.Exec("INSERT INTO user (username,password,displayname,email) VALUES (\"" + username + "\",\"" + hash + "\",\"" + displayname + "\",\"" + email + "\")")
                displaymsg("\n\nNew User Created.\n\n", w)
            }else{
                displaymsg("\n\nSomething went wrong.\n\n", w)
                fmt.Print(err.Error())
            }

        }
        
}

func displaymsg(msg string, w *http.ResponseWriter){
    if w == nil{
        fmt.Println(msg)
    }else{
        (*w).Write([]byte(msg))
    }
}

func hashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func checkPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
