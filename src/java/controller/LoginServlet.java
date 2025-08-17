package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DB.DB;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        try (Connection conn = DB.connect()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM GhostUser WHERE username=? AND password=?");
            ps.setString(1, user);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = req.getSession();
                session.setAttribute("username", user);
                System.out.println(">>> Login successful for: " + user);
                res.sendRedirect(req.getContextPath() + "/view/darkstream.jsp");
            } else {
                System.out.println(">>> Login failed for: " + user);
                res.sendRedirect(req.getContextPath() + "/view/neon_gate.jsp?error=1");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/view/neon_gate.jsp?error=2");
        }
    }
}
