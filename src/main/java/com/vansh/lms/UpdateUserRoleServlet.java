package com.vansh.lms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/update-user-role")
public class UpdateUserRoleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newRole = request.getParameter("role");

            if (userId <= 0
                    || !("STUDENT".equals(newRole)
                    || "TEACHER".equals(newRole))) {
                response.sendRedirect("../admin-users.jsp?error=invalid");
                return;
            }

            int adminId = (Integer) session.getAttribute("userId");

            if (userId == adminId) {
                response.sendRedirect("../admin-users.jsp?error=self");
                return;
            }

            String sql = "UPDATE users SET role = ? WHERE id = ?";

            try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, newRole);
                ps.setInt(2, userId);

                int updated = ps.executeUpdate();

                if (updated == 1) {
                    response.sendRedirect("../admin-users.jsp?updated=1");
                } else {
                    response.sendRedirect("../admin-users.jsp?error=notfound");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("../admin-users.jsp?error=invalid");
        } catch (Exception e) {
            getServletContext().log("Unable to update user role", e);
            throw new ServletException("Unable to update user role", e);
        }
    }
}
