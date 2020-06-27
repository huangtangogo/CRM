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
            //给创建按钮添加单击事件
            $("#createDicValueBtn").click(function () {
                //页面跳转，使用地址栏的方式
                window.location.href = "settings/dictionary/value/toSave.do";
            });

            //全选和取消全选设置
            //全选按钮添加单击事件
            $("#checkAll").click(function () {
                //tbody中的checkbox和全选的checkbox状态保持一致
                $("#tBody input[type='checkbox']").prop("checked", $("#checkAll").prop("checked"));
            });
            //子按钮全部添加单击事件
            $("#tBody input[type='checkbox']").click(function () {
                //判断所有满足条件的选择按钮的dom对象数组长度和所有满足条件并已勾选的选择按钮的dom对象数组长度
                if ($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()) {
                    //长度一样说明全选
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });

            //给删除按钮添加单击事件
            $("#deleteDicValueBtn").click(function () {
                //收集参数
                var checkId = $("#tBody input[type='checkbox']:checked");//已选择，是一个dom对象数组
                //表单验证
                if (checkId.size() == 0) {
                    alert("每次至少删除一条记录");
                    return;
                }
                //遍历数组，取出dom对象中的值，拼接成控制器需要的参数id=xxx&id=xxx...
                var idStr = ""
                $.each(checkId, function () {
                    idStr += "id=" + this.value + "&";
                });

                //去掉最后多余的"&"
                idStr = idStr.substr(0, idStr.length - 1);

                //用户确认是否删除
                if (window.confirm("确认删除吗？")) {
                    //发送ajax请求
                    $.ajax({
                        url: "settings/dictionary/value/deleteDicValueByIds.do",
                        type: "post",
                        dataType: "json",
                        data: idStr,
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else {
                                window.location.href = "settings/dictionary/value/index.do";
                            }
                        }
                    })
                }
            })

            //给编辑按钮添加单击事件
            $("#editDicValueBtn").click(function () {
                //收集选中的checkbox
                var editCheck = $("#tBody input[type='checkbox']:checked");
                if (editCheck.size() == 0) {
                    alert("请选择要修改的记录");
                    return;
                }
                if (editCheck.size() > 1) {
                    alert("一次只能选择编辑一条记录");
                    return;
                }
                var id = editCheck[0].value;
                //发送同步请求
                window.location.href = "settings/dictionary/value/editDicValue.do?id=" + id;
            })
        })
    </script>
</head>
<body>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>字典值列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" id="createDicValueBtn"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button type="button" class="btn btn-default" id="editDicValueBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteDicValueBtn"><span
                class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox" id="checkAll"/></td>
            <td>序号</td>
            <td>字典值</td>
            <td>文本</td>
            <td>排序号</td>
            <td>字典类型编码</td>
        </tr>
        </thead>
        <tbody id="tBody">
        <c:forEach items="${dicValueList}" var="dv" varStatus="vs">
            <c:if test="${vs.count%2 == 0}">
                <tr class="active">
            </c:if>
            <c:if test="${vs.count%2 != 0}">
                <tr style="background-color:yellowgreen">
            </c:if>
            <td><input type="checkbox" value="${dv.id}"/></td>
            <td>${vs.count}</td>
            <td>${dv.value}</td>
            <td>${dv.text}</td>
            <td>${dv.orderNo}</td>
            <td>${dv.typeCode}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>