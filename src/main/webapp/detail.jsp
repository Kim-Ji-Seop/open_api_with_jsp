<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="org.openapi.jsp.DBConnection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.openapi.jsp.Bookmark" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>와이파이 상세정보</title>
    <link href="css/wifi_table.css" rel="stylesheet" type="text/css">
    <style>
        .coordinates-container {
            display: flex;
            margin-bottom: 10px;
        }
        .coordinates-container div {
            margin-right: 5px;
        }
        input[type="text"] {
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 8px;
            width: 150px;
        }
        button {
            padding: 8px 15px;
            background-color: #f5f5f5;
            border: 1px solid #ccc;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #e8e8e8;
        }
    </style>
</head>
<body>
    <h1>와이파이 상세정보</h1>
    <br/>
    <a href="index.jsp">홈</a>
    <a href="history.jsp">위치 히스토리 목록</a>
    <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>
    <a href="bookmark-list.jsp">북마크 보기</a>
    <a href="bookmark-group.jsp">북마크 그룹 관리</a>

<%
    String mngNum = request.getParameter("mngNum"); // URL 파라미터에서 관리번호 가져오기
    String distance = request.getParameter("distance");
    // mngNum을 사용해서 데이터베이스 쿼리 수행
    DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
    Connection conn = connection.connectDB();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    List<Bookmark> bookmarks = new ArrayList<>();
    try {
        bookmarks = connection.getAllBookmarkNames();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
    <div class="coordinates-container">
        <div>
            <form action="WifiBookmarkJoinServlet" method="POST" accept-charset="UTF-8">
                <select id="bookmarkGroup" name="bookmarkGroupId">
                    <option value="">북마크 그룹 이름 선택</option>
                    <%
                        for (Bookmark bookmark : bookmarks) {
                            out.print("<option value=\"" + bookmark.getId() + "\">" + bookmark.getBookmarkName() + "</option>");
                        }
                    %>
                </select>
                <input type="hidden" name="mngNum" value="<%=mngNum%>">
                <input type="submit" value="북마크 추가하기">
            </form>
        </div>
    </div>

    <table id="detail">
        <tr>
            <th>거리(Km)</th>
            <td><%=distance%></td>
        </tr>
        <tr>
            <th>관리번호</th>
            <td><%=mngNum%></td>
        </tr>
<%
    try {
        conn = connection.connectDB();
        String query = "SELECT * " +
                       "FROM wifi_info " +
                       "WHERE management_num = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, mngNum); // 쿼리에 관리번호 세팅
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 데이터베이스에서 조회한 정보를 사용하여 페이지에 표시
            String region = rs.getString("region");
            String nameOfWifi = rs.getString("name_of_wifi");
            String streetAddress = rs.getString("street_address");
            String detailedAddress = rs.getString("detailed_address");
            String installedFloor = rs.getString("installed_floor");
            String installedType = rs.getString("installed_type");
            String installedPosition = rs.getString("installed_position");
            String serviceDivision = rs.getString("service_division");
            String networkType = rs.getString("network_type");
            String installedYear = rs.getString("installed_year");
            String inOrOutdoorDivision = rs.getString("in_or_outdoor_division");
            String connectionEnv = rs.getString("connection_env");
            String latCoordinate = rs.getString("lat_coordinate");
            String lntCoordinate = rs.getString("lnt_coordinate");
            String workDate = rs.getString("work_date");%>
        <tr>
            <th>자치구</th>
            <td><%=region%></td>
        </tr>
        <tr>
            <th>와이파이명</th>
            <td>
                <a href="/Gradle___org_openapi___jsp_1_0_SNAPSHOT_war/detail.jsp?mngNum=<%=mngNum%>&distance=<%=distance%>">
                    <%=nameOfWifi%>
                </a>

            </td>
        </tr>
        <tr>
            <th>도로명주소</th>
            <td><%=streetAddress%></td>
        </tr>
        <tr>
            <th>상세주소</th>
            <td><%=detailedAddress%></td>
        </tr>
        <tr>
            <th>설치위치(층)</th>
            <td><%=installedFloor%></td>
        </tr>
        <tr>
            <th>설치유형</th>
            <td><%=installedType%></td>
        </tr>
        <tr>
            <th>설치기관</th>
            <td><%=installedPosition%></td>
        </tr>
        <tr>
            <th>서비스구분</th>
            <td><%=serviceDivision%></td>
        </tr>
        <tr>
            <th>망종류</th>
            <td><%=networkType%></td>
        </tr>
        <tr>
            <th>설치년도</th>
            <td><%=installedYear%></td>
        </tr>
        <tr>
            <th>실내외구분</th>
            <td><%=inOrOutdoorDivision%></td>
        </tr>
        <tr>
            <th>WIFI접속환경</th>
            <td><%=connectionEnv%></td>
        </tr>
        <tr>
            <th>X좌표</th>
            <td><%=latCoordinate%></td>
        </tr>
        <tr>
            <th>Y좌표</th>
            <td><%=lntCoordinate%></td>
        </tr>
        <tr>
            <th>작업일자</th>
            <td><%=workDate%></td>
        </tr>
    </table>
<%
        }
    } catch (SQLException e) {
        e.printStackTrace();
        // 오류 처리
    } finally {
        // 자원 해제
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>


    <style>
        #detail {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }
        #detail th {
            width: 20%; /* th의 너비를 전체에서 30%로 설정 */
        }

        #detail td {
            width: 80%; /* td의 너비를 전체에서 70%로 설정 */
        }
        #detail td, #detail th {
            border: 1px solid #ddd;
            padding: 15px;
        }

        #detail tr:nth-child(even){
            background-color: #f2f2f2;
            padding-top: 12px;
            padding-bottom: 12px;
        }

        #detail td {
            padding: 20px; /* td 칸이 더 넓게 보이도록 padding 값을 늘림 */
        }

        #detail tr:hover {background-color: #ddd;}

        #detail th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: center;
            background-color: #04AA6D;
            color: white;
        }

        .inline-div {
            display: inline-block;
            margin-right: 10px;
        }
    </style>
</body>
</html>
