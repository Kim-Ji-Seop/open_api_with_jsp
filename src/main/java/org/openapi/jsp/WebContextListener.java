package org.openapi.jsp;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;

@WebListener
public class WebContextListener implements ServletContextListener {
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
        Connection conn = connection.connectDB();

        servletContextEvent.getServletContext().setAttribute("connection", conn);
        servletContextEvent.getServletContext().setAttribute("DBConnection", connection);
    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        Connection conn = (Connection) servletContextEvent.getServletContext().getAttribute("connection");
        if (conn != null) {
            try {
                conn.close(); // 데이터베이스 연결 종료
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
