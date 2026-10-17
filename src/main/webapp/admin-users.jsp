
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
    <title>LMS - Manage Users</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f6fb; margin: 0; color: #222; }
        header { background: #172554; color: white; padding: 20px; }
        main { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 3px 12px #0001; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid #ddd; }
        th { background: #eef2ff; }
        a { color: #155eef; }
    </style>
</head>
<body>
<header>
    <h2>LMS | Manage Users</h2>
</header>
<main>
    <p><a href="admin-dashboard.jsp">← Back to Admin Dashboard</a></p>
    <div class="card">
        <h2>Registered Users</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Created At</th>
                <th>Manage Role</th>
            </tr>
            <%
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                         "SELECT id, name, email, role, created_at FROM users ORDER BY id");
                     ResultSet rs = ps.executeQuery()) {

                    boolean found = false;
                    while (rs.next()) {
                        found = true;
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("role") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td>
    <% if (!"ADMIN".equals(rs.getString("role"))) { %>
    <form method="post" action="admin/update-user-role"
          onsubmit="return confirm('Are you sure you want to change this user role?');">
        <input type="hidden" name="userId"
               value="<%= rs.getInt("id") %>">

        <select name="role" required>
            <option value="STUDENT"
                <%= "STUDENT".equals(rs.getString("role")) ? "selected" : "" %>>
                STUDENT
            </option>
            <option value="TEACHER"
                <%= "TEACHER".equals(rs.getString("role")) ? "selected" : "" %>>
                TEACHER
            </option>
        </select>

        <button type="submit">Update Role</button>
    </form>
    <% } else { %>
        Protected Admin
    <% } %>
</td>
            </tr>
            <%
                    }
                    if (!found) {
            %>
           <tr><td colspan="6">No users found.</td></tr>
            <%
                    }
                } catch (Exception e) {
                    application.log("Unable to load admin users", e);
            %>
            <tr><td colspan="5">Unable to load users. Check server logs.</td></tr>
            <%
                }
            %>
        </table>
    </div>
    <%
    if ("1".equals(request.getParameter("updated"))) {
%>
    <p style="color: green; font-weight: bold;">
        User role updated successfully!
    </p>
<%
    }
    if (request.getParameter("error") != null) {
%>
    <p style="color: red;">
        Role update failed. Check the user ID and selected role.
    </p>
<%
    }
%>
</main>
</body>
</html>
