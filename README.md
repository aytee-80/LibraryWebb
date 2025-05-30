# LibraryWebb

-A Java web application built with NetBeans and GlassFish.
-You can view books,add books,register,login,borrow,reserve,return books.
-It's more like a library but online
-Either register as a member or Librarian
-They Both have Different functionalities

## Requirements
- JDK 8
- PostgreSQL database
- Docker (optional)

## How to Run Locally
1. Open in NetBeans
2. Right-click > `Clean and Build`
3. Deploy using `Run`
4. Run it with glassfish web Application or any other web application that supports war file

## PostgreSQL 
1. I used renders's postgreSQL database to add data
2. Since i'm on free mode the database expires on 16 june 2025
3. The application won't be functional so you have to download the whole application
4. Change the database connection in the DBConnection java file use yours
5. It will automatically create the database tables and the database
6. To confirm that it connected go to the testDB.java run it alone it will show you if it's connected or not
7. Only postgreSQL database will work
8. Unless you change it
9. The Application turn to get slow when trying to access the postgreSQL data , might be the internet cause the database is online or might be that the data is too big cause i added images

## Docker Deployment
I Tried to run it on docker but it's giving me problems when i try to deploy it on render. 
so if you have a web application that can support war file deploy it with that.
