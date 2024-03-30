package org.openapi.jsp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/WifiBookmarkJoinServlet")
public class WifiBookmarkJoinServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        System.out.println("1");
        System.out.println(request.getParameter("bookmarkGroupId"));
        System.out.println(request.getParameter("mngNum"));
        int id = Integer.parseInt(request.getParameter("bookmarkGroupId"));
        String managementNumber = request.getParameter("mngNum");
        System.out.println(id+", "+managementNumber);
        DBConnection connection = (DBConnection) getServletContext().getAttribute("DBConnection");
        connection.updateWifiInBookmark(id,managementNumber);
        response.sendRedirect("bookmark-list.jsp");
    }
}
