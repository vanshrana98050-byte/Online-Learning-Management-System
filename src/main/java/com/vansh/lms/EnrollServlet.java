package com.vansh.lms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/enroll")
public class EnrollServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId;
        int courseId;

        try {
            studentId = Integer.parseInt(
                    session.getAttribute("userId").toString()
            );
            courseId = Integer.parseInt(request.getParameter("courseId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid student or course ID");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO enrollments (student_id, course_id) "
                    + "SELECT ?, ? WHERE NOT EXISTS ("
                    + "SELECT 1 FROM enrollments WHERE student_id = ? "
                    + "AND course_id = ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, courseId);
                ps.setInt(3, studentId);
                ps.setInt(4, courseId);

                int rows = ps.executeUpdate();

                if (rows == 0) {
                    session.setAttribute("enrollMessage",
                            "You are already enrolled in this course.");
                } else {
                    session.setAttribute("enrollMessage",
                            "Successfully enrolled in the course!");
                }
            }

            response.sendRedirect("my-courses.jsp");

        } catch (SQLException e) {
            throw new ServletException("Unable to enroll in course", e);
        }
    }
}
