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
        $(function () {
            $("#createDicTypeBtn").click(function () {
                window.location.href = "settings/dictionary/type/toSave.do";
            })

            //全选和取消全选，测试不在$(function(){})区域中语法正不正确
            //全选和取消全选不是单独的函数，只有单独的函数才能放在外面
            //给全选绑定单击事件
            $("#checkedAll").click(function () {
                //所有的checkbox状态和全选按钮的状态保持一致
                $("#tBody input[type='checkbox']").prop("checked", $("#checkedAll").prop("checked"));
            });

            //给所有选择添加单击事件
            $("#tBody input[type='checkbox']").click(function () {
                //判断全选时的jQuery对象，对象由一个所有选中的dom对象组成数组，全选数组长度和已选择的数组长度进行比较
                if ($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()) {

                    $("#checkedAll").prop("checked", true);
                } else {
                    $("#checkedAll").prop("checked", false);
                }
            });

            //给用户删除绑定单击事件
            $("#deleteDicTypeBtn").click(function () {
                //获取参数，获取所有选中的checkbox,是一个保存dom对象的数组
                var checkCodes = $("#tBody input[type='checkbox']:checked");
                if (checkCodes.size() == 0) {
                    alert("至少选择一条记录");
                    return;
                }
                //遍历数组，获取每个dom对象的code值，请求参数如code=xxx&code=xxx&...
                var codesStr = "";
                $.each(checkCodes, function (i, n) {//this和n都是dom对象
                    codesStr += "code=" + n.value + "&";
                });
                //去掉最后一位的&,实际上不去的话也没事，浏览器会自动取去除
                codesStr = codesStr.substr(0,codesStr.length-1);
                //让用户选择是否发送ajax删除请求，弹出删除对话框
                if (window.confirm("确认删除吗？")) {
                    $.ajax({
                        url: "settings/dictionary/type/deleteDicTypeByCodes.do",
                        data: codesStr,
                        dataType: 'json',
                        type: "post",
                        success: function (data) {
                            if(data.code == 1){
                                window.location.href="settings/dictionary/type/index.do";
                            }else{
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            //给用户编辑注册单击事件
            $("#editDicTypeBtn").click(function () {
                //获取用户选中复选框
                var checkCodes = $("#tBody input[type='checkbox']:checked");
                if(checkCodes.size()>1){
                    alert("每次只能修改一条记录");
                    return;
                }
               if(checkCodes.size() == 0){
                   alert("请选择修改记录");
                   return;
               }
               var code = checkCodes[0].value;
               //发送请求
               window.location.href="settings/dictionary/type/editDicType.do?code="+code;
            })
        })
    </script>
</head>
<body>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>字典类型列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" id="createDicTypeBtn"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button type="button" class="btn btn-default" id="editDicTypeBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteDicTypeBtn"><span class="glyphicon glyphicon-minus"
                                                           ></span> 删除
        </button>
    </div>
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox" id="checkedAll"/></td>
            <td>序号</td>
            <td>编码</td>
            <td>名称</td>
            <td>描述</td>
        </tr>
        </thead>
        <tbody id="tBody">

        <%--从request作用域中获取dicTypeList，遍历集合--%>
        <c:forEach items="${requestScope.dicTypeList}" var="dicType" varStatus="vs">
            <%--隔行换色--%>
            <c:if test="${vs.count%2 == 0}">
                <tr class="active">

            </c:if>
            <c:if test="${vs.count%2 != 0}">
                <tr style="background-color:yellowgreen">
            </c:if>
            <td><input type="checkbox" value="${dicType.code}" /></td>
            <td>${vs.count}</td>
            <td>${dicType.code}</td>
            <td>${dicType.name}</td>
            <td>${dicType.description}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>