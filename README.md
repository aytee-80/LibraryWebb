# LibraryWebb

A Java web application built with NetBeans and GlassFish.

## Requirements
- JDK 8
- PostgreSQL database
- Docker (optional)

## How to Run Locally
1. Open in NetBeans
2. Right-click > `Clean and Build`
3. Deploy using `Run` or `docker build -t librarywebb . && docker run -p 8000:8080 librarywebb`

## Docker Deployment
```bash
docker build -t librarywebb .
docker run -d -p 8000:8080 --name librarywebb-container librarywebb