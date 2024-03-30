<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
    <body>
        <h1>북마크 그룹 삭제</h1>
            <h3>북마크 그룹 이름을 삭제하시겠습니까?</h3>
            <form action="BookmarkDeleteServlet" method="POST" accept-charset="UTF-8">
                <table id="bookmark-group-delete">
                    <tr>
                        <th>북마크 이름</th>
                        <td>
                            <input type="text" id="bookmarkName" name="bookmarkName" value="<%=request.getParameter("bookmarkName") == null ? "" : URLDecoder.decode(request.getParameter("bookmarkName"), "UTF-8")%>">
                            <br>
                        </td>
                    </tr>
                    <tr>
                        <th>순서</th>
                        <td>
                            <input type="text" id="orderNum" name="orderNum" value="<%=request.getParameter("orderNum") == null ? "" : request.getParameter("orderNum")%>"><br>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align:center;">
                            <input type="hidden" name="bookmarkIdx" value="<%=request.getParameter("bookmarkIdx") == null ? "" : request.getParameter("bookmarkIdx")%>">
                            <a href="bookmark-group.jsp">돌아가기</a>
                            <input type="submit" value="삭제">
                        </td>
                    </tr>
                </table>
            </form>

            <style>
                #bookmark-group-delete {
                    font-family: Arial, Helvetica, sans-serif;
                    border-collapse: collapse;
                    width: 100%;
                }
                #bookmark-group-delete th {
                    width: 20%; /* th의 너비를 전체에서 30%로 설정 */
                }

                #bookmark-group-delete td {
                    width: 80%; /* td의 너비를 전체에서 70%로 설정 */
                }
                #bookmark-group-delete td, #bookmark-group-delete th {
                    border: 1px solid #ddd;
                    padding: 15px;
                }

                #bookmark-group-delete tr:nth-child(even){
                    background-color: #f2f2f2;
                    padding-top: 12px;
                    padding-bottom: 12px;
                }

                #bookmark-group-delete td {
                    padding: 20px; /* td 칸이 더 넓게 보이도록 padding 값을 늘림 */
                }

                #bookmark-group-delete tr:hover {background-color: #ddd;}

                #bookmark-group-delete th {
                    padding-top: 12px;
                    padding-bottom: 12px;
                    text-align: center;
                    background-color: #04AA6D;
                    color: white;
                }
            </style>
    </body>
</html>
