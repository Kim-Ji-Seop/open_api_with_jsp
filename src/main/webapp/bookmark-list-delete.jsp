<%@ page import="java.net.URLDecoder" %><%--
  Created by IntelliJ IDEA.
  User: kimjiseop
  Date: 3/30/24
  Time: 2:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <h1>북마크 삭제</h1>
    <h3>북마크를 삭제하시겠습니까?</h3>
    <form action="BookmarkListDeleteServlet" method="POST" accept-charset="UTF-8">
        <table id="bookmark-list-delete">
            <tr>
                <th>북마크 이름</th>
                <td>
                    <input type="text" id="bookmarkName" name="bookmarkName" value="<%=request.getParameter("bookmarkName") == null ? "" : URLDecoder.decode(request.getParameter("bookmarkName"), "UTF-8")%>" readonly>
                    <br>
                </td>
            </tr>
            <tr>
                <th>와이파이명</th>
                <td>
                    <input type="text" id="wifiName" name="wifiName" value="<%=URLDecoder.decode(request.getParameter("wifiName"), "UTF-8") == null ? "" : URLDecoder.decode(request.getParameter("wifiName"), "UTF-8")%>" readonly><br>
                </td>
            </tr>
            <tr>
                <th>등록일자</th>
                <td>
                    <input type="text" id="created" name="created" value="<%=request.getParameter("created") == null ? "" : request.getParameter("created")%>" readonly><br>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;">
                    <input type="hidden" name="wifiIdx" value="<%=request.getParameter("wifiIdx") == null ? "" : request.getParameter("wifiIdx")%>">
                    <a href="bookmark-list.jsp">돌아가기</a>
                    <input type="submit" value="삭제">
                </td>
            </tr>
        </table>
    </form>

    <style>
        #bookmark-list-delete {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }
        #bookmark-list-delete th {
            width: 20%; /* th의 너비를 전체에서 30%로 설정 */
        }

        #bookmark-list-delete td {
            width: 80%; /* td의 너비를 전체에서 70%로 설정 */
        }
        #bookmark-list-delete td, #bookmark-list-delete th {
            border: 1px solid #ddd;
            padding: 15px;
        }

        #bookmark-list-delete tr:nth-child(even){
            background-color: #f2f2f2;
            padding-top: 12px;
            padding-bottom: 12px;
        }

        #bookmark-list-delete td {
            padding: 20px; /* td 칸이 더 넓게 보이도록 padding 값을 늘림 */
        }

        #bookmark-list-delete tr:hover {background-color: #ddd;}

        #bookmark-list-delete th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: center;
            background-color: #04AA6D;
            color: white;
        }
    </style>

</body>
</html>
