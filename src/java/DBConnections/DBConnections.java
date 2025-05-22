package DBConnections;

import java.io.InputStream;
import java.sql.*;

public class DBConnections {

    // PostgreSQL database connection details
private static final String URL = "jdbc:postgresql://dpg-d0k6omre5dus73bgro6g-a.oregon-postgres.render.com/medicatiion_app?sslmode=require";
    private static final String USER = "aytee7"; 
    private static final String PASSWORD = "LqpUqXEqCQ78jxDG7nc0Rk3qFHoDPOm0";

    // Static block to initialize database when class loads
    static {
        try {
            Class.forName("org.postgresql.Driver"); // Load PostgreSQL driver
            initializeDatabase(); // Create tables if not exist
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL driver NOT FOUND!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Failed to initialize database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Establish database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    

    // Initialize database tables if they don't exist
    public static void initializeDatabase() throws SQLException {
        // Define ENUM types
        String createUserRoleEnum = "DO $$ BEGIN " +
                "IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN " +
                "CREATE TYPE user_role AS ENUM ('Member', 'Librarian'); " +
                "END IF; " +
                "END $$;";

        String createBookStatusEnum = "DO $$ BEGIN " +
                "IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'book_status') THEN " +
                "CREATE TYPE book_status AS ENUM ('Available', 'Borrowed', 'Reserved', 'Lost'); " +
                "END IF; " +
                "END $$;";

        String createReturnStatusEnum = "DO $$ BEGIN " +
                "IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'return_status') THEN " +
                "CREATE TYPE return_status AS ENUM ('Pending', 'Returned'); " +
                "END IF; " +
                "END $$;";

        String createReservationStatusEnum = "DO $$ BEGIN " +
                "IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'reservation_status') THEN " +
                "CREATE TYPE reservation_status AS ENUM ('Active', 'Completed', 'Expired'); " +
                "END IF; " +
                "END $$;";

        // Create tables
        String createCategoriesTable = 
            "CREATE TABLE IF NOT EXISTS Categories (" +
            "CategoryID SERIAL PRIMARY KEY, " +
            "CategoryName VARCHAR(100) NOT NULL UNIQUE" +
            ");";

        String createUsersTable = 
            "CREATE TABLE IF NOT EXISTS Users2 (" +
            "UserID SERIAL PRIMARY KEY, " +
            "Name VARCHAR(100) NOT NULL, " +
            "Email VARCHAR(100) NOT NULL UNIQUE, " +
            "Password VARCHAR(255) NOT NULL, " +
            "Role user_role DEFAULT 'Member', " +
            "CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ");";

        String createBooksTable = 
            "CREATE TABLE IF NOT EXISTS Books (" +
            "BookID SERIAL PRIMARY KEY, " +
            "Title VARCHAR(255) NOT NULL, " +
            "Author VARCHAR(255) NOT NULL, " +
            "ISBN VARCHAR(13) NOT NULL UNIQUE, " +
            "Category VARCHAR(100), " +
            "Status book_status DEFAULT 'Available', " +
            "Image BYTEA, " +
            "borrowed_by_member_id INT NULL, " +
            "FOREIGN KEY (borrowed_by_member_id) REFERENCES Users(UserID)" +
            ");";

        String createBorrowedBooksTable =
            "CREATE TABLE IF NOT EXISTS BorrowedBooks (" +
            "BorrowID SERIAL PRIMARY KEY, " +
            "BookID INT NOT NULL, " +
            "userID INT NOT NULL, " +
            "UserEmail VARCHAR(100) NOT NULL, " +
            "ContactNumber VARCHAR(20), " +
            "BorrowDate DATE NOT NULL, " +
            "returnbookdate DATE NOT NULL, " +
            "ReturnStatus return_status DEFAULT 'Pending', " +
            "FOREIGN KEY (BookID) REFERENCES Books(BookID), " +
            "FOREIGN KEY (userID) REFERENCES Users(UserID)" +
            ");";

        String createReservedBooksTable =
            "CREATE TABLE IF NOT EXISTS ReservedBooks (" +
            "ReservationID SERIAL PRIMARY KEY, " +
            "BookID INT NOT NULL, " +
            "userID INT NOT NULL, " +
            "UserEmail VARCHAR(100) NOT NULL, " +
            "ReservationDate DATE NOT NULL, " +
            "ExpiryDate DATE NOT NULL, " +
            "Status reservation_status DEFAULT 'Active', " +
            "FOREIGN KEY (BookID) REFERENCES Books(BookID), " +
            "FOREIGN KEY (userID) REFERENCES Users(UserID)" +
            ");";

        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            // Create ENUM types
            stmt.execute(createUserRoleEnum);
            stmt.execute(createBookStatusEnum);
            stmt.execute(createReturnStatusEnum);
            stmt.execute(createReservationStatusEnum);

            // Create tables
            stmt.execute(createCategoriesTable);
            stmt.execute(createUsersTable);
            stmt.execute(createBooksTable);
            stmt.execute(createBorrowedBooksTable);
            stmt.execute(createReservedBooksTable);

            System.out.println("✅ Database and tables initialized successfully.");
        } catch (SQLException ex) {
            System.err.println("❌ Error initializing database: " + ex.getMessage());
            throw ex;
        }
    }

    // Method to add a new book WITH an image
    public static void addBook(String title, String author, String isbn,
                           String category, String status, InputStream imageStream) throws SQLException {

    String sql = "INSERT INTO Books (Title, Author, ISBN, Category, Status, Image) " +
                 "VALUES (?, ?, ?, ?, ?, ?)";
    try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, title);
        stmt.setString(2, author);
        stmt.setString(3, isbn);
        stmt.setString(4, category);
        stmt.setString(5, status);

        if (imageStream != null) {
            stmt.setBinaryStream(6, imageStream);
        } else {
            stmt.setNull(6, java.sql.Types.BINARY);
        }

        stmt.executeUpdate();
    }
}

    // Method to add a new book WITHOUT an image
    public static void addBook(String title, String author, String isbn, String category, String status) throws SQLException {
        String sql = "INSERT INTO Books (Title, Author, ISBN, Category, Status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, isbn);
            pstmt.setString(4, category);
            pstmt.setString(5, status);
            pstmt.executeUpdate();
        }
    }

    // Method to update an existing book
    public static void updateBook(int id, String title, String author, String isbn, String category, String status) throws SQLException {
        String sql = "UPDATE Books SET Title = ?, Author = ?, ISBN = ?, Category = ?, Status = ? WHERE BookID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, isbn);
            pstmt.setString(4, category);
            pstmt.setString(5, status);
            pstmt.setInt(6, id);
            pstmt.executeUpdate();
        }
    }

    // Method to delete a book
    public static void deleteBook(int id) throws SQLException {
        String sql = "DELETE FROM Books WHERE BookID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }

    // Method to list all books
    public static ResultSet listBooks() throws SQLException {
        String sql = "SELECT * FROM Books";
        Connection conn = getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        return pstmt.executeQuery();
    }

    // Method to list only available books
    public static ResultSet availableBooks() throws SQLException {
        String sql = "SELECT * FROM Books WHERE Status = 'Available'";
        Connection conn = getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        return pstmt.executeQuery();
    }

    // Method to get a book's image by ID
    public static InputStream getBookImage(int bookId) throws SQLException {
        String sql = "SELECT Image FROM Books WHERE BookID = ?";
        Connection conn = getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, bookId);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getBinaryStream("Image");
        }
        return null;
    }
}
