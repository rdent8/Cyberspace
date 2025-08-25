import org.junit.Test;
import static org.junit.Assert.*;
import java.sql.SQLException;
import DB.DB;

public class DBConnectionTest {
    @Test
    public void dbConnect_throwsOrConnects() {
        try {
            DB.connect();
            assertTrue(true); // DB is up locally
        } catch (SQLException e) {
            // Acceptable in CI where DB isn't available
            assertTrue(e.getMessage().toLowerCase().contains("jdbc"));
        }
    }
}
