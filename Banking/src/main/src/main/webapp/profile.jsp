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

    // Fetch user details along with account balance
    String query = "SELECT u.name, u.email, u.contact, u.address, a.account_number, a.balance " +
                   "FROM users u JOIN accounts a ON u.account_number = a.account_number " +
                   "WHERE u.account_number=?";
    
    ps = con.prepareStatement(query);
    ps.setLong(1, accNumber);
    rs = ps.executeQuery();

    String name = "", email = "", contact = "", address = "";
    long accountNumber = 0;
    double balance = 0.0;

    if (rs.next()) {
        name = rs.getString("name");
        email = rs.getString("email");
        contact = rs.getString("contact");
        address = rs.getString("address");
        accountNumber = rs.getLong("account_number");
        balance = rs.getDouble("balance");
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Profile</title>
<style>
body {
    font-family: Arial, sans-serif;
    background: url('background.jpg') no-repeat center center fixed;
    background-size: cover;
    color: white;
    text-align: center;
}

.container {
    width: 60%;
    margin: 50px auto;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
}

.left-section, .right-section {
    width: 45%;
    text-align: left;
}

.left-section p, .right-section p {
    font-size: 22px; /* Increased font size */
    margin: 20px 0; /* Increased spacing */
}

.btn-container {
    text-align: center;
    margin-top: 30px;
}

.btn {
    padding: 12px 25px;
    margin: 15px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 18px; /* Larger button text */
}

.update-btn {
    background: #28a745;
    color: white;
}

.update-btn:hover {
    background: #218838;
}

.dashboard-btn {
    background: #007bff;
    color: white;
}

.dashboard-btn:hover {
    background: #0056b3;
}
</style>
</head>
<body>

    <div class="container">
        <!-- Left Section: Account Details -->
        <div class="left-section">
            <p><strong>Account Number:</strong> <%=accountNumber%></p>
            <p><strong>Account Holder:</strong> <%=name%></p>
            <p><strong>Balance:</strong> $<%=String.format("%.2f", balance)%></p>
        </div>

        <!-- Right Section: Contact Details -->
        <div class="right-section">
            <p><strong>Email:</strong> <%=email%></p>
            <p><strong>Contact:</strong> <%=contact%></p>
            <p><strong>Address:</strong> <%=address%></p>
        </div>
    </div>

    <!-- Buttons for navigation -->
    <div class="btn-container">
        <form action="updateProfile.jsp" method="get">
            <button type="submit" class="btn update-btn">Update Profile</button>
        </form>
        <form action="dashboard.jsp" method="get">
            <button type="submit" class="btn dashboard-btn">Back to Dashboard</button>
        </form>
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
