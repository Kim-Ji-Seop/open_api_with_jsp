<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.openapi.jsp.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 데이터베이스 연결 설정
    DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
    Connection conn = connection.connectDB();
    try {
        // URL 파라미터에서 id 추출
        String id = request.getParameter("id");

        if(id != null && !id.isEmpty()) {
            String sql = "DELETE FROM gps_history WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.executeUpdate();

            pstmt.close();
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(conn != null) {
            try {
                conn.close();
            } catch(SQLException e) {
                e.printStackTrace();
            }
        }
    }

    response.sendRedirect("history.jsp");
%>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html>
