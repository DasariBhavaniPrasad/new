<%@ page import="java.sql.*"%>
<%
HttpSession userSession = request.getSession(false);
if (userSession == null || userSession.getAttribute("account_number") == null) {
    response.sendRedirect("login.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    con = dao.DatabaseConnection.getConnection();
    String accNumberStr = (String) userSession.getAttribute("account_number");
    long accNumber = Long.parseLong(accNumberStr);

    String query = "SELECT name, email, contact, address FROM users WHERE account_number=?";
    ps = con.prepareStatement(query);
    ps.setLong(1, accNumber);
    rs = ps.executeQuery();

    String name = "", email = "", contact = "", address = "";
    if (rs.next()) {
        name = rs.getString("name");
        email = rs.getString("email");
        contact = rs.getString("contact");
        address = rs.getString("address");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url('background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            text-align: center;
        }

        .container {
            width: 50%;
            margin: 50px auto;
            background: rgba(0, 0, 0, 0.6);
            padding: 20px;
            border-radius: 10px;
        }

        input, textarea {
            width: 100%;
            padding: 8px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
        }

        .update-btn {
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .update-btn:hover {
            background: #0056b3;
        }

        .back-btn {
            padding: 10px 20px;
            background: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 10px;
        }

        .back-btn:hover {
            background: #c82333;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Update Profile</h2>
        <form action="UpdateProfileServlet" method="post">
            <input type="text" name="name" value="<%= name %>" required>
            <input type="email" name="email" value="<%= email %>" required>
            <input type="text" name="contact" value="<%= contact %>" required>
            <textarea name="address" required><%= address %></textarea>
            <button type="submit" class="update-btn">Save Changes</button>
        </form>
        <a href="profile.jsp" class="back-btn">Cancel</a>
    </div>

</body>
</html>

<%
} catch (Exception e) {
    e.printStackTrace();
    out.println("<p style='color:red;'>Error fetching profile details.</p>");
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException e) {}
    if (ps != null) try { ps.close(); } catch (SQLException e) {}
    if (con != null) try { con.close(); } catch (SQLException e) {}
}
%>
