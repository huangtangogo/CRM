<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js" ></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript">
        $(function() {
            //页面加载完毕执行
            var owner = '${tran.owner}';
            var stage = '${tran.stage}';
            var type = '${tran.type}';
            var source = '${tran.source}';
            //根据id一致就可以自动设置为默认值
            $("#edit-transactionOwner").val(owner);
            $("#edit-transactionStage").val(stage);
            $("#edit-transactionType").val(type);
            $("#edit-clueSource").val(source);

            //使用日期插件
            $(".myDate").datetimepicker({
               language:"zh-CN",
               format:"yyyy-mm-dd",
               initialDate:new Date(),
               minView:"month",
               autoclose:true,
               todayBtn:true,
               clearBtn:true,
            });

            //给交易阶段添加改变事件函数
            $("#edit-transactionStage").change(function(){
                //收集参数
                var stageValue = $("#edit-transactionStage option:selected").text();
                //alert(stageValue);
                //发送请求
                $.ajax({
                    url:"workbench/transaction/getPossibilityOfEditByStageValue.do",
                    type:"post",
                    dataType:"json",
                    data:{
                        stageValue:stageValue,
                    },
                    success:function(data){
                        //刷新数据
                        $("#edit-possibility").val(data);
                    }
                });
            });

            //给客户输入框添加键盘弹起事件
            $("#edit-customerName").keyup(function(){
                //收集参数
                //var name = $.trim($("#edit-customerName").val());不用自己收集，自己收集不准确
                //alert(name);
                //创建一个对象保存属性用来保存id值
                var temp = {};
                //使用自动补全插件
                $("#edit-customerName").typeahead({
                    minLength: 1,//键入字数多少开始查询补全
                    showHintOnFocus: "true",//将显示所有匹配项
                    fitToElement: true,//选项框宽度与输入框一致
                    items: 8,//下拉数量
                    delay: 500,//延迟时间
                   source:function(query,process){//指定数据源，query为用户输入的数据，process为方法参数，返回数组给source
                       //发送ajax请求
                       $.ajax({
                           url:"workbench/transaction/queryCustomerByName.do",
                           type:"post",
                           dataType:"json",
                           data:{
                               name:query,//这里经常搞错
                           },
                           success:function(data){
                               //匹对时需要一个数组，而返回的是一个数组的json对象，需要再次封装成匹对的数组，只有name数字属性
                               var customerName = [];
                               //遍历数组
                               $.each(data,function(index,obj){
                                   customerName.push(obj.name);//往数组中添加元素，push可以不用考虑index
                                   temp[obj.name] = obj.id;//给对象属性赋值，name属性名称都不同，id也不同
                               });
                               //执行回调函数
                               process(customerName);
                           },
                       })
                   },
                    afterSelect(item){//当选择数据之后，item为选中的名称
                        //赋值到隐藏域
                        $("#customerId").val(temp[item]);
                    }
                });
            });

            //给查询市场活动源图标添加单击事件
            $("#queryActivityBtn").click(function(){
                //先清空搜索框中内容
                $("#queryActivityByName").val("");
                //显示查询市场活动的模态窗口
                $("#findMarketActivity").modal("show");
            });
            //给市场活动搜索框添加键盘弹起事件
            $("#queryActivityByName").keyup(function(){
                //收集参数
                var name = $.trim($("#queryActivityByName").val());

                //发送请求
                $.ajax({
                    url:"workbench/transaction/queryActivityForDetailByName.do",
                    type:"post",
                    dataType:"json",
                    data:{
                        name:name
                    },
                    success:function(data){
                        var htmlStr = "";
                        //遍历数组,拼接HTML代码
                        $.each(data,function(){
                            htmlStr+="<tr>";
                            htmlStr+="<td><input type=\"radio\" activityId=\""+this.id+"\" name=\"activity\" value=\""+this.name+"\"/></td>";
                            htmlStr+="<td>"+this.name+"</td>";
                            htmlStr+="<td>"+this.startDate+"</td>";
                            htmlStr+=" <td>"+this.endDate+"</td>";
                            htmlStr+="<td>"+this.owner+"</td>";
                            htmlStr+="</tr>";
                        });
                        //刷新列表
                        $("#activityBody").html(htmlStr);
                    }
                });

            });
            //给选择市场活动添加单击事件,因为是动态生成的数据，使用on函数
            $("#activityBody").on("click"," input[type='radio']",function(){
               //收集参数
               var name = $("#activityBody input[type='radio']:checked").attr("value");
               var activityId = $("#activityBody input[type='radio']:checked").attr("activityId");
               //设值到页面中，name用于显示，id用于保存
                $("#activityId").val(activityId);
                $("#edit-activitySrc").val(name);
                //关闭模态窗口
                $("#findMarketActivity").modal("hide");
            });

            //给查找联系人图标添加单击事件
            $("#queryContactsBtn").click(function(){
                //清空搜索框
                $("#queryContactsByName").val("");
                //显示查找联系人的模态窗口
                $("#findContacts").modal("show");
            });
            //给搜索框添加键盘弹起事件
            $("#queryContactsByName").keyup(function(){
                //收集参数
                var name = $.trim($("#queryContactsByName").val());
                //发送请求
                $.ajax({
                    url:"workbench/transaction/queryContactsForDetailByName.do",
                    type:"post",
                    dataType:"json",
                    data:{
                        name:name
                    },
                    success:function(data){
                        var htmlStr = "";
                        //遍历数组
                        $.each(data,function(){
                            htmlStr+="<tr>";
                            htmlStr+="<td><input contactsId=\""+this.id+"\" type=\"radio\" name=\"activity\" value=\""+this.fullName+"\"/></td>";
                            htmlStr+="<td>"+this.fullName+"</td>";
                            htmlStr+="<td>"+this.email+"</td>";
                            htmlStr+="<td>"+this.mphone+"</td>";
                            htmlStr+="</tr>";
                        });
                        //刷新列表
                        $("#contactsBody").html(htmlStr);
                    }
                });
            });
            //用户选择联系人,使用on函数
            $("#contactsBody").on("click","input",function(){
                //收集参数
                var contactsId = $("#contactsBody input[type='radio']:checked").attr("contactsId");
                var fullName = $("#contactsBody input[type='radio']:checked").attr("value");
                //显示name，隐藏id
                $("#contactsId").val(contactsId);
                $("#edit-contactsName").val(fullName);
                //隐藏模态窗口
                $("#findContacts").modal("hide");
            });

            //给更新按钮添加单击事件
            $("#saveEditTranBtn").click(function(){
                //收集参数
                var id = '${tran.id}';
                var owner = $("#edit-transactionOwner").val();
                var money = $.trim($("#edit-amountOfMoney").val());
                var name = $.trim($("#edit-transactionName").val());
                var expectedDate = $("#edit-expectedClosingDate").val();
                var stage = $("#edit-transactionStage").val();
                var possibility = $("#edit-possibility").val();
                var type = $("#edit-transactionType").val();
                var source = $("#edit-clueSource").val();
                var activityId = $("#activityId").val();
                var contactsId = $("#contactsId").val();
                var description = $.trim($("#edit-description").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();

                //表单验证
                if(owner == ""){
                    alert("所有者不能为空");
                    return;
                }
                if(money != ""){
                    //金额只能是非负整数，使用正则表达式
                    var regExp = new RegExp("^(([1-9]\\d*)|0)$")
                    if(!regExp.test(money)){
                        alert("金额只能是非负整数");
                        return;
                    }
                }
                if(name == ""){
                    alert("名称不能为空");
                    return;
                }
                if(expectedDate == ""){
                    alert("预计成交日期不能为空");
                    return;
                }
                if(stage == ""){
                    alert("阶段不能为空");
                    return;
                }

                //发送请求
                $.ajax({
                    url:"workbench/transaction/saveEditTran.do",
                    dataType:"json",
                    type:"post",
                    data:{
                        id:id,
                        owner:owner,
                        name:name,
                        money:money,
                        expectedDate:expectedDate,

                        stage:stage,
                        type:type,
                        possibility:possibility,
                        source:source,
                        activityId:activityId,
                        contactsId:contactsId,
                        description:description,
                        nextContactTime:nextContactTime,
                        contactSummary:contactSummary,
                    },
                    success:function(data){
                        if(data.code=="0"){
                            alert(data.message);
                        }else{
                            window.location.href="workbench/transaction/index.do";
                        }
                    }
                })
            });
            //给取消按钮添加单击事件
            $("#cancelBtn").click(function(){
                //返回首页
                window.location.href="workbench/transaction/index.do";
            });
        })
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
                            <input id="queryActivityByName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
                            <input id="queryContactsByName" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
    <h3>修改交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="saveEditTranBtn" type="button" class="btn btn-primary">更新</button>
        <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-transactionOwner">
                <option></option>
                <c:forEach items="${userList}" var="user">
                    <option value="${user.id}">${user.name}</option>
                </c:forEach>
                <%-- <option>zhangsan</option>
                 <option>lisi</option>
                 <option>wangwu</option>--%>
            </select>
        </div>
        <label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-amountOfMoney" value="${tran.money}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-transactionName" value="${tran.name}">
        </div>
        <label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="edit-expectedClosingDate" readonly value="${tran.expectedDate}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <%--隐藏域，保存客户id,其实不用了，不符合逻辑，客户写死--%>
            <input id="customerId" type="hidden" value="${tran.customerId}"/>
            <input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="${tran.orderNo}" readonly>
        </div>
        <label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-transactionStage" >
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
    </div>

    <div class="form-group">
        <label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-transactionType">
                <option></option>
                <c:forEach items="${transactionTypeList}" var="transaction">
                    <option value="${transaction.id}">${transaction.value}</option>
                </c:forEach>
                <%-- <option>已有业务</option>
                 <option>新业务</option>--%>
            </select>
        </div>
        <label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-possibility" readonly value="${tran.possibility}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-clueSource">
                <option></option>
                <c:forEach items="${sourceList}" var="source">
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
        <label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a id="queryActivityBtn" href="javascript:void(0);"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <%--隐藏域，保存市场活动id--%>
            <input id="activityId" type="hidden"/>
            <input type="text" class="form-control" id="edit-activitySrc" readonly value="${tran.activityId}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a id="queryContactsBtn" href="javascript:void(0);" ><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <%--隐藏域，保存联系人id--%>
            <input id="contactsId" type="hidden"/>
            <input type="text" class="form-control" id="edit-contactsName" readonly value="${tran.contactsId}">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-description" >${tran.description}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-contactSummary" >${tran.contactSummary}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="edit-nextContactTime" readonly value="${tran.nextContactTime}">
        </div>
    </div>

</form>
</body>
</html>