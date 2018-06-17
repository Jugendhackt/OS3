package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"crypto/tls"
)

func main(){

	fmt.Println("Starting...")
	url := "https://localhost:443/auth/register"

	conf := &tls.Config{
		InsecureSkipVerify : true,
	}

	tr := &http.Transport{TLSClientConfig : conf}
	client := &http.Client{Transport: tr}
	response,err := client.Get(url)

	if err != nil{
		fmt.Println(err.Error())
	}

	defer response.Body.Close()

	userString := map[string]string{
		"username" : "test", 
		"password" : "geheim",
		"displayname" : "beater", 
		"email" : "", 
		"token" : "somevalues",
	}

	jsonVal, _ := json.Marshal(userString)

	resp, err := client.Post(url, "application/json", bytes.NewBuffer(jsonVal))

	if err == nil{
		fmt.Println(resp)
	}else{
		fmt.Println(err.Error())
	}

}