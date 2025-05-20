package DBConnections;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnections {

    // Update these values according to your MySQL server
    private static final String URL = "jdbc:mysql://192.168.33.155:3306/library?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC";
    private static final String USER = "aytee8"; 
    private static final String PASSWORD = "123";

    // Static block to initialize database when class loads
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL driver
            initializeDatabase(); // Create tables if not exist
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found.");
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
    private static void initializeDatabase() throws SQLException {
    String createCategoriesTable = 
        "CREATE TABLE IF NOT EXISTS Categories ("
        + "CategoryID INT AUTO_INCREMENT PRIMARY KEY, "
        + "CategoryName VARCHAR(100) NOT NULL UNIQUE"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

    String createUsersTable = 
        "CREATE TABLE IF NOT EXISTS Users ("
        + "UserID INT AUTO_INCREMENT PRIMARY KEY, "
        + "Name VARCHAR(100) NOT NULL, "
        + "Email VARCHAR(100) NOT NULL UNIQUE, "
        + "Password VARCHAR(255) NOT NULL, "
        + "Role ENUM('Member', 'Librarian') DEFAULT 'Member', "
        + "CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

    String createBooksTable = 
        "CREATE TABLE IF NOT EXISTS Books ("
        + "BookID INT AUTO_INCREMENT PRIMARY KEY, "
        + "Title VARCHAR(255) NOT NULL, "
        + "Author VARCHAR(255) NOT NULL, "
        + "ISBN VARCHAR(13) NOT NULL UNIQUE, "
        + "Category VARCHAR(100), "
        + "Status ENUM('Available', 'Borrowed', 'Reserved', 'Lost') DEFAULT 'Available', "
        + "Image LONGBLOB, "
        + "borrowed_by_member_id INT NULL, "
        + "FOREIGN KEY (borrowed_by_member_id) REFERENCES Users(UserID)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

    String createBorrowedBooksTable =
        "CREATE TABLE IF NOT EXISTS BorrowedBooks ("
        + "BorrowID INT AUTO_INCREMENT PRIMARY KEY, "
        + "BookID INT NOT NULL, "
        + "userID INT NOT NULL, "
        + "UserEmail VARCHAR(100) NOT NULL, "
        + "ContactNumber VARCHAR(20), "
        + "BorrowDate DATE NOT NULL, "
        + "returnbookdate DATE NOT NULL, "
        + "ReturnStatus ENUM('Pending', 'Returned') DEFAULT 'Pending', "
        + "FOREIGN KEY (BookID) REFERENCES Books(BookID), "
        + "FOREIGN KEY (userID) REFERENCES Users(UserID)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

    String createReservedBooksTable =
        "CREATE TABLE IF NOT EXISTS ReservedBooks ("
        + "ReservationID INT AUTO_INCREMENT PRIMARY KEY, "
        + "BookID INT NOT NULL, "
        + "userID INT NOT NULL, "
        + "UserEmail VARCHAR(100) NOT NULL, "
        + "ReservationDate DATE NOT NULL, "
        + "ExpiryDate DATE NOT NULL, "
        + "Status ENUM('Active', 'Completed', 'Expired') DEFAULT 'Active', "
        + "FOREIGN KEY (BookID) REFERENCES Books(BookID), "
        + "FOREIGN KEY (userID) REFERENCES Users(UserID)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

    try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
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
    public static void addBook(String title, String author, String isbn, String category, String status, InputStream imageStream) throws SQLException {
        String sql = "INSERT INTO Books (Title, Author, ISBN, Category, Status, Image) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, isbn);
            pstmt.setString(4, category);
            pstmt.setString(5, status);
            if (imageStream != null) {
                pstmt.setBinaryStream(6, imageStream); // Save image as byte stream
            } else {
                pstmt.setNull(6, java.sql.Types.BLOB); // Handle null image
            }
            pstmt.executeUpdate();
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
    public static ResultSet AvailableBooks() throws SQLException {
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