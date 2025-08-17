package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import DB.DB;

@MultipartConfig
public class PulseUploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String user = (String) session.getAttribute("username");

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/view/neon_gate.jsp");
            return;
        }

        String content = req.getParameter("content");
        Part filePart = req.getPart("image");
        String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;
        String imagePath = null;

       
        if (fileName != null && !fileName.isEmpty()) {
            String uploadDir = getServletContext().getRealPath("/datauploads");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String fullPath = uploadDir + File.separator + fileName;

            try (InputStream input = filePart.getInputStream();
                 FileOutputStream fos = new FileOutputStream(fullPath)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }

            imagePath = fileName;  
        }

        try (Connection conn = DB.connect()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO DataPulse(user_id, content, image_path) " +
                "VALUES ((SELECT id FROM GhostUser WHERE username=?), ?, ?)"
            );
            ps.setString(1, user);
            ps.setString(2, content);
            ps.setString(3, imagePath);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        
        res.sendRedirect(req.getContextPath() + "/view/darkstream.jsp");
    }
}
