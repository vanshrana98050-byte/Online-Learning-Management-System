
<%@ page import="java.sql.*" %>
<%@ page import="com.vansh.lms.DBConnection" %>
<%
    if (session.getAttribute("userId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int totalUsers = 0;
    int totalCourses = 0;
    int totalEnrollments = 0;

    try (Connection con = DBConnection.getConnection()) {
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users")) {
            if (rs.next()) totalUsers = rs.getInt(1);
        }

        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM courses")) {
            if (rs.next()) totalCourses = rs.getInt(1);
        }

        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM enrollments")) {
            if (rs.next()) totalEnrollments = rs.getInt(1);
        }
    } catch (Exception e) {
        application.log("Unable to load admin dashboard statistics", e);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LMS - Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            margin: 0;
            color: #222;
        }
        header {
            background: #172554;
            color: white;
            padding: 20px;
        }
        main {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .card {
            background: white;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #0001;
            margin-bottom: 20px;
        }
        .number {
            font-size: 30px;
            font-weight: bold;
            color: #155eef;
        }
        a { color: #155eef; }
        .button {
            display: inline-block;
            background: #155eef;
            color: white;
            padding: 10px 16px;
            border-radius: 6px;
            text-decoration: none;
            margin: 5px 5px 5px 0;
        }
    </style>
</head>
<body>
<header>
    <h2>LMS | Admin Panel</h2>
    <p>Welcome, <%= session.getAttribute("userName") %>!</p>
    <a href="logout" style="color:white;">Logout</a>
</header>

<main>
    <h2>Dashboard Overview</h2>

    <div class="stats">
        <div class="card">
            <h3>Total Users</h3>
            <p class="number"><%= totalUsers %></p>
        </div>

        <div class="card">
            <h3>Total Courses</h3>
            <p class="number"><%= totalCourses %></p>
        </div>

        <div class="card">
            <h3>Total Enrollments</h3>
            <p class="number"><%= totalEnrollments %></p>
        </div>
    </div>

    <div class="card">
        <h3>User Management</h3>
        <p>View registered students, teachers and administrators.</p>
        <a class="button" href="admin-users.jsp">Manage Users</a>
    </div>

    <div class="card">
        <h3>Course Management</h3>
        <p>View and manage courses available on the LMS.</p>
        <a class="button" href="admin-courses.jsp">Manage Courses</a>
    </div>
</main>
</body>
</html>
