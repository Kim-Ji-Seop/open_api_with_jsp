<%@ page import="org.openapi.jsp.DBConnection" %>
<%@ page import="org.openapi.jsp.BookmarkWifiJoin" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%
    DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
    List<BookmarkWifiJoin> bookmarkWifiJoinList = null;
    try {
        bookmarkWifiJoinList = connection.getAllBookmarkAndWifi();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
<head>
    <title>Title</title>
</head>
<body>
    <h1>북마크 보기</h1>
    <br/>
    <a href="index.jsp">홈</a>
    <a href="history.jsp">위치 히스토리 목록</a>
    <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>
    <a href="bookmark-list.jsp">북마크 보기</a>
    <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    <table id="bookmark">
        <thead>
        <tr>
            <th>ID</th>
            <th>북마크 이름</th>
            <th>와이파이명</th>
            <th>등록일자</th>
            <th>비고</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (bookmarkWifiJoinList.isEmpty()) {
        %>
        <tr id="defaultMessage">
            <td colspan="5" style="text-align:center;">정보가 존재하지 않습니다.</td>
        </tr>
        <%
        } else {
            for (BookmarkWifiJoin bookmark : bookmarkWifiJoinList) {
        %>
        <tr style="text-align:center;">
            <td><%=bookmark.getId()%></td>
            <td><%=bookmark.getBookmarkName()%></td>
            <td><%=bookmark.getWifiName()%></td>
            <td><%=bookmark.getCreated()%></td>
            <td>
                <a href="bookmark-list-delete.jsp?wifiIdx=<%=bookmark.getWifiIdx()%>&bookmarkName=<%=bookmark.getBookmarkName()%>&wifiName=<%=bookmark.getWifiName()%>&created=<%=bookmark.getCreated()%>">삭제</a>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
    <style>
        #bookmark {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #bookmark td, #bookmark th {
            border: 1px solid #ddd;
            padding: 15px;
        }

        #bookmark tr:nth-child(even){
            background-color: #f2f2f2;
            padding-top: 12px;
            padding-bottom: 12px;
        }

        #bookmark tr:hover {background-color: #ddd;}

        #bookmark th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: center;
            background-color: #04AA6D;
            color: white;
        }
    </style>
</body>
</html>
