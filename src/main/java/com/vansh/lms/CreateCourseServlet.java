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

@WebServlet("/create-course")
public class CreateCourseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (!"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("welcome.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");

        if (title == null || title.isBlank()
                || description == null || description.isBlank()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Course title and description are required."
            );
            return;
        }

        String sql = "INSERT INTO courses (title, description, teacher_id) "
                + "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setInt(3, (Integer) session.getAttribute("userId"));

            ps.executeUpdate();

            response.sendRedirect("teacher-courses.jsp?created=1");

        } catch (Exception e) {
            getServletContext().log("Course creation failed", e);
            throw new ServletException("Unable to create course.", e);
        }
    }
}
