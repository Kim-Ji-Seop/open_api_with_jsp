package org.openapi.jsp.open_data;

import com.google.gson.annotations.SerializedName;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class WifiInfo {
    @SerializedName(value = "X_SWIFI_MGR_NO") private String managementNum; // 관리번호
    @SerializedName(value = "X_SWIFI_WRDOFC") private String region; // 자치구
    @SerializedName(value = "X_SWIFI_MAIN_NM") private String nameOfWifi; // 와이파이명
    @SerializedName(value = "X_SWIFI_ADRES1") private String streetAddress; // 도로명주소
    @SerializedName(value = "X_SWIFI_ADRES2") private String detailedAddress; // 상세주소
    @SerializedName(value = "X_SWIFI_INSTL_FLOOR") private String installedFloor; // 설치위치(층)
    @SerializedName(value = "X_SWIFI_INSTL_TY") private String installedType; // 설치유형
    @SerializedName(value = "X_SWIFI_INSTL_MBY") private String installedPosition; // 설치기관
    @SerializedName(value = "X_SWIFI_SVC_SE") private String serviceDivision; // 서비스구분
    @SerializedName(value = "X_SWIFI_CMCWR") private String networkType; // 망종류
    @SerializedName(value = "X_SWIFI_CNSTC_YEAR") private String installedYear; // 설치년도
    @SerializedName(value = "X_SWIFI_INOUT_DOOR") private String inOrOutdoorDivision; // 실내외구분
    @SerializedName(value = "X_SWIFI_REMARS3") private String connectionEnv; // WIFI접속환경
    @SerializedName(value = "LAT") private String latCoordinate; // x좌표
    @SerializedName(value = "LNT") private String lntCoordinate; // y좌표
    @SerializedName(value = "WORK_DTTM") private String workDate; // 작업일자
}
