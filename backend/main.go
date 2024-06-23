package main

import (
  "fmt"
  "log"
  "net/http"
  "go.mongodb.org/mongo-driver/mongo"
  "go.mongodb.org/mongo-driver/mongo/options"
  "context"
  "time"
)

func main() {
  client, err := mongo.NewClient(options.Client().ApplyURI("mongodb://localhost:27017"))
  if err != nil {
    log.Fatal(err)
  }
  ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
  defer cancel()
  err = client.Connect(ctx)
  if err != nil {
    log.Fatal(err)
  }
  defer client.Disconnect(ctx)
  
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello World!")
  })
  
  fmt.Println("Server is running on port 8080...")
  log.Fatal(http.ListenAndServe(":8080", nil))
}
