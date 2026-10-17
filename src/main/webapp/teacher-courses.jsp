
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet" %>
<%@ page import="com.vansh.lms.DBConnection" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"TEACHER".equals(session.getAttribute("role"))) {
        response.sendRedirect("welcome.jsp");
        return;
    }

    int teacherId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Courses | LMS</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            margin: 0;
            color: #1f2937;
        }
        header {
            background: #172554;
            color: white;
            padding: 20px 7%;
        }
        main {
            max-width: 950px;
            margin: 35px auto;
            padding: 0 20px;
        }
        .course {
            background: white;
            padding: 22px;
            border-radius: 12px;
            margin: 16px 0;
            box-shadow: 0 3px 12px #0000000a;
        }
        .button {
            display: inline-block;
            padding: 11px 16px;
            background: #2563eb;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            margin: 8px 8px 8px 0;
        }
        .muted { color: #64748b; }
    </style>
</head>
<body>
<header>
    <h2>LMS | My Courses</h2>
</header>

<main>
    <h1>My Courses</h1>

    <% if ("1".equals(request.getParameter("created"))) { %>
        <p style="color:green;">Course created successfully!</p>
    <% } %>

    <a class="button" href="teacher-create-course.jsp">+ Create Course</a>
    <a class="button" href="teacher-dashboard.jsp">Dashboard</a>

    <%
        String sql = "SELECT id, title, description FROM courses "
                   + "WHERE teacher_id = ? ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, teacherId);

            try (ResultSet rs = ps.executeQuery()) {
                boolean found = false;

                while (rs.next()) {
                    found = true;
    %>
        <div class="course">
            <h2><%= rs.getString("title") %></h2>
            <p><%= rs.getString("description") %></p>
            <p class="muted">Course ID: <%= rs.getInt("id") %></p>
            <a class="button"
               href="teacher-lessons.jsp?courseId=<%= rs.getInt("id") %>">
               Manage Lessons
            </a>
        </div>
    <%
                }

                if (!found) {
    %>
        <div class="course">
            <p>You haven't created any courses yet.</p>
        </div>
    <%
                }
            }
        } catch (Exception e) {
            application.log("Unable to load teacher courses", e);
    %>
        <p>Unable to load courses. Please try again later.</p>
    <%
        }
    %>
</main>
</body>
</html>
