<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <h1>북마크 그룹 이름 추가</h1>
    <br/>
    <a href="index.jsp">홈</a>
    <a href="history.jsp">위치 히스토리 목록</a>
    <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>
    <a href="bookmark-list.jsp">북마크 보기</a>
    <a href="bookmark-group.jsp">북마크 그룹 관리</a>
    <form action="BookmarkAddServlet" method="POST" accept-charset="UTF-8">
        <table id="bookmark-group-add">
            <tr>
                <th>북마크 이름</th>
                <td>
                    <input type="text" id="bookmarkName" name="bookmarkName"><br>
                </td>
            </tr>
            <tr>
                <th>순서</th>
                <td>
                    <input type="text" id="orderNum" name="orderNum"><br>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;">
                    <input type="submit" value="추가">
                </td>
            </tr>
        </table>
    </form>

    <style>
        #bookmark-group-add {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }
        #bookmark-group-add th {
            width: 20%; /* th의 너비를 전체에서 30%로 설정 */
        }

        #bookmark-group-add td {
            width: 80%; /* td의 너비를 전체에서 70%로 설정 */
        }
        #bookmark-group-add td, #bookmark-group-add th {
            border: 1px solid #ddd;
            padding: 15px;
        }

        #bookmark-group-add tr:nth-child(even){
            background-color: #f2f2f2;
            padding-top: 12px;
            padding-bottom: 12px;
        }

        #bookmark-group-add td {
            padding: 20px; /* td 칸이 더 넓게 보이도록 padding 값을 늘림 */
        }

        #bookmark-group-add tr:hover {background-color: #ddd;}

        #bookmark-group-add th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: center;
            background-color: #04AA6D;
            color: white;
        }

    </style>

</body>
</html>
