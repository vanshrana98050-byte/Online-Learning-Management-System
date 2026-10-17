
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
    int courseId = 0;

    try {
        courseId = Integer.parseInt(request.getParameter("courseId"));
    } catch (Exception e) {
        response.sendError(400, "Invalid course ID.");
        return;
    }

    String courseTitle = null;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT title FROM courses WHERE id = ? AND teacher_id = ?")) {

        ps.setInt(1, courseId);
        ps.setInt(2, teacherId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                courseTitle = rs.getString("title");
            }
        }
    } catch (Exception e) {
        application.log("Unable to load course", e);
        response.sendError(500, "Unable to load course.");
        return;
    }

    if (courseTitle == null) {
        response.sendError(404, "Course not found or access denied.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Lessons | LMS</title>
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
            max-width: 850px;
            margin: 30px auto;
            padding: 0 18px;
        }
        .panel {
            background: white;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 20px;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            margin: 8px 0 16px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            box-sizing: border-box;
            font: inherit;
        }
        textarea { min-height: 100px; }
        button, .button {
            display: inline-block;
            background: #2563eb;
            color: white;
            padding: 11px 16px;
            border: 0;
            border-radius: 8px;
            text-decoration: none;
            cursor: pointer;
        }
        .lesson {
            border-bottom: 1px solid #e2e8f0;
            padding: 12px 0;
        }
    </style>
</head>
<body>
<header>
    <h2>LMS | Lesson Management</h2>
</header>

<main>
    <h1><%= courseTitle %></h1>
    <p>Course ID: <%= courseId %></p>

    <div class="panel">
        <h2>Add New Lesson</h2>
<%
    if ("1".equals(request.getParameter("added"))) {
%>
    <p style="color:green;">Lesson added successfully!</p>
<%
    }
%>
        <form action="add-lesson" method="post">
            <input type="hidden" name="courseId" value="<%= courseId %>">

            <label for="title">Lesson Title</label>
            <input id="title" name="title" type="text"
                   maxlength="150" required
                   placeholder="e.g. Introduction to Java">

            <label for="content">Lesson Content</label>
            <textarea id="content" name="content" required
                      placeholder="Enter lesson notes or learning material"></textarea>

            <label for="videoUrl">Video URL (optional)</label>
            <input id="videoUrl" name="videoUrl" type="url"
                   maxlength="255" placeholder="https://example.com/video">

            <button type="submit">Add Lesson</button>
        </form>
    </div>

    <div class="panel">
        <h2>Existing Lessons</h2>

        <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT id, title, content, video_url FROM lessons "
                     + "WHERE course_id = ? ORDER BY id DESC")) {

                ps.setInt(1, courseId);

                try (ResultSet rs = ps.executeQuery()) {
                    boolean found = false;

                    while (rs.next()) {
                        found = true;
        %>
            <div class="lesson">
                <h3><%= rs.getString("title") %></h3>
                <p><%= rs.getString("content") %></p>
                <%
                    String videoUrl = rs.getString("video_url");
                    if (videoUrl != null && !videoUrl.isBlank()) {
                %>
                    <p>Video: <a href="<%= videoUrl %>" target="_blank"
                       rel="noopener noreferrer">Open video</a></p>
                <%
                    }
                %>
            </div>
        <%
                    }

                    if (!found) {
        %>
            <p>No lessons added yet.</p>
        <%
                    }
                }
            } catch (Exception e) {
                application.log("Unable to load lessons", e);
        %>
            <p>Unable to load lessons right now.</p>
        <%
            }
        %>

        <a class="button" href="teacher-courses.jsp">Back to My Courses</a>
    </div>
</main>
</body>
</html>
