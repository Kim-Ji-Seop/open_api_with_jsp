<%@ page import="java.sql.Connection" %>
<%@ page import="org.openapi.jsp.DBConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="jdk.nashorn.internal.parser.JSONParser" %>
<%@ page import="org.openapi.jsp.Bookmark" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
    List<Bookmark> bookmarkList = null;
    try {
        bookmarkList = connection.selectAllBookmarkInfo();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
<html>
<head>
    <title>북마크 그룹 관리</title>

</head>
<body>
    <h1>북마크 그룹 관리</h1>
    <br/>
    <a href="index.jsp">홈</a>
    <a href="history.jsp">위치 히스토리 목록</a>
    <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>
    <a href="bookmark-list.jsp">북마크 보기</a>
    <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    <br/>
    <button onclick="location.href='bookmark-group-add.jsp'">북마크 이름 추가</button>
    <table id="bookmark">
        <thead>
        <tr>
            <th>ID</th>
            <th>북마크 이름</th>
            <th>순서</th>
            <th>등록일자</th>
            <th>수정일자</th>
            <th>비고</th>
        </tr>
        </thead>
        <tbody>
            <%
                if (bookmarkList.isEmpty()) {
            %>
            <tr id="defaultMessage">
                <td colspan="6" style="text-align:center;">정보가 존재하지 않습니다.</td>
            </tr>
            <%
            } else {
                for (Bookmark bookmark : bookmarkList) {
            %>
            <tr>
                <td><%=bookmark.getId()%></td>
                <td><%=bookmark.getBookmarkName()%></td>
                <td><%=bookmark.getBookmarkOrderNum()%></td>
                <td><%=bookmark.getCreated()%></td>
                <td><%=bookmark.getUpdated()%></td>
                <td>
                    <a href="bookmark-group-edit.jsp?bookmarkName=<%=URLEncoder.encode(bookmark.getBookmarkName(), "UTF-8")%>&orderNum=<%=bookmark.getBookmarkOrderNum()%>&bookmarkIdx=<%=bookmark.getId()%>">수정</a>
                    <a href="bookmark-group-delete.jsp?bookmarkName=<%=URLEncoder.encode(bookmark.getBookmarkName(), "UTF-8")%>&orderNum=<%=bookmark.getBookmarkOrderNum()%>&bookmarkIdx=<%=bookmark.getId()%>">삭제</a>
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
