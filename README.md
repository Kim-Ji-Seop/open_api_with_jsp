# 기능
## 1. 와이파이 정보 불러오기
![1.png](commit_image%2F1.png)
- 총 25162개의 와이파이 정보를 불러오는 OpenAPI를 호출하는 페이지입니다.
- 1000개씩 `페이징` 처리하여 불러오게 되는데요. 때문에 index.jsp > load-wifi.jsp로 넘어갈 때, 딜레이가 생깁니다.
- 만약 이미 테이블에 정보가 존재하지만, OpenAPI를 호출하게 되면 중복으로 판단하여 해당 `관리번호`와 같은 row에 대해서는 updated 시간을 업데이트 합니다.
  - 이를 위해, 와이파이 정보가 저장되는 wifi_info 테이블을 만들 때, management_num이라는 관리번호 컬럼을 unique값으로 설정해주고
  - 와이파이 정보들을 DB에 insert를 할 때, insert or ignore into 문법을 써서 `중복 시 무시`라는 쿼리를 사용했습니다.
```mysql
INSERT OR IGNORE INTO wifi_info (management_num, region, name_of_wifi,
street_address, detailed_address, installed_floor, installed_type,
installed_position, service_division, network_type, installed_year,
in_or_outdoor_division, connection_env, lat_coordinate, lnt_coordinate, work_date)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
```
  - ![2.png](commit_image%2F2.png)
  - id 값도 PK값이라서 이를 기준으로 중복처리를 할 수 있다고 생각했지만, OpenAPI 데이터에 포함된 사항이 아니기 때문에
    - 해당 데이터에서의 unique값이라고 할 수 있는 관리번호를 기준으로 중복처리를 했습니다.
    - 따라서, management_num 컬럼을 unique로 설정해뒀습니다.
    - ![3.png](commit_image%2F3.png)
## 2. 내 위치 가져오기
- 이 기능은 JavaScript 계열의 함수로 처리했습니다.
```javascript
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
```
- 여기서 getLocation() 함수로 위치를 불러온 다음
- showPosition() 함수로 페이지에 위치를 보여주고
- 이와 동시에 sendPositionToServer() 함수를 사용하여 위치정보를 서버에 보냅니다.
- 서버에 보내는 이유는, `위치 히스토리 목록`을 구현하기 위함입니다.

## 3. 근처 WIFI 정보 보기
![4.png](commit_image%2F4.png)
- `내 위치 가져오기`로 가져와진 경도와 위도값을 근거로 하여
- 해당 위치에서 가장 가까운 위치 20곳을 가져와 보여줍니다.
- `거리` 정보는, 두 지점의 경도와 위도를 기준으로 계산하는 쿼리를 보내어 추가한 정보입니다.
```mysql
SELECT round((6371 * acos(cos(radians(?)) * cos(radians(lat_coordinate)) * cos(radians(lnt_coordinate) - radians(?)) + sin(radians(?)) * sin(radians(lat_coordinate)))),4) AS distance, management_num, region, name_of_wifi, street_address, detailed_address, installed_floor, installed_type, installed_position, service_division, network_type, installed_year, in_or_outdoor_division, connection_env, lat_coordinate, lnt_coordinate, work_date
FROM wifi_info
ORDER BY distance
LIMIT 20;
```
## 4. 위치 히스토리 목록
![5.png](commit_image%2F5.png)
- `내 위치 가져오기`를 통해 가져온 위치정보는 DB에도 저장되어 이렇게 히스토리 형태로 보여줄 수 있습니다.
- 가장 최근에 조회한 위치를 상단에 배치하고자, ID값을 기준으로 내림차순 했습니다.
- 물론, `삭제` 또한 가능합니다.
## 5. 와이파이 상세정보
![6.png](commit_image%2F6.png)
- URL 상에, `관리번호`와 `거리`값을 쿼리스트링으로 넣고, 관련된 와이파이 상세정보를 GET 해옵니다.
## 6. 북마크 그룹 관리 - 목록
![7.png](commit_image%2F7.png)
- 처음엔 정보가 없으며, UX를 조금 고려하여 정보가 없다는 글을 default로 넣어두었습니다.

![8.png](commit_image%2F8.png)
- 북마크가 추가된 모습이고, 이때 `ID`값은 DB상의 `PK`값을 뜻하며, `순서`가 유의미한 값이라고 보면됩니다.
- `수정일자`는 현재 아무것도 없는 상태이며, 그룹을 `추가했을 때`는 보여주지 않습니다. `수정을 했을 때` 해당 데이터가 업데이트되면서, 보이게 됩니다.
## 7. 북마크 그룹 관리 - 추가
![9.png](commit_image%2F9.png)
- 여기서 북마크 이름과 순서를 쓰고 추가하면
- 다음과 같이 `그룹 관리 목록`에서 추가된 모습을 볼 수 있습니다.

![10.png](commit_image%2F10.png)
## 8. 북마크 그룹 관리 - 수정
![12.png](commit_image%2F12.png)
- 해당 데이터 중, `북마크 이름`을 "공원"으로 수정해본다면 다음과 같습니다.

![11.png](commit_image%2F11.png)
- 또한, 전에 보이지 않았던 `수정일자`가 보이는 것을 알 수 있습니다.
## 9. 북마크 그룹 관리 - 삭제
![13.png](commit_image%2F13.png)
- 삭제를 클릭 했을 때, 해당 테이터를 삭제하게 되며, 목록에는 다음과 같이 보입니다.

![14.png](commit_image%2F14.png)
- 삭제된 모습을 볼 수 있습니다.
## 10. 북마크 보기 - 추가
- `북마크 보기`는, 와이파이 정보를 북마크에 추가했을 때 나오는 정보입니다. 따라서 처음에는 데이터가 없습니다.
![15.png](commit_image%2F15.png)

- 특정 와이파이 정보를 특정 북마크 그룹에 추가하는 화면입니다.
![16.png](commit_image%2F16.png)
- 다음과 같이, 추가를 했을 때는 `북마크 보기 페이지`로 리다이렉트하여 추가된 모습을 바로 볼 수 있게 하였습니다. 
![17.png](commit_image%2F17.png)
- 이 기능에서 유일하게 `와이파이_정보 테이블`, `북마크 테이블`에서의 `FK`를 통한 `join`이 일어나게 됩니다.
## 11. 북마크 보기 - 삭제
![18.png](commit_image%2F18.png)
- 해당 북마크를 삭제할 때의 jsp페이지이며, 이를 삭제하면 다음과 같습니다.
![19.png](commit_image%2F19.png)