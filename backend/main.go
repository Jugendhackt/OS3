package main

import (
	"crypto/tls"
	"database/sql"
	"fmt"
	"log"
    "net/http"
    //"encode/json"

	//"golang.org/x/crypto/bcrypt"

	_ "github.com/go-sql-driver/mysql"
)



func main() {
	db, err := sql.Open("mysql", "root:testdb@tcp(localhost)/OS3?charset=utf8")
	if db != nil {
		fmt.Println(db)
	}
	checkErr(err)

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

        uname := req.Form["username"]
        pass :=  req.Form["password"]
        token := req.Form["token"]

        fmt.Println(uname)
        fmt.Println(pass)
        fmt.Println(token)

        for _,text := range req.Form{
            fmt.Println(text)
        }
		
		w.Write([]byte("\n\nLogin successful.\n\n"))

	default:
		fmt.Printf("\n\n%v\n", req)
		fmt.Println(req.Form)
		w.Write([]byte("\nLogging in...\n\n"))

	}

	w.Write([]byte("Logging in...\n"))
}

func registerHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	w.Write([]byte("Registering...\n"))
}

func checkDataBase(db *sql.DB) {
	db.Exec("CREATE TABLE IF NOT EXISTS user(userid int NOT NULL PRIMARY KEY,username VARCHAR(32) NOT NULL,password CHAR(32) NOT NULL,displayname VARCHAR(32),profilePicture MEDIUMBLOB,email VARCHAR(64))")

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

/*
func hashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func checkPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
*/
