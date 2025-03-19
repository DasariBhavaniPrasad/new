package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_number") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accNumberStr = (String) session.getAttribute("account_number");
        long accNumber = Long.parseLong(accNumberStr);

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");
        String address = request.getParameter("address");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = dao.DatabaseConnection.getConnection();
            String updateQuery = "UPDATE users SET name=?, email=?, contact=?, address=? WHERE account_number=?";
            ps = con.prepareStatement(updateQuery);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, contact);
            ps.setString(4, address);
            ps.setLong(5, accNumber);

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                session.setAttribute("name", name); // Update session value
                response.sendRedirect("profile.jsp?success=Profile Updated");
            } else {
                response.sendRedirect("profile.jsp?error=Update Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Database Error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}

