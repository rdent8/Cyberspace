package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DB.DB;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        try (Connection conn = DB.connect()) {
            System.out.println(">>> Checking if user exists: " + user);

            PreparedStatement check = conn.prepareStatement("SELECT * FROM GhostUser WHERE username = ?");
            check.setString(1, user);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                System.out.println(">>> User FOUND in DB: " + user);
                res.sendRedirect(req.getContextPath() + "/view/register.jsp?error=1");
                return;
            }

            System.out.println(">>> User NOT found. Inserting: " + user);

            PreparedStatement ps = conn.prepareStatement("INSERT INTO GhostUser(username, password) VALUES (?, ?)");
            ps.setString(1, user);
            ps.setString(2, pass);
            ps.executeUpdate();

            System.out.println(">>> Insert SUCCESS.");
            res.sendRedirect(req.getContextPath() + "/view/neon_gate.jsp?registered=1");

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/view/register.jsp?error=1");
        }
    }
}
