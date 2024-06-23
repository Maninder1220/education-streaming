
#!/bin/bash

# Function to install Node.js dependencies
install_node_dependencies() {
  echo "Installing Node.js dependencies..."
  npm install express mongoose
}

# Function to set up Express.js project
setup_express() {
  echo "Setting up Express.js project..."
  mkdir frontend
  cd frontend
  npm init -y

  install_node_dependencies

  # Create basic server.js file
  cat <<EOL > server.js
const express = require('express');
const mongoose = require('mongoose');
const app = express();

mongoose.connect('mongodb://localhost:27017/mydatabase', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected...'))
  .catch(err => console.log(err));

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Hello World!');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOL

  # Create basic index.html file
  mkdir public
  cat <<EOL > public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Project</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h1>Hello World!</h1>
  <script src="script.js"></script>
</body>
</html>
EOL

  # Create basic styles.css file
  cat <<EOL > public/styles.css
body {
  font-family: Arial, sans-serif;
}
EOL

  # Create basic script.js file
  cat <<EOL > public/script.js
console.log('Hello World!');
EOL

  cd ..
}

# Function to set up Go backend
setup_go_backend() {
  echo "Setting up Go backend..."
  mkdir backend
  cd backend

  # Create main.go file
  cat <<EOL > main.go
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
EOL

  # Initialize Go module
  go mod init backend

  # Install MongoDB driver
  go get go.mongodb.org/mongo-driver/mongo
  go get go.mongodb.org/mongo-driver/mongo/options

  cd ..
}

# Function to setup MongoDB
setup_mongodb() {
  echo "Setting up MongoDB..."
  mkdir -p /data/db
  mongod --dbpath /data/db &
}

# Run the setup functions
setup_express
setup_go_backend
setup_mongodb

echo "Project setup complete."

