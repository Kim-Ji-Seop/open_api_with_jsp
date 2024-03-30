package org.openapi.jsp.open_data;

import com.google.gson.annotations.SerializedName;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class TbPublicWifiInfo {
    private Long list_total_count;

    @SerializedName(value = "RESULT")
    private ResultCodeWifi result;

    private List<WifiInfo> row;
}
