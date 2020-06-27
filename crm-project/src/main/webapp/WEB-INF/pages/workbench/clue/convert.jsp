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


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });
            //使用日期插件
            $(".myDate").datetimepicker({
                language:"zh-CN",
                format:"yyyy-dd-mm",
                minView:"month",
                autoclose:true,
                initialDate:new Date(),
                todayBtn:true,
                clearBtn:true,
            });

            //给查询市场活动添加单击事件
            $("#searchActivityBtn").click(function () {
                //重置表单,使用dom对象的重置reset方法，只对表单有用
                //这里没必要清空，因为又不是多选，全显示出来多好，清空搜索框就好了
                $("#searchName").val("");
                //显示搜索市场活动的模态窗口
                $("#searchActivityModal").modal("show");
            });

            //给搜索市场活动搜索框添加键盘弹起事件
            $("#searchName").keyup(function () {
                //收集参数
                var name = $.trim($("#searchName").val());
                //发送请求
                $.ajax({
                    url: "workbench/clue/queryActivityForDetailByName.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        name: name
                    },
                    success: function (data) {
                        //刷新列表
                        var htmlStr = "";
                        $.each(data, function (index, obj) {
                            htmlStr += "<tr>";
                            htmlStr += "<td><input activityId=\"" + obj.id + "\" type=\"radio\" name=\"activity\" value=\"" + obj.name + "\"/></td>";
                            htmlStr += "<td>" + obj.name + "</td>";
                            htmlStr += "<td>" + obj.startDate + "</td>";
                            htmlStr += "<td>" + obj.endDate + "</td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "</tr>";
                        });
                        $("#searchActivityBody").html(htmlStr);
                    }
                });
            });

            //给用户单选按钮添加单击事件,因为是动态生成的元素，使用on函数
            $("#searchActivityBody").on("click", "input[type='radio']", function () {
                //收集参数,也可以使用this，表示当前dom对象
                var name = $(this).val();
                var id = $(this).attr("activityId")

                //设值
                $("#activityName").val(name);
                $("#activityId").val(id);

                //关闭模态窗口
                $("#searchActivityModal").modal("hide");
            });

            //给线索“转换”按钮添加单击事件
            $("#saveConvertBtn").click(function () {
                //收集参数
                var clueId = '${clue.id}';
                var isCreateTran = $("#isCreateTransaction").prop("checked");
                var money = $.trim($("#amountOfMoney").val());
                var name = $.trim($("#tradeName").val());
                var expectedDate = $("#expectedClosingDate").val();
                var stage = $("#stage").val();
                var activityId = $("#activityId").val();
                if (isCreateTran) {
                    //表单验证
                    //1.交易名称不能为空
                    if (name == "") {
                        alert("交易名称不能为空");
                        return;
                    }
                    //2.预计成交日期不能为空
                    if (expectedDate == "") {
                        alert("预计成交日期不能为空");
                        return;
                    }
                    //3.阶段不能为空
                    if (stage == "") {
                        alert("阶段不能为空");
                        return;
                    }
                    //4.当金额不为空的时，使用正则表达式验证金额，必须是非负整数
                    if (money != "") {
                        var regExp = /^(([1-9]\d*)|0)$/;
                        if (!regExp.test(money)) {
                            alert("金额只能是非负整数");
                            return;
                        }
                    }
                }
                //发送请求
                $.ajax({
                    url: "workbench/clue/saveClueConvert.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        clueId:clueId,
                        isCreateTran:isCreateTran,
                        money:money,
                        name:name,
                        expectedDate:expectedDate,
                        stage:stage,
                        activityId:activityId,
                    },
                    success:function(data){
                        if(data.code == "1"){
                            window.location.href="workbench/clue/index.do";
                        }else{
                            alert(data.message);
                        }
                    }
                });
            });
        });
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="searchName" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="searchActivityBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${clue.fullName}${clue.appellation}-${clue.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${clue.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${clue.fullName}${clue.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form>
        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control myDate" id="expectedClosingDate" readonly>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control">
                <option></option>
                <c:forEach items="${stageList}" var="stage">
                    <option value="${stage.id}">${stage.value}</option>
                </c:forEach>
                <%--<option>资质审查</option>
                <option>需求分析</option>
                <option>价值建议</option>
                <option>确定决策者</option>
                <option>提案/报价</option>
                <option>谈判/复审</option>
                <option>成交</option>
                <option>丢失的线索</option>
                <option>因竞争丢失关闭</option>--%>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activityName">市场活动源&nbsp;&nbsp;<a id="searchActivityBtn" href="javascript:void(0);"
                                                          style="text-decoration: none;"><span
                    class="glyphicon glyphicon-search"></span></a></label>
            <%--设置隐藏域，保存市场活动的id--%>
            <input type="hidden" id="activityId"/>
            <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${clue.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input id="saveConvertBtn" class="btn btn-primary" type="button" value="转换">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>