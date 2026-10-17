
<%@ page import="java.sql.*" %>
<%@ page import="com.vansh.lms.DBConnection" %>
<%
    if (session.getAttribute("userId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LMS - Manage Courses</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f6fb; margin: 0; color: #222; }
        header { background: #172554; color: white; padding: 20px; }
        main { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 22px; margin: 15px 0; border-radius: 12px; box-shadow: 0 3px 12px #0001; }
        table { width: 100%; border-collapse: collapse; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid #ddd; }
        th { background: #eef2ff; }
        a { color: #155eef; }
        .table-wrap { overflow-x: auto; }
    </style>
</head>
<body>
<header>
    <h2>LMS | Manage Courses</h2>
</header>
<main>
    <%
    if ("1".equals(request.getParameter("deleted"))) {
%>
    <p style="color: green; font-weight: bold;">
        Course deleted successfully!
    </p>
<%
    }
    if ("notfound".equals(request.getParameter("error"))) {
%>
    <p style="color: red;">
        Course not found or already deleted.
    </p>
<%
    }
    if ("invalid".equals(request.getParameter("error"))) {
%>
    <p style="color: red;">
        Invalid course ID.
    </p>
<%
    }
%>
    <p><a href="admin-dashboard.jsp">← Back to Admin Dashboard</a></p>
    <div class="card">
        <h2>All Courses</h2>
        <div class="table-wrap">
        <table>
            <tr>
                <th>ID</th>
                <th>Course Title</th>
                <th>Description</th>
                <th>Teacher ID</th>
                <th>Created At</th>
                <th>Action</th>
            </tr>
            <%
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                         "SELECT id, title, description, teacher_id, created_at FROM courses ORDER BY id");
                     ResultSet rs = ps.executeQuery()) {

                    boolean found = false;
                    while (rs.next()) {
                        found = true;
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("description") %></td>
                <td><%= rs.getObject("teacher_id") == null ? "Not assigned" : rs.getObject("teacher_id") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td>
    <form method="post" action="admin/delete-course"
          onsubmit="return confirm('Are you sure you want to delete this course and its lessons and enrollments?');">
        <input type="hidden" name="courseId"
               value="<%= rs.getInt("id") %>">
        <button type="submit">Delete Course</button>
    </form>
</td>
            </tr>
            <%
                    }
                    if (!found) {
            %>
        <tr><td colspan="6">No courses found.</td></tr>
            <%
                    }
                } catch (Exception e) {
                    application.log("Unable to load admin courses", e);
            %>
            <tr><td colspan="5">Unable to load courses. Check server logs.</td></tr>
            <%
                }
            %>
        </table>
        </div>
    </div>
</main>
</body>
</html>
