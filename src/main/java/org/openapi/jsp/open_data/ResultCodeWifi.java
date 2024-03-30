package org.openapi.jsp.open_data;

import com.google.gson.annotations.SerializedName;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResultCodeWifi {
    @SerializedName(value = "CODE") private String code;
    @SerializedName(value = "MESSAGE") private String message;
}
