package org.openapi.jsp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/BookmarkDeleteServlet")
public class BookmarkDeleteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int bookmarkIdx = Integer.parseInt(request.getParameter("bookmarkIdx"));

        DBConnection connection = (DBConnection) getServletContext().getAttribute("DBConnection");
        connection.deleteBookmarkInfo(bookmarkIdx);

        connection.removeConnectWifiAndBookmark(bookmarkIdx);
        response.sendRedirect("bookmark-group.jsp");
    }
}
