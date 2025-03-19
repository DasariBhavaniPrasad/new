<%@ page import="java.sql.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.*"%>

<%
HttpSession userSession = request.getSession(false);
if (userSession == null || userSession.getAttribute("account_number") == null)
{
	response.sendRedirect("login.jsp"); // Redirect to login if session is invalid
	return;
}

// Database connection
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try
{
	con = dao.DatabaseConnection.getConnection();

	// Retrieve user details from session
	String name = (String) userSession.getAttribute("name");
	String accNumberStr = (String) userSession.getAttribute("account_number");
	long accNumber = Long.parseLong(accNumberStr);

	// Fetch available balance
	String balanceQuery = "SELECT balance FROM accounts WHERE account_number=?";
	ps = con.prepareStatement(balanceQuery);
	ps.setLong(1, accNumber);
	rs = ps.executeQuery();

	double balance = 0;
	if (rs.next())
	{
		balance = rs.getDouble("balance");
	}
	rs.close();
	ps.close();
%>

<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>
<style>
body {
	font-family: Arial, sans-serif;
	background: url('dashboard.jpg') no-repeat center center fixed;
	background-size: cover;
	text-align: center;
	margin: 0;
	padding: 0;
	color: black; /* Ensure text remains black */
}

.navbar {
	background: rgba(0, 123, 255, 0.8);
	padding: 15px;
	display: flex;
	justify-content: flex-end;
	align-items: center;
	position: relative;
}

.profile-container {
	position: relative;
	display: inline-block;
	cursor: pointer;
}

.profile-icon {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	background: white;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: bold;
	color: #007bff;
}

.dropdown-content {
	display: none;
	position: absolute;
	right: 0;
	background: rgba(0, 0, 0, 0.7);
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
	border-radius: 5px;
	min-width: 120px;
	text-align: left;
}

.dropdown-content a {
	color: white;
	padding: 10px;
	display: block;
	text-decoration: none;
}

.dropdown-content a:hover {
	background: rgba(255, 255, 255, 0.2);
}

.profile-container:hover .dropdown-content {
	display: block;
}

.container {
	width: 60%;
	margin: 20px auto;
	padding: 20px;
	border-radius: 10px;
	color: black; /* Ensure all text is black */
}

.grid-container {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 20px;
	margin-top: 20px;
	color: black;
}

.grid-item {
	background: transparent;
	color: black;
	padding: 20px;
	border-radius: 10px;
	font-size: 20px;
	font-weight: bold;
	text-decoration: none;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: transform 0.2s, background 0.3s;
	border: 2px solid black; /* Updated to black */
}

.grid-item:hover {
	background: rgba(0, 0, 0, 0.1);
	transform: scale(1.05);
}
</style>
</head>
<body>

	<!-- Navbar with Profile Dropdown -->
	<div class="navbar">
		<div class="profile-container">
			<div class="profile-icon"><%=name.charAt(0)%></div>
			<div class="dropdown-content">
				<a href="profile.jsp">Profile</a> <a href="index.jsp">Logout</a>
			</div>
		</div>
	</div>

	<div class="container">
		<h2>
			Welcome,
			<%=name%>!
		</h2>
		<p>
			<strong>Account Number:</strong>
			<%=accNumber%></p>
		<p>
			<strong>Available Balance:</strong> $<%=new DecimalFormat("#,##0.00").format(balance)%></p>

		<h3>Quick Actions</h3>
		<div class="grid-container">
			<a href="withdraw.jsp" class="grid-item">Withdraw</a> <a
				href="transfer.jsp" class="grid-item">Transfer</a> <a
				href="deposit.jsp" class="grid-item">Deposit</a> <a
				href="statements.jsp" class="grid-item">Statements</a>
		</div>
	</div>

</body>
</html>

<%
} catch (Exception e)
{
e.printStackTrace();
out.println("<p style='color:red;'>Error fetching account details.</p>");
} finally
{
if (rs != null)
	try
	{
		rs.close();
	} catch (SQLException e)
	{
	}
if (ps != null)
	try
	{
		ps.close();
	} catch (SQLException e)
	{
	}
if (con != null)
	try
	{
		con.close();
	} catch (SQLException e)
	{
	}
}
%>
