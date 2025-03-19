package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;

import dao.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/DepositServlet")
public class DepositServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int accountNumber = (int) session.getAttribute("account_number");  // Get account number from session
        BigDecimal amount = new BigDecimal(request.getParameter("amount"));

        try (Connection con = DatabaseConnection.getConnection()) {
            // Update balance
            String updateBalance = "UPDATE users SET balance = balance + ? WHERE account_number = ?";
            try (PreparedStatement ps = con.prepareStatement(updateBalance)) {
                ps.setBigDecimal(1, amount);
                ps.setInt(2, accountNumber);
                ps.executeUpdate();
            }

            // Insert transaction
            String insertTransaction = "INSERT INTO transactions (account_number, transaction_type, amount) VALUES (?, 'Deposit', ?)";
            try (PreparedStatement ps = con.prepareStatement(insertTransaction)) {
                ps.setInt(1, accountNumber);
                ps.setBigDecimal(2, amount);
                ps.executeUpdate();
            }

            response.sendRedirect("dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
