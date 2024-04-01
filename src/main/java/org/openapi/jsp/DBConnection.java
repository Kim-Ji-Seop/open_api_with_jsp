package org.openapi.jsp;

import org.openapi.jsp.open_data.TbPublicWifiInfoWrapper;
import org.openapi.jsp.open_data.WifiInfo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DBConnection {
    private String dbUrl;

    // 생성자에서 DB 경로를 받습니다.
    public DBConnection(String dbUrl) {
        this.dbUrl = dbUrl;
    }

    private static final String JDBC_DRIVER = "org.sqlite.JDBC";

    public Connection connectDB() {
        Connection conn = null;
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(dbUrl);
        } catch ( Exception e ) {
            System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            System.exit(0);
        }
        return conn;
    }
    public void createTable(Connection conn)
    {
        Statement stmt = null;
        try {
            stmt = conn.createStatement();
            String sql =
                    "CREATE TABLE IF NOT EXISTS bookmark\n" +
                    "(\n" +
                    "    id                    INTEGER PRIMARY KEY AUTOINCREMENT,\n" +
                    "    bookmark_name         TEXT NOT NULL,\n" +
                    "    bookmark_order_num    INTEGER NOT NULL,\n" +
                    "    created               TEXT DEFAULT current_timestamp,\n" +
                    "    updated               TEXT DEFAULT current_timestamp,\n" +
                    "    status                TEXT DEFAULT 'A'\n" +
                    ");" +
                    "CREATE TABLE IF NOT EXISTS wifi_info\n" +
                    "(\n" +
                    "    id                      INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
                    "    management_num          TEXT NOT NULL UNIQUE, \n" +
                    "    region                  TEXT NOT NULL, \n" +
                    "    name_of_wifi            TEXT NOT NULL, \n" +
                    "    street_address          TEXT NOT NULL, \n" +
                    "    detailed_address        TEXT NOT NULL, \n" +
                    "    installed_floor         TEXT NOT NULL, \n" +
                    "    installed_type          TEXT NOT NULL, \n" +
                    "    installed_position      TEXT NOT NULL, \n" +
                    "    service_division        TEXT NOT NULL, \n" +
                    "    network_type            TEXT NOT NULL, \n" +
                    "    installed_year          TEXT NOT NULL, \n" +
                    "    in_or_outdoor_division  TEXT NOT NULL, \n" +
                    "    connection_env          TEXT NOT NULL, \n" +
                    "    lat_coordinate          TEXT NOT NULL, \n" +
                    "    lnt_coordinate          TEXT NOT NULL, \n" +
                    "    work_date               TEXT NOT NULL, \n" +
                    "    created                 TEXT DEFAULT current_timestamp, \n" +
                    "    updated                 TEXT DEFAULT current_timestamp, \n" +
                    "    status                  TEXT DEFAULT 'A',\n" +
                    "    bookmarkIdx             INTEGER," +
                    "    FOREIGN KEY (bookmarkIdx) REFERENCES bookmark(id)" +
                    ");\n" +
                    "\n" +
                    "-- gps_history Table Create SQL for SQLite\n" +
                    "CREATE TABLE IF NOT EXISTS gps_history\n" +
                    "(\n" +
                    "    id              INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
                    "    lat_coordinate  TEXT NOT NULL, \n" +
                    "    lnt_coordinate  TEXT NOT NULL, \n" +
                    "    created         TEXT NOT NULL DEFAULT current_timestamp, \n" +
                    "    updated         TEXT DEFAULT current_timestamp, \n" +
                    "    status          TEXT DEFAULT 'A'\n" +
                    ");";
            stmt.executeUpdate(sql);
            stmt.close();
            conn.close();
        } catch ( Exception e ) {
            System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            System.exit(0);
        }
    }

    public void insertWifiInfo(Connection conn, TbPublicWifiInfoWrapper wrapper){
        String sql =
                "INSERT OR IGNORE INTO wifi_info (management_num, region, name_of_wifi, " +
                "street_address, detailed_address, installed_floor, installed_type, " +
                "installed_position, service_division, network_type, installed_year, " +
                "in_or_outdoor_division, connection_env, lat_coordinate, lnt_coordinate, work_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        String updateSql =
                "UPDATE wifi_info " +
                "SET updated = datetime('now') " +
                "WHERE management_num = ?;";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             PreparedStatement updatePstmt = conn.prepareStatement(updateSql)) {
            for(WifiInfo info : wrapper.getTbPublicWifiInfo().getRow()){
                pstmt.setString(1, info.getManagementNum().isEmpty() ? "" : info.getManagementNum());
                pstmt.setString(2, info.getRegion().isEmpty() ? "" : info.getRegion());
                pstmt.setString(3, info.getNameOfWifi().isEmpty() ? "" : info.getNameOfWifi());
                pstmt.setString(4, info.getStreetAddress().isEmpty() ? "" : info.getStreetAddress());
                pstmt.setString(5, info.getDetailedAddress().isEmpty() ? "" : info.getDetailedAddress());
                pstmt.setString(6, info.getInstalledFloor().isEmpty() ? "" : info.getInstalledFloor());
                pstmt.setString(7, info.getInstalledType().isEmpty() ? "" : info.getInstalledType());
                pstmt.setString(8, info.getInstalledPosition().isEmpty() ? "" : info.getInstalledPosition());
                pstmt.setString(9, info.getServiceDivision().isEmpty() ? "" : info.getServiceDivision());
                pstmt.setString(10, info.getNetworkType().isEmpty() ? "" : info.getNetworkType());
                pstmt.setString(11, info.getInstalledYear().isEmpty() ? "" : info.getInstalledYear());
                pstmt.setString(12, info.getInOrOutdoorDivision().isEmpty() ? "" : info.getInOrOutdoorDivision());
                pstmt.setString(13, info.getConnectionEnv().isEmpty() ? "" : info.getConnectionEnv());
                pstmt.setString(14, info.getLatCoordinate().isEmpty() ? "" : info.getLatCoordinate());
                pstmt.setString(15, info.getLntCoordinate().isEmpty() ? "" : info.getLntCoordinate());
                pstmt.setString(16, info.getWorkDate().isEmpty() ? "" : info.getWorkDate());
                pstmt.executeUpdate();

                updatePstmt.setString(1, info.getManagementNum());
                updatePstmt.executeUpdate();
            }

        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }
    public String selectAllWifiInfo(double lat, double lnt) throws SQLException {

        Connection conn = connectDB();

        String query = "SELECT round((6371 * acos(cos(radians(?)) * cos(radians(lat_coordinate)) * cos(radians(lnt_coordinate) - radians(?)) + sin(radians(?)) * sin(radians(lat_coordinate)))),4) AS distance, management_num, region, name_of_wifi, street_address, detailed_address, installed_floor, installed_type, installed_position, service_division, network_type, installed_year, in_or_outdoor_division, connection_env, lat_coordinate, lnt_coordinate, work_date\n" +
                       "FROM wifi_info\n" +
                       "ORDER BY distance\n" +
                       "LIMIT 20;";
        StringBuilder jsonResult = new StringBuilder("[");
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setDouble(1, lat);
        pstmt.setDouble(2, lnt);
        pstmt.setDouble(3, lat);
        try (ResultSet rs = pstmt.executeQuery()) {
            int count = 0;
            while (rs.next()) {
                if (count > 0) jsonResult.append(",\n");
                jsonResult.append("{");
                jsonResult.append("\"distance\":").append(rs.getDouble("distance")).append(",");
                jsonResult.append("\"managementNum\":").append("\"").append(rs.getString("management_num")).append("\",");
                jsonResult.append("\"autoRegion\":").append("\"").append(rs.getString("region")).append("\",");
                jsonResult.append("\"nameOfWifi\":").append("\"").append(rs.getString("name_of_wifi")).append("\",");
                jsonResult.append("\"streetAddress\":").append("\"").append(rs.getString("street_address")).append("\",");
                jsonResult.append("\"detailedAddress\":").append("\"").append(rs.getString("detailed_address")).append("\",");
                jsonResult.append("\"installedFloor\":").append("\"").append(rs.getString("installed_floor")).append("\",");
                jsonResult.append("\"installedType\":").append("\"").append(rs.getString("installed_type")).append("\",");
                jsonResult.append("\"installedPosition\":").append("\"").append(rs.getString("installed_position")).append("\",");
                jsonResult.append("\"serviceDivision\":").append("\"").append(rs.getString("service_division")).append("\",");
                jsonResult.append("\"networkType\":").append("\"").append(rs.getString("network_type")).append("\",");
                jsonResult.append("\"installedYear\":").append("\"").append(rs.getString("installed_year")).append("\",");
                jsonResult.append("\"inOrOutdoorDivision\":").append("\"").append(rs.getString("in_or_outdoor_division")).append("\",");
                jsonResult.append("\"connectionEnv\":").append("\"").append(rs.getString("connection_env")).append("\",");
                jsonResult.append("\"latCoordinate\":").append("\"").append(rs.getString("lat_coordinate")).append("\",");
                jsonResult.append("\"lntCoordinate\":").append("\"").append(rs.getString("lnt_coordinate")).append("\",");
                jsonResult.append("\"workDate\":").append("\"").append(rs.getString("work_date")).append("\"\n");
                jsonResult.append("}");
                count++;
            }
        }
        jsonResult.append("]");
        System.out.println(jsonResult);
        return jsonResult.toString();
    }

    public void insertCoordinate(double lat, double lnt){
        Connection conn = connectDB();
        String sql = "INSERT INTO gps_history (lat_coordinate,  lnt_coordinate) VALUES (?, ?)";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setString(1, String.valueOf(lat));
            pstmt.setString(2, String.valueOf(lnt));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public void insertBookmarkInfo(String bookmarkName, int orderNum){
        Connection conn = connectDB();
        String sql = "INSERT INTO bookmark(bookmark_name, bookmark_order_num)\n" +
                     "VALUES (?,?)";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setString(1, bookmarkName);
            pstmt.setInt(2, orderNum);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public List<Bookmark> selectAllBookmarkInfo() throws SQLException {
        List<Bookmark> bookmarks = new ArrayList<>();
        Connection conn = connectDB();
        String query =
                "SELECT id, bookmark_name, bookmark_order_num, created,\n" +
                "    CASE\n" +
                "       WHEN created = updated THEN ''\n" +
                "       ELSE updated\n" +
                "    END AS updated\n" +
                "FROM bookmark";

        try (PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Bookmark bookmark = new Bookmark();
                bookmark.setId(rs.getInt("id"));
                bookmark.setBookmarkName(rs.getString("bookmark_name"));
                bookmark.setBookmarkOrderNum(rs.getInt("bookmark_order_num"));
                bookmark.setCreated(rs.getString("created"));
                bookmark.setUpdated(rs.getString("updated"));
                bookmarks.add(bookmark);
            }
        }
        return bookmarks;
    }
    public List<Bookmark> getAllBookmarkNames() throws SQLException {
        List<Bookmark> bookmarks = new ArrayList<>();
        String query = "SELECT id, bookmark_name FROM bookmark";
        try (Connection conn = this.connectDB();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Bookmark bookmark = new Bookmark();
                bookmark.setId(rs.getInt("id"));
                bookmark.setBookmarkName(rs.getString("bookmark_name"));
                bookmarks.add(bookmark);
            }
        }
        return bookmarks;
    }

    public void updateWifiInBookmark(int id, String managementNumber) {
        Connection conn = connectDB();
        String sql = "UPDATE wifi_info " +
                     "SET bookmarkIdx = ? " +
                     "WHERE management_num = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, id);
            pstmt.setString(2, managementNumber);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public List<BookmarkWifiJoin> getAllBookmarkAndWifi() throws SQLException {
        List<BookmarkWifiJoin> bookmarkWifiJoins = new ArrayList<>();
        String query =
                "select b.id, b.bookmark_name, wi.name_of_wifi, (select datetime(wi.updated, '+9 hours')) as updated, wi.id as wifiIdx\n" +
                "from bookmark b\n" +
                "join wifi_info wi on b.id = wi.bookmarkIdx";
        try (Connection conn = this.connectDB();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                BookmarkWifiJoin bookmarkWifiJoin = new BookmarkWifiJoin();
                bookmarkWifiJoin.setId(rs.getInt("id"));
                bookmarkWifiJoin.setBookmarkName(rs.getString("bookmark_name"));
                bookmarkWifiJoin.setWifiName(rs.getString("name_of_wifi"));
                bookmarkWifiJoin.setCreated(rs.getString("updated"));
                bookmarkWifiJoin.setWifiIdx(rs.getInt("wifiIdx"));
                bookmarkWifiJoins.add(bookmarkWifiJoin);
            }
        }
        return bookmarkWifiJoins;
    }

    public void updateBookmarkInfo(int bookmarkIdx, String bookmarkName, int orderNum) {
        Connection conn = connectDB();
        String sql = "UPDATE bookmark " +
                     "SET bookmark_name = ?, bookmark_order_num = ? " +
                     "WHERE id = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setString(1, bookmarkName);
            pstmt.setInt(2, orderNum);
            pstmt.setInt(3, bookmarkIdx);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public void deleteBookmarkInfo(int bookmarkIdx) {
        Connection conn = connectDB();
        String sql = "DELETE FROM bookmark WHERE id = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, bookmarkIdx);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public void removeConnectWifiAndBookmark(int bookmarkIdx) {
        Connection conn = connectDB();
        String sql =
                "UPDATE wifi_info " +
                "SET bookmarkIdx = null\n" +
                "WHERE bookmarkIdx = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, bookmarkIdx);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public void deleteBookmarkListInfo(int wifiIdx) {
        Connection conn = connectDB();
        String sql =
                        "UPDATE wifi_info " +
                        "SET bookmarkIdx = null\n" +
                        "WHERE id = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, wifiIdx);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }
}
