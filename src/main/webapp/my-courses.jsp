
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
    <title>LMS - My Enrollments</title>
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
        .card {
            background: white;
            padding: 22px;
            margin: 15px 0;
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
    <h2>LMS Portal — My Enrollments</h2>
</header>

<main>
    <p>Welcome, <%= session.getAttribute("userName") %>!</p>
    <p><a href="welcome.jsp">← Back to Dashboard</a></p>
    <%
    String enrollMessage = (String) session.getAttribute("enrollMessage");
    if (enrollMessage != null) {
%>
    <p style="background:#d1fae5; color:#065f46; padding:12px; border-radius:8px;">
        <%= enrollMessage %>
    </p>
<%
        session.removeAttribute("enrollMessage");
    }
%>

    <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT c.id, c.title, c.description " +
                 "FROM enrollments e JOIN courses c ON e.course_id = c.id " +
                 "WHERE e.student_id = ?")) {

            Object userId = session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            ps.setInt(1, Integer.parseInt(userId.toString()));

            try (ResultSet rs = ps.executeQuery()) {
                boolean found = false;

                while (rs.next()) {
                    found = true;
    %>
        <div class="card">
            <h3><%= rs.getString("title") %></h3>
            <p><%= rs.getString("description") %></p>
            <p><strong>Course ID:</strong> <%= rs.getInt("id") %></p>
            <p>
    <a href="student-lessons.jsp?courseId=<%= rs.getInt("id") %>">
        📖 View Lessons
    </a>
</p>
        </div>
    <%
                }

                if (!found) {
    %>
        <div class="card">
            <p>You have not enrolled in any courses yet.</p>
            <p><a href="courses.jsp">Explore Available Courses</a></p>
        </div>
    <%
                }
            }
        } catch (Exception e) {
            application.log("Unable to load student enrollments", e);
    %>
        <p class="error">Unable to load enrollments. Please try again later.</p>
    <%
        }
    %>
</main>
</body>
</html>
