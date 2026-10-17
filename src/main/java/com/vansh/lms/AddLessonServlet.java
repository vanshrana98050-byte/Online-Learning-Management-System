package com.vansh.lms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-lesson")
public class AddLessonServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (!"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("welcome.jsp");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");
        int courseId;

        try {
            courseId = Integer.parseInt(request.getParameter("courseId"));
        } catch (Exception e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid course ID."
            );
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String videoUrl = request.getParameter("videoUrl");

        if (title == null || title.isBlank()
                || title.trim().length() > 150
                || content == null || content.isBlank()
                || (videoUrl != null && videoUrl.length() > 255)) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please enter valid lesson details."
            );
            return;
        }

        String checkSql
                = "SELECT id FROM courses WHERE id = ? AND teacher_id = ?";

        String insertSql
                = "INSERT INTO lessons (course_id, title, content, video_url) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection(); PreparedStatement check = con.prepareStatement(checkSql)) {

            check.setInt(1, courseId);
            check.setInt(2, teacherId);

            try (ResultSet rs = check.executeQuery()) {
                if (!rs.next()) {
                    response.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "You cannot add lessons to this course."
                    );
                    return;
                }
            }

            try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                insert.setInt(1, courseId);
                insert.setString(2, title.trim());
                insert.setString(3, content.trim());

                if (videoUrl == null || videoUrl.isBlank()) {
                    insert.setNull(4, java.sql.Types.VARCHAR);
                } else {
                    insert.setString(4, videoUrl.trim());
                }

                insert.executeUpdate();
            }

            response.sendRedirect(
                    "teacher-lessons.jsp?courseId=" + courseId + "&added=1"
            );

        } catch (Exception e) {
            getServletContext().log("Adding lesson failed", e);
            throw new ServletException("Unable to add lesson.", e);
        }
    }
}
