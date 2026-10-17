package com.vansh.lms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/delete-course")
public class DeleteCourseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession(false) == null
                || !"ADMIN".equals(request.getSession(false)
                        .getAttribute("role"))) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String courseIdValue = request.getParameter("courseId");

        try {
            int courseId = Integer.parseInt(courseIdValue);

            if (courseId <= 0) {
                response.sendRedirect("../admin-courses.jsp?error=invalid");
                return;
            }

            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);

                try {
                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM lessons WHERE course_id = ?")) {
                        ps.setInt(1, courseId);
                        ps.executeUpdate();
                    }

                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM enrollments WHERE course_id = ?")) {
                        ps.setInt(1, courseId);
                        ps.executeUpdate();
                    }

                    int deleted;
                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM courses WHERE id = ?")) {
                        ps.setInt(1, courseId);
                        deleted = ps.executeUpdate();
                    }

                    if (deleted == 1) {
                        con.commit();
                        response.sendRedirect("../admin-courses.jsp?deleted=1");
                    } else {
                        con.rollback();
                        response.sendRedirect("../admin-courses.jsp?error=notfound");
                    }

                } catch (Exception e) {
                    con.rollback();
                    throw e;
                } finally {
                    con.setAutoCommit(true);
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("../admin-courses.jsp?error=invalid");
        } catch (Exception e) {
            getServletContext().log("Unable to delete course", e);
            throw new ServletException("Unable to delete course", e);
        }
    }
}
