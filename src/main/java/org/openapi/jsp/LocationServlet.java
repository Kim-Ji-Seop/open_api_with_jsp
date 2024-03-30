package org.openapi.jsp;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
@WebServlet("/LocationServlet")
public class LocationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String jsonData = sb.toString();
        Gson gson = new Gson();
        JsonObject jsonObject = gson.fromJson(jsonData, JsonObject.class);

        double lat = jsonObject.get("lat").getAsDouble();
        double lnt = jsonObject.get("lnt").getAsDouble();
        // DB 연결 및 INSERT 로직 (에러 처리는 생략함)
        try {
            DBConnection connection = (DBConnection) getServletContext().getAttribute("DBConnection");
            connection.insertCoordinate(lat, lnt);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
