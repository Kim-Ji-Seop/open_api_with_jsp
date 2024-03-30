package org.openapi.jsp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Bookmark {
    private int id;
    private String bookmarkName;
    private int bookmarkOrderNum;
    private String created;
    private String updated;
}
