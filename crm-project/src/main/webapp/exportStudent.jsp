<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2020/5/28
  Time: 19:55
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
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <title>下载学生列表</title>
    <script type="text/javascript">
        $(function () {
            //给下载按钮添加单击事件
            $("#student").click(function(){
                //同步请求，显示下载窗口
                window.location.href="workbench/activity/fileDownLoad.do";
            });
        })
    </script>
</head>
<body>
<input type="button" id="student" value="下载"/>
</body>
</html>
