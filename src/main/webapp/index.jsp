<%@ page import="org.openapi.jsp.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    DBConnection connection = new DBConnection("jdbc:sqlite:/Users/kimjiseop/Desktop/jsp_project/jsp/OpenApi.sqlite");
    Connection conn = connection.connectDB();
    connection.createTable(conn);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Open API with JSP</title>
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
        <h1>와이파이 정보 구하기</h1>
        <br/>
            <a href="index.jsp">홈</a>
            <a href="history.jsp">위치 히스토리 목록</a>
            <a href="load-wifi.jsp">Open API 와이파이 정보 가져오기</a>
            <a href="bookmark-list.jsp">북마크 보기</a>
            <a href="bookmark-group.jsp">북마크 그룹 관리</a>
        <div class="coordinates-container">
            <form id="locationForm" onsubmit="return false;">
                <div class="inline-div">
                    <label for="lat">LAT:</label>
                    <input type="text" id="lat" name="lat" placeholder="위도" readonly>
                </div>
                <div class="inline-div">
                    <label for="lnt">LNT:</label>
                    <input type="text" id="lnt" name="lnt" placeholder="경도" readonly>
                </div>
                <div class="inline-div">
                    <button type="button" onclick="getLocation()">내 위치 가져오기</button>
                </div>
                <div class="inline-div">
                    <button type="button" onclick="submitLocation()">근처 WIFI 정보 보기</button>
                </div>
            </form>

        </div>
        <script>
            function submitLocation() {
                var lat = document.getElementById('lat').value;
                var lnt = document.getElementById('lnt').value;

                var xhr = new XMLHttpRequest();
                xhr.open('GET', '/Gradle___org_openapi___jsp_1_0_SNAPSHOT_war/getWifiInfo?lat=' + lat + '&lnt=' + lnt, true);
                xhr.onload = function () {
                    if (this.status == 200) {
                        var data = JSON.parse(this.responseText);
                        console.log(data);
                        updateTable(data);
                    } else {
                        console.error('서버에서 데이터를 가져오는데 문제가 발생했습니다.');
                    }
                };
                xhr.send();
            }

            function updateTable(data) {
                var table = document.getElementById('wifi');
                var tableBody = table.querySelector('tbody');
                var defaultMessage = document.getElementById('defaultMessage');

                if (data.length > 0) {
                    // 데이터가 있으면 기본 메시지 숨기기
                    defaultMessage.style.display = 'none';
                } else {
                    // 데이터가 없으면 기본 메시지 보여주기
                    defaultMessage.style.display = '';
                }
                tableBody.innerHTML = ''; // 테이블 내용을 초기화

                // 서버로부터 받은 데이터로 테이블 로우 생성
                data.forEach(function(rowData) {
                    var row = tableBody.insertRow();
                    row.insertCell(0).innerHTML = rowData.distance; // '거리(Km)' 필드
                    row.insertCell(1).innerHTML = rowData.managementNum; // '관리번호' 필드
                    row.insertCell(2).innerHTML = rowData.autoRegion; // '자치구' 필드
                    //row.insertCell(3).innerHTML = rowData.nameOfWifi; // '와이파이명' 필드
                    row.insertCell(3).innerHTML = '<a href="detail.jsp?mngNum=' + encodeURIComponent(rowData.managementNum) + '&distance='+ encodeURIComponent(rowData.distance) + '">' + rowData.nameOfWifi + '</a>';
                    row.insertCell(4).innerHTML = rowData.streetAddress; // '도로명주소' 필드
                    row.insertCell(5).innerHTML = rowData.detailedAddress; // '상세주소' 필드
                    row.insertCell(6).innerHTML = rowData.installedFloor; // '설치위치(층)' 필드
                    row.insertCell(7).innerHTML = rowData.installedType; // '설치유형' 필드
                    row.insertCell(8).innerHTML = rowData.installedPosition; // '설치기관' 필드
                    row.insertCell(9).innerHTML = rowData.serviceDivision; // '서비스구분' 필드
                    row.insertCell(10).innerHTML = rowData.networkType; // '망종류' 필드
                    row.insertCell(11).innerHTML = rowData.installedYear; // '설치년도' 필드
                    row.insertCell(12).innerHTML = rowData.inOrOutdoorDivision; // '실내외구분' 필드
                    row.insertCell(13).innerHTML = rowData.connectionEnv; // 'WIFI접속환경' 필드
                    row.insertCell(14).innerHTML = rowData.latCoordinate; // 'X좌표' 필드
                    row.insertCell(15).innerHTML = rowData.lntCoordinate; // 'Y좌표' 필드
                    row.insertCell(16).innerHTML = rowData.workDate; // '작업일자' 필드
                });

                // 데이터가 없을 경우의 메시지
                if (data.length === 0) {
                    var row = tableBody.insertRow();
                    var cell = row.insertCell();
                    cell.setAttribute('colspan', '17');
                    cell.innerHTML = '근처 WIFI 정보가 없습니다.';
                }
            }

        </script>


        <script>
            function getLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(showPosition, showError);
                } else {
                    alert("Geolocation is not supported by this browser.");
                }
            }

            function showPosition(position) {
                document.getElementById('lat').value = position.coords.latitude;
                document.getElementById('lnt').value = position.coords.longitude;
                sendPositionToServer(position);
            }
            function sendPositionToServer(position) {
                var lat = position.coords.latitude;
                var lnt = position.coords.longitude;
                var data = JSON.stringify({ lat: lat, lnt: lnt });

                console.log("Sending JSON data to the server:", data); // JSON 데이터 콘솔에 출력
                // XMLHttpRequest 객체 생성
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "LocationServlet", true);
                xhr.setRequestHeader("Content-Type", "application/json");
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        alert("위치가 서버에 저장되었습니다.");
                    } else {
                        alert("서버에 위치를 저장하는 데 실패했습니다.");
                    }
                };
                xhr.send(data);
            }
            function showError(error) {
                switch(error.code) {
                    case error.PERMISSION_DENIED:
                        alert("User denied the request for Geolocation.");
                        break;
                    case error.POSITION_UNAVAILABLE:
                        alert("Location information is unavailable.");
                        break;
                    case error.TIMEOUT:
                        alert("The request to get user location timed out.");
                        break;
                    case error.UNKNOWN_ERROR:
                        alert("An unknown error occurred.");
                        break;
                }
            }
        </script>
        <br/>
        <table id="wifi">
            <thead>
            <tr>
                <th>거리(Km)</th>
                <th>관리번호</th>
                <th>자치구</th>
                <th>와이파이명</th>
                <th>도로명주소</th>
                <th>상세주소</th>
                <th>설치위치(층)</th>
                <th>설치유형</th>
                <th>설치기관</th>
                <th>서비스구분</th>
                <th>망종류</th>
                <th>설치년도</th>
                <th>실내외구분</th>
                <th>WIFI접속환경</th>
                <th>X좌표</th>
                <th>Y좌표</th>
                <th>작업일자</th>
            </tr>
            </thead>
            <tbody>
                <tr id="defaultMessage">
                    <td colspan="17" style="text-align:center;">위치 정보를 입력한 후에 조회해 주세요.</td>
                </tr>
            </tbody>
        </table>
    </body>
</html>