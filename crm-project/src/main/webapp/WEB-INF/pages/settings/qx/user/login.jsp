<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        //页面加载完毕执行
        $(function () {
            //按下回车键发送请求,在整个页面均可以按回车发送请求
            $(window).keydown(function(e){//e表示整个事件的全部信息
                if(e.keyCode == 13){//回车键号码是13
                    $("#loginBtn").click();//模拟发生单击事件
                }
            }) ;

            //单击事件发生执行
            $("#loginBtn").click(function () {
                //获取用户输入参数
                var loginAct = $.trim($("#loginAct").val());
                var loginPwd = $.trim($("#loginPwd").val());
                var isRemPwd = $("#isRemPwd").prop("checked");//不使用attr获取，因为有可能获取不到

                //判断用户输入信息是否符合要求
                if (loginAct == "") {
                    alert("请输入用户名");
                    return;
                }
                if (loginPwd == "") {
                    alert("请输入密码");
                    return;
                }
                //发送请求，验证到响应中间可能因为网络问题导致延迟，需要告诉客户正在发送请求
                //$("#msg").text("正在验证，请稍后...");//一般都在这里验证
                //发送ajax请求
                $.ajax({
                    url: "settings/qx/user/login.do",
                    type: "post",
                    dataType: "json",
                    async: true,
                    data: {
                        loginAct: loginAct,
                        loginPwd: loginPwd,
                        isRemPwd: isRemPwd
                    },
                    success: function (data) {
                        //每次都清空span信息
                        $("#msg").empty();
                        //判断返回结果的code是否允许登录
                        if (data.code == "0") {
                            $("#msg").text(data.message);
                        } else {
                            //跳转后台页面
                            window.location.href = "workbench/index.do";
                        }
                    },
                    //测试其他方法，使用beforeSend属性，在发送ajax之前验证
                   beforeSend:function(){
                        $("#msg").text("正在登录，请稍后...");
                   }
                })
            })
        })
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <div class="form-group form-group-lg">
            <div style="width: 350px;">
                <input class="form-control" id="loginAct" type="text" placeholder="用户名"
                       value="${cookie.loginAct.value}">
            </div>
            <div style="width: 350px; position: relative;top: 20px;">
                <input class="form-control" id="loginPwd" type="password" placeholder="密码"
                       value="${cookie.loginPwd.value}">
            </div>
            <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                <label>
                    <%--加上c标签，表示如果本地cookie中保存用户信息，自动登录就勾选上--%>
                   <c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
                       <input id="isRemPwd" type="checkbox" checked="true"/>
                   </c:if>
                   <c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
                       <input id="isRemPwd" type="checkbox"/>
                   </c:if>
                    十天内免登录
                </label>
                &nbsp;&nbsp;
                <span id="msg" style="color:red"></span>
            </div>
            <button id="loginBtn" class="btn btn-primary btn-lg btn-block"
                    style="width: 350px; position: relative;top: 45px;">登录
            </button>
        </div>

    </div>
</div>
</body>
</html>