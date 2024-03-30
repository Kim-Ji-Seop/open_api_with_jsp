package org.openapi.jsp;

import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/getWifiInfo")
public class HelloServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setCharacterEncoding("UTF-8"); //출력 인코딩 설정
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        double lat = Double.parseDouble(request.getParameter("lat"));
        double lnt = Double.parseDouble(request.getParameter("lnt"));
        try {
            DBConnection connection = (DBConnection) getServletContext().getAttribute("DBConnection");
            String result = connection.selectAllWifiInfo(lat, lnt);
            out.print(result);
        } catch (NullPointerException | SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public void destroy() {
    }
}