package org.openapi.jsp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookmarkWifiJoin {
    private int id;
    private String bookmarkName;
    private String wifiName;
    private String created;
    private int wifiIdx;
}
