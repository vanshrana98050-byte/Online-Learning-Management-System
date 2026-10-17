package com.vansh.lms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null
                || email.isBlank() || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        String sql = "SELECT id, name, password, role FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()
                        && BCrypt.checkpw(password, rs.getString("password"))) {

                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("role", rs.getString("role"));

                    String role = rs.getString("role");

                    if ("ADMIN".equals(role)) {
                        response.sendRedirect("admin-dashboard.jsp");
                    } else if ("TEACHER".equals(role)) {
                        response.sendRedirect("teacher-dashboard.jsp");
                    } else {
                        response.sendRedirect("welcome.jsp");
                    }

                } else {
                    response.setContentType("text/html;charset=UTF-8");
                    response.getWriter().println(
                            "Invalid email or password. "
                            + "<a href='login.jsp'>Try again</a>"
                    );
                }
            }

        } catch (Exception e) {
            getServletContext().log("Login failed", e);
            throw new ServletException("Login failed", e);
        }
    }
}
