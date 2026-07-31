<%@ tag pageEncoding="UTF-8"%>
<%@ attribute name="value" required="true" rtexprvalue="true" %>
<%@ attribute name="width" required="false" rtexprvalue="true" %>
<%@ attribute name="height" required="false" rtexprvalue="true" %>
<%@ attribute name="defaultImg" required="false" rtexprvalue="true" %>
<%
    String v = (String) value;
    String w = (width == null) ? "400" : width;
    String h = (height == null) ? "400" : height;

    boolean isUrl = (v != null && (v.startsWith("http://") || v.startsWith("https://")));
    boolean isEmpty = (v == null || v.trim().isEmpty() || "null".equals(v));
    boolean fileMissing = false;
    if (!isUrl && !isEmpty) {
        String realPath = application.getRealPath("/") + v;
        fileMissing = !new java.io.File(realPath).exists();
    }

    String fallback = (defaultImg != null)
        ? defaultImg
        : "https://placehold.co/" + w + "x" + h + "?text=No+Image";

    String result;
    if (isEmpty || (!isUrl && fileMissing)) {
        result = fallback;
    } else {
        result = v;
    }
    out.print(result);
%>
