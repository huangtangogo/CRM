<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2020/5/29
  Time: 21:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <title>测试文件上传</title>
</head>
<body>
<form action="workbench/activity/fileUpLoad.do" method="post" enctype="multipart/form-data">
    <input type="file" name="myFile"/>
    <input type="submit" value="上传"/>
</form>
</body>
</html>
