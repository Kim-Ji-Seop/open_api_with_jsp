<%@ page import="org.openapi.jsp.open_data.GetOpenApi" %>
<%@ page import="org.openapi.jsp.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%
        GetOpenApi openApi = new GetOpenApi();
        DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
        long count = openApi.fetchAndInsertData(connection);
    %>
    <h1><%=count%>개의 WIFI 정보를 정상적으로 저장하였습니다.</h1>
    <a href="index.jsp">홈 으로 가기</a>
    <style>
        body {
            text-align: center;
        }

        h1, a {
            margin: 10px 0;
        }

    </style>
</head>
<body>

</body>
</html>
