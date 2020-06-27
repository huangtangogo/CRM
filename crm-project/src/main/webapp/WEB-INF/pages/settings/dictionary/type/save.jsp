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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            //给编码绑定失去焦点
            $("#create-code").blur(function () {
                checkCode();
            });
            //好的设计是，用户点击进表单，提示信息消失，获得焦点
            $("#create-code").focus(function () {
                $("#codeMsg").empty();//这个方法也是消除信息的意思，子级
            });

            //按下回车保存
            $(window).keydown(function(e){
                if(e.keyCode == 13){
                    $("#saveCreateDicTypeBtn").click();
                }
            })

            //编码验证通过之后,点击保存发送ajax请求，保存数据
            $("#saveCreateDicTypeBtn").click(function () {
                if (checkCode()) {
                    //先获取用户输入数据
                    var code = $.trim($("#create-code").val());
                    var name = $.trim($("#create-name").val());
                    var description = $.trim($("#create-description").val());

                    $.ajax({
                        url: "settings/dictionary/type/saveCreateDicType.do",
                        data: {
                            code: code,
                            name: name,
                            description: description
                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else {
                                window.location.href = "settings/dictionary/type/index.do"
                            }
                        }
                    })
                }
            })
        })
            //方法封装
            function checkCode() {
                //获取编码的值
                var code = $.trim($("#create-code").val());
                if (code == "") {//判断用户是否输入编码
                    $("#codeMsg").text("编码不能为空");
                    return false;
                } else {
                    //把之前的提示信息删除掉
                    $("#codeMsg").text("");
                }

                var ret = false;//设置初值
                //用户输入了，则发送ajax请求
                $.ajax({
                    url: "settings/dictionary/type/checkCode.do",
                    data: {
                        code: code
                    },
                    type: "post",
                    dataType: "json",
                    async: false,//必须设置为同步，否则验证和返回代码就分开执行了
                    success: function (data) {
                        if (data.code == "0") {
                            $("#codeMsg").text(data.message);
                            ret = false;//不能在这里返回，这里返回的是function方法
                        } else {
                            $("#codeMsg").text("");
                            ret = true;
                        }
                    }
                });
                return ret;
            }

    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>新增字典类型</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveCreateDicTypeBtn">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form">

    <div class="form-group">
        <label for="create-code" class="col-sm-2 control-label">编码<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-code" style="width: 200%;">
            <span style="color:red" id="codeMsg"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="create-name" class="col-sm-2 control-label">名称</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name" style="width: 200%;">
        </div>
    </div>

    <div class="form-group">
        <label for="create-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 300px;">
            <textarea class="form-control" rows="3" id="create-description" style="width: 200%;"></textarea>
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>