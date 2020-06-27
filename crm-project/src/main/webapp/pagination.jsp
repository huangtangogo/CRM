<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <!--  JQUERY -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <!--  BOOTSTRAP -->
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <title>演示分页插件</title>
    <script type="text/javascript">
       $(function(){
           $("#demo_pag1").bs_pagination({
               currentPage:6,//显示当前页数
               rowsPerPage:8,//每页显示记录条数
               totalRows:64,//总记录条数
               totalPages:8,//总的页数
               visiblePageLinks:6,//显示翻页卡片数
               showGotoPage:true,//显示跳转当前页
               showRowsPerPage:true,//显示每页记录条数
               showRowsInfo:true,//显示每页记录信息
               //页面改变会执行此函数，并且可以返回当前页和每页显示记录条数
                onChangePage:function(e,pageObj){
                   alert("当前页:"+pageObj.currentPage+"每页显示记录条数："+pageObj.rowsPerPage);
                }
           })
       })
    </script>
</head>
<body>
<!--  Just create a div and give it an ID -->
<div id="demo_pag1"></div>
</body>
</html>