title build
go get github.com/go-sql-driver/mysql
go get golang.org/x/crypto/bcrypt
copy login.json.default login.json
openssl req -x509 -nodes -newkey rsa:2048 -keyout server.rsa.key -out server.rsa.crt -days 3650
go build main.go