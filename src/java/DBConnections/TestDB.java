package DBConnections;
import static DBConnections.DBConnections.getConnection;
import java.sql.Connection;


public class TestDB {
    public static void main(String[] args) {
        System.out.println("✅ DBConnections loaded successfully!");
        
        try {
            // Just calling a static method to test connection
             Connection conn =  getConnection();
            System.out.println("✅ Connected to database!");
        } catch (Exception e) {
            System.err.println("❌ Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}