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
* I added pictures of the web application below

* ![Screenshot 2025-06-28 180602](https://github.com/user-attachments/assets/ed70d5c6-c147-4ea9-b6cd-6d7164dbee34)
* ![Screenshot 2025-06-28 180824](https://github.com/user-attachments/assets/bdcec397-767c-4380-ae39-d7f67b688f28)
* ![Screenshot 2025-06-28 18![Screenshot 2025-06-28 181013](https://github.com/user-attachments/assets/68a5a375-bad6-4228-bc22-d1a1abeee18e)
![Screenshot 2025-06-28 183753](https://github.com/user-attachments/assets/92df1724-aa87-4f4c-8fc0-335111f199de)
![Screenshot 2025-06-28 183735](https://github.com/user-attachments/assets/31757843-5079-4277-88fd-0d8f64653b97)
![Screenshot 2025-06-28 183701](https://github.com/user-attachments/assets/928bc66a-c610-4eb4-9f6d-7303e492ac1d)
![Screenshot 2025-06-28 183613](https://github.com/user-attachments/assets/bae2a430-79ca-4f1d-9ae3-868511c98392)
![Screenshot 2025-06-28 183527](https://github.com/user-attachments/assets/9897e774-24ed-4ad3-8c1f-6471d4ac617f)
![Screenshot 2025-06-28 183444](https://github.com/user-attachments/assets/b4effaea-b1d4-4f55-85e3-51f373a2dd65)
![Screenshot 2025-06-28 181502](https://github.com/user-attachments/assets/205cfc23-91da-47d9-9087-c06e121c3abe)
![Screenshot 2025-06-28 181342](https://github.com/user-attachments/assets/660e794d-0cdd-4edf-a368-3f16cc9ca56a)
![Screenshot 2025-06-28 181308](https://github.com/user-attachments/assets/b61b58fb-5327-47b5-aeb7-8185323943df)
![Screenshot 2025-06-28 181225](https://github.com/user-attachments/assets/3cc57a34-586d-432e-a26b-aba9c2c979aa)
![Screenshot 2025-06-28 181134](https://github.com/user-attachments/assets/c24ceb4f-5949-4260-9d30-3f0ef8e125ea)
![Screenshot 2025-06-28 181050](https://github.com/user-attachments/assets/7ab9e64e-1a8b-402a-b3f6-9664090b707f)
0916](https://github.com/user-attachments/assets/77f677ae-b9ba-4596-8454-26c0e5803e4f)
* 



