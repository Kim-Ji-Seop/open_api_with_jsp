package org.openapi.jsp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/BookmarkListDeleteServlet")
public class BookmarkListDeleteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int wifiIdx = Integer.parseInt(request.getParameter("wifiIdx"));

        DBConnection connection = (DBConnection) getServletContext().getAttribute("DBConnection");
        connection.deleteBookmarkListInfo(wifiIdx);

        response.sendRedirect("bookmark-list.jsp");
    }
}
