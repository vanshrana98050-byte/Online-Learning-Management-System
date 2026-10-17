
<%@ page import="java.sql.*" %>
<%@ page import="com.vansh.lms.DBConnection" %>
<%
    if (session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>LMS - Available Courses</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .courses {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }
        .card {
            background: white;
            padding: 22px;
            border-radius: 12px;
            box-shadow: 0 3px 12px #0001;
        }
        .card h3 { color: #155eef; }
        a { color: #155eef; }
        .error { color: #b42318; }
    </style>
</head>
<body>
<header>
    <h2>LMS Portal — Available Courses</h2>
</header>

<main>
    <p>Welcome, <%= session.getAttribute("userName") %>!</p>
    <p><a href="welcome.jsp">← Back to Dashboard</a></p>

    <div class="courses">
    <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT id, title, description, teacher_id FROM courses ORDER BY id");
             ResultSet rs = ps.executeQuery()) {

            boolean found = false;

            while (rs.next()) {
                found = true;
    %>
        <div class="card">
            <h3><%= rs.getString("title") %></h3>
            <p><%= rs.getString("description") %></p>
            <p><strong>Course ID:</strong> <%= rs.getInt("id") %></p>
            
<form action="enroll" method="post">
    <input type="hidden" name="courseId" value="<%= rs.getInt("id") %>">
    <button type="submit">Enroll Now</button>
</form>

            <p><strong>Teacher ID:</strong> <%= rs.getObject("teacher_id") == null
                    ? "Not assigned" : rs.getObject("teacher_id") %></p>
        </div>
    <%
            }

            if (!found) {
    %>
        <p>No courses available yet.</p>
    <%
            }
        } catch (Exception e) {
    %>
        <p class="error">Unable to load courses. Please try again later.</p>
        <%
            application.log("Unable to load LMS courses", e);
        }
    %>
    </div>
</main>
</body>
</html>
