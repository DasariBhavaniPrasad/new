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

@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int senderAccount = (int) session.getAttribute("account_number");
        int recipientAccount = Integer.parseInt(request.getParameter("recipient_account"));
        BigDecimal amount = new BigDecimal(request.getParameter("amount"));

        try (Connection con = DatabaseConnection.getConnection()) {
            // Check sender balance
            String checkBalance = "SELECT balance FROM users WHERE account_number = ?";
            PreparedStatement psCheck = con.prepareStatement(checkBalance);
            psCheck.setInt(1, senderAccount);
            java.sql.ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                BigDecimal senderBalance = rs.getBigDecimal("balance");

                if (senderBalance.compareTo(amount) >= 0) { // Sufficient balance
                    // Deduct amount from sender
                    String deductBalance = "UPDATE users SET balance = balance - ? WHERE account_number = ?";
                    try (PreparedStatement psDeduct = con.prepareStatement(deductBalance)) {
                        psDeduct.setBigDecimal(1, amount);
                        psDeduct.setInt(2, senderAccount);
                        psDeduct.executeUpdate();
                    }

                    // Add amount to recipient
                    String addBalance = "UPDATE users SET balance = balance + ? WHERE account_number = ?";
                    try (PreparedStatement psAdd = con.prepareStatement(addBalance)) {
                        psAdd.setBigDecimal(1, amount);
                        psAdd.setInt(2, recipientAccount);
                        psAdd.executeUpdate();
                    }

                    // Insert transaction
                    String insertTransaction = "INSERT INTO transactions (account_number, transaction_type, amount) VALUES (?, 'Transfer', ?)";
                    try (PreparedStatement psSenderTransaction = con.prepareStatement(insertTransaction)) {
                        psSenderTransaction.setInt(1, senderAccount);
                        psSenderTransaction.setBigDecimal(2, amount.negate()); // Negative for sender
                        psSenderTransaction.executeUpdate();
                    }

                    try (PreparedStatement psRecipientTransaction = con.prepareStatement(insertTransaction)) {
                        psRecipientTransaction.setInt(1, recipientAccount);
                        psRecipientTransaction.setBigDecimal(2, amount); // Positive for recipient
                        psRecipientTransaction.executeUpdate();
                    }
                }
            }

            response.sendRedirect("dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
