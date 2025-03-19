package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.mindrot.jbcrypt.*;

import dao.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Hash password before storing it in DB
//        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try (Connection con = DatabaseConnection.getConnection()) {
            // Start transaction
            con.setAutoCommit(false);

            // Generate Unique Account Number
            long accountNumber = generateUniqueAccountNumber(con);

            // Insert into users table
            String query = "INSERT INTO users (name, address, contact, email, password, account_number) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, name);
                ps.setString(2, address);
                ps.setString(3, contact);
                ps.setString(4, email);
                ps.setString(5, password);
                ps.setLong(6, accountNumber);

                int rowsInserted = ps.executeUpdate();
                if (rowsInserted > 0) {
                    // Insert account entry in accounts table
                    String accountQuery = "INSERT INTO accounts (account_number, user_id, balance) VALUES (?, (SELECT user_id FROM users WHERE email = ?), ?)";
                    try (PreparedStatement accPs = con.prepareStatement(accountQuery)) {
                        accPs.setLong(1, accountNumber);
                        accPs.setString(2, email);
                        accPs.setDouble(3, 0.00); // Default balance

                        int accountInserted = accPs.executeUpdate();
                        if (accountInserted > 0) {
                            con.commit(); // Commit transaction
                            response.sendRedirect("login.jsp"); // Redirect to login
                        } else {
                            con.rollback();
                            response.sendRedirect("register.jsp?error=Account creation failed");
                        }
                    }
                } else {
                    con.rollback();
                    response.sendRedirect("register.jsp?error=Registration failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    // Generate a unique 13-digit account number
    private long generateUniqueAccountNumber(Connection con) throws SQLException {
        long accountNumber;
        do {
            accountNumber = (long) (Math.random() * 9_000_000_000_000L) + 1_000_000_000_000L;
        } while (isAccountNumberExists(con, accountNumber));
        return accountNumber;
    }

    // Check if the generated account number already exists
    private boolean isAccountNumberExists(Connection con, long accountNumber) throws SQLException {
        String query = "SELECT 1 FROM accounts WHERE account_number = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
