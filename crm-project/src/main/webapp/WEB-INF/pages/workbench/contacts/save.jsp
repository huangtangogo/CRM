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
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript">
        $(function () {
            //使用日期插件
            $(".myDate").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd",
                initialDate: new Date(),
                minView: "month",
                autoclose: true,
                todayBtn: true,
                clearBtn: true
            });

            //给交易阶段添加改变事件
            $("#create-transactionStage").change(function () {
                //收集参数
                var stageValue = $("#create-transactionStage option:selected").text();
                //发送请求
                $.ajax({
                    url: "workbench/contacts/getPossibility.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        stageValue: stageValue,
                    },
                    success: function (data) {
                        //刷新列表
                        $("#create-possibility").val(data);
                    }
                });
            });

            //给客户名称输入框添加键盘弹起事件
            $("#create-accountName").keyup(function () {
                //先清空id值
                $("#customerId").val("");
                //创建一个对象用来设置客户的属性和id一一对应
                var temp = {};
                //使用自动补全插件
                $("#create-accountName").typeahead({
                    //指定数据源
                    source: function (query, process) {//query为用户输入的信息，process为函数，用来返回比对的数组
                        //发送请求
                        $.ajax({
                            url: "workbench/contacts/queryCustomerForDetailByName.do",
                            type: "post",
                            dataType: "json",
                            data: {
                                name: query,
                            },
                            success: function (data) {
                                //创建一个数组，因为匹对的数组中只有一个属性
                                var customerName = [];
                                //遍历结果
                                $.each(data, function (index, obj) {
                                    //数组使用push方法，避免index重复覆盖
                                    customerName.push(obj.name);
                                    temp[obj.name] = obj.id;
                                });
                                //使用回调函数
                                process(customerName);
                            }
                        });
                    },
                    //选中之后
                    afterSelect: function (item) {//item为选中的名称
                        //设值id到隐藏域中
                        $("#customerId").val(temp[item]);
                    }

                });
            });

            //给查找市场活动源图标添加单击事件
            $("#queryActivityBtn").click(function () {
                //清空搜索框内容
                $("#queryActivityByName").val("");
                //显示搜索市场活动的模态窗口
                $("#findMarketActivity").modal("show");
            });
            //给搜索市场活动的搜索框添加键盘弹起事件
            $("#queryActivityByName").keyup(function () {
                //收集参数
                var name = $.trim($("#queryActivityByName").val());
                //发送请求
                $.ajax({
                    url: "workbench/contacts/queryActivityForDetailByName.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        name: name
                    },
                    success: function (data) {
                        //拼接HTML代码
                        var htmlStr = "";
                        $.each(data, function () {
                            htmlStr += "<tr>";
                            htmlStr += "<td><input activityId=\"" + this.id + "\" type=\"radio\" name=\"activity\" value=\"" + this.name + "\"/></td>";//保证name一样，不然出现可以多选
                            htmlStr += "<td>" + this.name + "</td>";
                            htmlStr += "<td>" + this.startDate + "</td>";
                            htmlStr += "<td>" + this.endDate + "</td>";
                            htmlStr += "<td>" + this.owner + "</td>";
                            htmlStr += "</tr>";
                        });
                        //刷新列表
                        $("#activityBody").html(htmlStr);
                    }
                });
            });

            //给单选框添加单击事件，因为动态生成的元素，使用on函数
            $("#activityBody").on("click", "input[type='radio']", function () {
                //获取参数
                var name = $(this).attr("value");
                var activityId = $(this).attr("activityId");
                ;
                //id设置到隐藏域中
                $("#activityId").val(activityId)
                //name用于显示
                $("#create-activitySrc").val(name);
                //关闭模态窗口
                $("#findMarketActivity").modal("hide")
            });

            //给保存按钮添加单击事件
            $("#saveCreateTranBtn").click(function () {
                //收集参数
                var owner = $("#create-transactionOwner").val();
                var money = $.trim($("#create-amountOfMoney").val());
                var name = $.trim($("#create-transactionName").val());
                var expectedDate = $("#create-expectedClosingDate").val();
                var customerId = $("#customerId").val();
                var customerName = $.trim($("#create-accountName").val());
                var stage = $("#create-transactionStage").val();
                var possibility = $("#create-possibility").val();
                var type = $("#create-transactionType").val();
                var source = $("#create-clueSource").val();
                var activityId = $("#activityId").val();
                var contactsId = "${id}";
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();

                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (money != "") {
                    //金额只能是非负整数，使用正则表达式
                    var regExp = new RegExp("^(([1-9]\\d*)|0)$")
                    if (!regExp.test(money)) {
                        alert("金额只能是非负整数");
                        return;
                    }
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (expectedDate == "") {
                    alert("预计成交日期不能为空");
                    return;
                }
                if (customerName == "") {
                    alert("客户不能为空");
                    return;
                }
                if (stage == "") {
                    alert("阶段不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url: "workbench/contacts/saveCreateTran.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        owner: owner,
                        name: name,
                        money: money,
                        expectedDate: expectedDate,
                        customerId: customerId,
                        customerName: customerName,
                        stage: stage,
                        type: type,
                        possibility: possibility,
                        source: source,
                        activityId: activityId,
                        contactsId: contactsId,
                        description: description,
                        nextContactTime: nextContactTime,
                        contactSummary: contactSummary,
                    },
                    success: function (data) {
                        if(data.code == "0"){
                            alert(data.message);
                        }else{
                            //跳转页面
                            window.location.href="workbench/contacts/queryContactsForDetailById.do?id="+contactsId;
                        }
                    }
                });
            });
            //给取消按钮添加单击事件
            $("#cancelBtn").click(function(){
                //页面跳转，同步请求
                var id = '${id}';
                window.location.href="workbench/contacts/queryContactsForDetailById.do?id="+id;
            })
        });
    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="queryActivityByName" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activityBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    <%--<tr>
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

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="queryContactsByName" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="saveCreateTranBtn" type="button" class="btn btn-primary">保存</button>
        <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner">
                <option></option>
                <c:forEach items="${userList}" var="user">
                    <option value="${user.id}">${user.name}</option>
                </c:forEach>
                <%-- <option>zhangsan</option>
                 <option>lisi</option>
                 <option>wangwu</option>--%>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="create-expectedClosingDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <%--隐藏域，保存客户id--%>
            <input id="customerId" type="hidden"/>
            <input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage">
                <option></option>
                <c:forEach items="${stages}" var="stage">
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
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType">
                <option></option>
                <c:forEach items="${types}" var="type">
                    <option value="${type.id}">${type.value}</option>
                </c:forEach>
                <%-- <option>已有业务</option>
                 <option>新业务</option>--%>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource">
                <option></option>
                <c:forEach items="${sources}" var="source">
                    <option value="${source.id}">${source.value}</option>
                </c:forEach>
                <%-- <option>广告</option>
                 <option>推销电话</option>
                 <option>员工介绍</option>
                 <option>外部介绍</option>
                 <option>在线商场</option>
                 <option>合作伙伴</option>
                 <option>公开媒介</option>
                 <option>销售邮件</option>
                 <option>合作伙伴研讨会</option>
                 <option>内部研讨会</option>
                 <option>交易会</option>
                 <option>web下载</option>
                 <option>web调研</option>
                 <option>聊天</option>--%>
            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a id="queryActivityBtn"
                                                                                           href="javascript:void(0);"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <%--隐藏域，保存市场活动id--%>
            <input id="activityId" type="hidden"/>
            <input type="text" class="form-control" id="create-activitySrc" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a id="queryContactsBtn"
                                                                                            href="javascript:void(0);"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsName" value="${fullName}" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>