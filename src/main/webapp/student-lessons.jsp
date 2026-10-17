
<%@ page import="java.sql.*" %>
<%@ page import="com.vansh.lms.DBConnection" %>
<%
    Object userIdObj = session.getAttribute("userId");

    if (userIdObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int courseId = 0;

    try {
        courseId = Integer.parseInt(request.getParameter("courseId"));
    } catch (Exception e) {
        response.sendError(400, "Invalid course ID.");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Course Lessons - LMS</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f6fb; margin: 0; color: #222; }
        header { background: #155eef; color: white; padding: 20px; }
        main { max-width: 900px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 22px; margin: 15px 0; border-radius: 12px; box-shadow: 0 3px 12px #0001; }
        a { color: #155eef; }
    </style>
</head>
<body>
<header>
    <h2>LMS Portal — Course Lessons</h2>
</header>
<main>
    <p><a href="my-courses.jsp">← Back to My Courses</a></p>
    <%
        try (Connection con = DBConnection.getConnection()) {
            int studentId = Integer.parseInt(userIdObj.toString());

            try (PreparedStatement check = con.prepareStatement(
                "SELECT 1 FROM enrollments WHERE student_id = ? AND course_id = ?")) {
                check.setInt(1, studentId);
                check.setInt(2, courseId);

                try (ResultSet enrolled = check.executeQuery()) {
                    if (!enrolled.next()) {
    %>
        <div class="card">
            <p>You are not enrolled in this course.</p>
            <a href="courses.jsp">Explore Courses</a>
        </div>
    <%
                    } else {
                        try (PreparedStatement course = con.prepareStatement(
                            "SELECT title FROM courses WHERE id = ?")) {
                            course.setInt(1, courseId);

                            try (ResultSet cr = course.executeQuery()) {
                                if (cr.next()) {
    %>
        <h2><%= cr.getString("title") %></h2>
    <%
                                } else {
                                    out.println("<p>Course not found.</p>");
                                }
                            }
                        }

                        try (PreparedStatement ps = con.prepareStatement(
                            "SELECT title, content, video_url FROM lessons WHERE course_id = ? ORDER BY id")) {
                            ps.setInt(1, courseId);

                            try (ResultSet rs = ps.executeQuery()) {
                                boolean found = false;
                                while (rs.next()) {
                                    found = true;
    %>
        <div class="card">
            <h3><%= rs.getString("title") %></h3>
            <p><%= rs.getString("content") == null ? "" : rs.getString("content") %></p>
            <%
                String videoUrl = rs.getString("video_url");
                if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            %>
                <p><a href="<%= videoUrl %>" target="_blank" rel="noopener noreferrer">Open Lesson Video</a></p>
            <%
                }
            %>
        </div>
    <%
                                }

                                if (!found) {
    %>
        <div class="card">
            <p>No lessons have been added to this course yet.</p>
        </div>
    <%
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            application.log("Unable to load student lessons", e);
    %>
        <div class="card">
            <p>Unable to load lessons. Please try again later.</p>
        </div>
    <%
        }
    %>
</main>
</body>
</html>
