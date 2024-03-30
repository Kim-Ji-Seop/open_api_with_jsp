package org.openapi.jsp.open_data;

import com.google.gson.Gson;
import org.openapi.jsp.DBConnection;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.SQLException;

public class GetOpenApi {
    public TbPublicWifiInfoWrapper getJson(long start, long end) throws IOException {
        StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088"); /*URL*/
        urlBuilder.append("/" +  URLEncoder.encode("4b4e5253416a736b3132324d6d467973","UTF-8") ); /*인증키 (sample사용시에는 호출시 제한됩니다.)*/
        urlBuilder.append("/" +  URLEncoder.encode("json","UTF-8") ); /*요청파일타입 (xml,xmlf,xls,json) */
        urlBuilder.append("/" + URLEncoder.encode("TbPublicWifiInfo","UTF-8")); /*서비스명 (대소문자 구분 필수입니다.)*/
        urlBuilder.append("/" + URLEncoder.encode(String.valueOf(start), "UTF-8"));
        urlBuilder.append("/" + URLEncoder.encode(String.valueOf(end), "UTF-8"));
        // 상위 5개는 필수적으로 순서바꾸지 않고 호출해야 합니다.


        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode()); /* 연결 자체에 대한 확인이 필요하므로 추가합니다.*/
        BufferedReader rd;

        // 서비스코드가 정상이면 200~300사이의 숫자가 나옵니다.
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        System.out.println(sb.toString());
        String json = sb.toString(); // API 호출로 얻은 JSON 문자열

        Gson gson = new Gson();
        return gson.fromJson(json, TbPublicWifiInfoWrapper.class);
    }
    public long fetchAndInsertData(DBConnection connection) {
        long total = 25162L; // 총 데이터 수
        final int pageSize = 1000; // 한 번에 가져올 데이터 수
        long start = 1; // 시작 인덱스
        long end = pageSize; // 종료 인덱스

        Connection conn = connection.connectDB(); // 데이터베이스 연결

        try {
            // 페이지네이션을 위한 루프
            while (start <= total) {
                TbPublicWifiInfoWrapper wrapper = getJson(start, end);
                if(wrapper.getTbPublicWifiInfo().getList_total_count() != total){
                    total = wrapper.getTbPublicWifiInfo().getList_total_count();
                }
                connection.insertWifiInfo(conn, wrapper); // 데이터베이스에 삽입
                start += pageSize;
                end += pageSize;
                if (end > total) {
                    end = total;
                }
            }
        } catch (ArrayIndexOutOfBoundsException | IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return total;
    }

}
