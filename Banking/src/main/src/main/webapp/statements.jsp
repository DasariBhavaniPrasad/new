<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
HttpSession userSession = request.getSession(false);
if (userSession == null || userSession.getAttribute("account_number") == null)
{
	response.sendRedirect("login.jsp");
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

	// Fetch transaction history
	String query = "SELECT transaction_type, amount, transaction_date FROM transactions WHERE account_number=? ORDER BY transaction_date DESC";
	ps = con.prepareStatement(query);
	ps.setLong(1, accNumber);
	rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Account Statements</title>
<style>
body {
	font-family: Arial, sans-serif;
	background: url('background.jpg') no-repeat center center fixed;
	background-size: cover;
	text-align: center;
	margin: 0;
	padding: 0;
	color: white;
}

.navbar {
	background: rgba(0, 123, 255, 0.9);
	padding: 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	position: relative;
}

.profile-container {
	position: relative;
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

.dropdown {
	display: none;
	position: absolute;
	right: 0;
	top: 50px;
	background: white;
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
	border-radius: 5px;
	overflow: hidden;
	text-align: left;
}

.dropdown a {
	display: block;
	padding: 10px;
	color: black;
	text-decoration: none;
}

.dropdown a:hover {
	background: #007bff;
	color: white;
}

.profile-container:hover .dropdown {
	display: block;
}

.container {
	width: 80%;
	margin: 20px auto;
}

h2 {
	color: white;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	color: white;
}

th, td {
	padding: 10px;
	text-align: center;
}

th {
	background: rgba(0, 123, 255, 0.8);
	color: white;
	border-radius: 5px;
}

tr:nth-child(even) {
	background: rgba(255, 255, 255, 0.2);
}

tr:hover {
	background: rgba(255, 255, 255, 0.3);
}

.back-btn {
	padding: 10px 20px;
	background: #28a745;
	color: white;
	text-decoration: none;
	border-radius: 5px;
	display: inline-block;
	margin-top: 20px;
}

.back-btn:hover {
	background: #218838;
}
</style>
</head>
<body>



	<div class="container">
		<h2>Transaction History</h2>

		<table>
			<tr>
				<th>Type</th>
				<th>Amount</th>
				<th>Date</th>
			</tr>

			<%
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			boolean hasTransactions = false;
			while (rs.next())
			{
				hasTransactions = true;
			%>
			<tr>
				<td><%=rs.getString("transaction_type")%></td>
				<td>$<%=rs.getDouble("amount")%></td>
				<td><%=dateFormat.format(rs.getTimestamp("transaction_date"))%></td>
			</tr>
			<%
			}
			if (!hasTransactions)
			{
			%>
			<tr>
				<td colspan="3">No transactions found</td>
			</tr>
			<%
			}
			%>
		</table>

		<a href="dashboard.jsp" class="back-btn">Back to Dashboard</a>
	</div>

</body>
</html>

<%
} catch (Exception e)
{
e.printStackTrace();
out.println("<p style='color:red;'>Error fetching transaction history.</p>");
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
