
package com.vansh.lms;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (PrintWriter out = response.getWriter()) {

            if (name == null || email == null || password == null
                    || name.isBlank() || email.isBlank()
                    || password.isBlank()) {
                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST);
                out.println("Please fill in all fields.");
                return;
            }

            name = name.trim();
            email = email.trim();

            if (name.length() > 100 || email.length() > 100
                    || password.length() < 8
                    || password.length() > 72) {
                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST);
                out.println(
                    "Name/email must be at most 100 characters. "
                    + "Password must be 8 to 72 characters.");
                return;
            }

            String hashedPassword = BCrypt.hashpw(
                    password, BCrypt.gensalt(12));

            String sql = "INSERT INTO users "
                    + "(name, email, password) VALUES (?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, hashedPassword);

                ps.executeUpdate();

                out.println("<h2>Registration successful!</h2>");
                out.println("<p>Welcome, "
                        + escapeHtml(name) + "!</p>");

            } catch (SQLException e) {
                if ("23000".equals(e.getSQLState())) {
                    response.setStatus(
                            HttpServletResponse.SC_CONFLICT);
                    out.println("This email may already be registered.");
                } else {
                    getServletContext().log(
                            "Registration failed", e);
                    response.setStatus(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.println("Registration failed. Please try again.");
                }
            }
        }
    }

    private String escapeHtml(String value) {
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
}
