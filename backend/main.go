package main

import (
	"crypto/tls"
	"database/sql"
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
    db, err := sql.Open("mysql", "root:testdb@tcp(localhost)/OS3?charset=utf8")
    if db != nil{
        fmt.Println(db)
    }
	checkErr(err)

    rows, err := db.Query("SELECT * FROM test")
    if rows != nil{
        fmt.Println(rows)
    }
    checkErr(err)

    for rows.Next() {
        var e1 int
        var e2 int
        var e3 int
        var e4 int
        err = rows.Scan(&e1, &e2, &e3, &e4)
        checkErr(err)
        fmt.Println(e1)
        fmt.Println(e2)
        fmt.Println(e3)
        fmt.Println(e4)
    }

	db.Close()

	mux := http.NewServeMux()
	mux.HandleFunc("/", rootHandler)
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
}

func rootHandler(w http.ResponseWriter, req *http.Request) {
	enableCors(&w)
	w.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	w.Write([]byte("This is a test server.\n"))
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
