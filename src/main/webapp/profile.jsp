
<%@ page import="java.sql.*" %>
<%@ page import="com.vansh.lms.DBConnection" %>
<%
    Object userId = session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "";
    String email = "";
    boolean found = false;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT id, name, email FROM users WHERE id = ?")) {

        ps.setInt(1, Integer.parseInt(userId.toString()));

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                found = true;
            }
        }
    } catch (Exception e) {
        application.log("Unable to load student profile", e);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LMS - My Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            margin: 0;
            color: #222;
        }
        header {
            background: #155eef;
            color: white;
            padding: 20px;
        }
        main {
            max-width: 650px;
            margin: 35px auto;
            padding: 0 20px;
        }
        .card {
            background: white;
            padding: 28px;
            border-radius: 14px;
            box-shadow: 0 3px 12px #0001;
        }
        .avatar {
            background: #e0eaff;
            color: #155eef;
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin-bottom: 20px;
        }
        .detail {
            padding: 14px 0;
            border-bottom: 1px solid #eee;
        }
        a { color: #155eef; }
        .error { color: #b42318; }
    </style>
</head>
<body>
<header>
    <h2>LMS Portal — My Profile</h2>
</header>

<main>
    <p><a href="welcome.jsp">← Back to Dashboard</a></p>

    <div class="card">
        <% if (found) { %>
            <div class="avatar">👤</div>
            <h2><%= name %></h2>

            <div class="detail">
                <strong>Student ID:</strong> <%= userId %>
            </div>
            <div class="detail">
                <strong>Full Name:</strong> <%= name %>
            </div>
            <div class="detail">
                <strong>Email:</strong> <%= email %>
            </div>
        <% } else { %>
            <p class="error">Profile could not be found. Please log in again.</p>
        <% } %>
    </div>
</main>
</body>
</html>
