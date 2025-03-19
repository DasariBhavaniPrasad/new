package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dao.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/WithdrawServlet")
public class WithdrawServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // ✅ Check if user is logged in
        if (session == null || session.getAttribute("account_number") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accountNumber = (String) session.getAttribute("account_number"); // ✅ Using String (VARCHAR(13))
        BigDecimal amount = new BigDecimal(request.getParameter("amount").trim());
        String transactionType = "Withdrawal";

        try (Connection con = DatabaseConnection.getConnection()) {
            // ✅ Check if user has sufficient balance
            String checkBalanceQuery = "SELECT balance FROM users WHERE account_number = ?";
            try (PreparedStatement psCheck = con.prepareStatement(checkBalanceQuery)) {
                psCheck.setString(1, accountNumber);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        BigDecimal currentBalance = rs.getBigDecimal("balance");

                        if (currentBalance.compareTo(amount) >= 0) { // ✅ Sufficient balance
                            con.setAutoCommit(false); // ✅ Start transaction

                            // ✅ Update user's balance
                            String updateBalanceQuery = "UPDATE users SET balance = balance - ? WHERE account_number = ?";
                            try (PreparedStatement psUpdate = con.prepareStatement(updateBalanceQuery)) {
                                psUpdate.setBigDecimal(1, amount);
                                psUpdate.setString(2, accountNumber);
                                psUpdate.executeUpdate();
                            }

                            // ✅ Insert transaction record
                            String insertTransactionQuery = "INSERT INTO transactions (account_number, transaction_type, amount, transaction_date) VALUES (?, ?, ?, NOW())";
                            try (PreparedStatement ps = con.prepareStatement(insertTransactionQuery)) {
                                ps.setString(1, accountNumber);
                                ps.setString(2, transactionType);
                                ps.setBigDecimal(3, amount);
                                ps.executeUpdate();
                            }

                            con.commit(); // ✅ Commit transaction
                            session.setAttribute("message", "Withdrawal successful!");
                        } else {
                            session.setAttribute("error", "Insufficient balance.");
                        }
                    } else {
                        session.setAttribute("error", "Account not found.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Transaction failed. Please try again.");
        }

        response.sendRedirect("dashboard.jsp");
    }
}
