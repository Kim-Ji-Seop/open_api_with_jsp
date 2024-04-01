<%@ page import="java.sql.*" %>
<%@ page import="org.openapi.jsp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Title</title>
    </head>
    <body>
        <h1>위치 히스토리 목록</h1>
        <br/>
        <a href="index.jsp">홈</a>
        <a href="history.jsp">위치 히스토리 목록</a>
        <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>

        <table id="history">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>X좌표</th>
                    <th>Y좌표</th>
                    <th>조회일자</th>
                    <th>비고</th>
                </tr>
            </thead>
            <tbody>
                <%
                    DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
                    Connection conn = connection.connectDB();
                    try {
        
                        Statement stmt = conn.createStatement();
                        String sql = "SELECT id, lat_coordinate, lnt_coordinate, created\n" +
                                     "FROM gps_history\n" +
                                     "ORDER BY id DESC";
                        ResultSet rs = stmt.executeQuery(sql);
        
                        while (rs.next()) {

                            out.println("<tr style=\"text-align: center;\">");
                            out.println("<td>" + rs.getString("id") + "</td>");
                            out.println("<td>" + rs.getString("lat_coordinate") + "</td>");
                            out.println("<td>" + rs.getString("lnt_coordinate") + "</td>");
                            out.println("<td>" + rs.getString("created") + "</td>");

                            // 삭제 링크에 행의 id를 파라미터로 전달
                            out.println("<td><a href=\"history-delete.jsp?id=" + rs.getString("id") + "\">삭제</a></td>");

                            out.println("</tr>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>

            </tbody>
        </table>
        <style>
            #history {
                font-family: Arial, Helvetica, sans-serif;
                border-collapse: collapse;
                width: 100%;
            }

            #history td, #history th {
                border: 1px solid #ddd;
                padding: 15px;
            }

            #history tr:nth-child(even){
                background-color: #f2f2f2;
                padding-top: 12px;
                padding-bottom: 12px;
            }

            #history tr:hover {background-color: #ddd;}

            #history th {
                padding-top: 12px;
                padding-bottom: 12px;
                text-align: center;
                background-color: #04AA6D;
                color: white;
            }
        </style>
    </body>
</html>
