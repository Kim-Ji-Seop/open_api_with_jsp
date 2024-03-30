package org.openapi.jsp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/BookmarkAddServlet")
public class BookmarkAddServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String bookmarkName = request.getParameter("bookmarkName");
        int orderNum = Integer.parseInt(request.getParameter("orderNum"));
        System.out.println(request);

        DBConnection connection = (DBConnection) getServletContext().getAttribute("DBConnection");
        connection.insertBookmarkInfo(bookmarkName,orderNum);

        response.sendRedirect("bookmark-group.jsp");
    }
}
