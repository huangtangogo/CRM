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
    <link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">

        $(function () {
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });
            //使用日历插件
            $(".myDate").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd",
                initialDate: new Date(),
                minView: "month",
                todayBtn: true,
                clearBtn: true,
                autoclose: true,

            });

            //给联系人“创建”按钮添加单击事件
            $("#createContactsBtn").click(function () {
                //在显示创建联系人模态窗口之前清空模态窗口信息
                $("#createContactForm")[0].reset();
                //显示模态窗口
                $("#createContactsModal").modal("show");
            });

            //给客户名称输入框添加键盘弹起事件
            $("#create-customerName").keyup(function () {
                //收集参数
                var name = $("#create-customerName").val();
                var objMap = {};
                //使用自动补全插件
                $("#create-customerName").typeahead({
                    minLength: 0,//键入字数多少开始查询补全
                    showHintOnFocus: "true",//将显示所有匹配项
                    fitToElement: true,//选项框宽度与输入框一致
                    items: 8,//下拉数量
                    delay: 500,//延迟时间
                    source: function (query, process) {//指定数据源，query代表输入框中你的输入值（即查询值）,process回调函数
                        //发送请求
                        $.ajax({
                            url: "workbench/contacts/queryCustomerForDetailByName.do",
                            type: "post",
                            dataType: "json",
                            data: {
                                name: name
                            },
                            success: function (data) {
                                //遍历结果
                                var customer = [];
                                $.each(data, function (index, obj) {
                                    objMap[obj.name] = obj.id;
                                    customer.push(obj.name);//添加到数组中
                                });
                                process(customer);
                            },
                        });
                    },
                    afterSelect: function (item) {//选中一条数据后的回调函数，此处可以向隐藏域赋值数据id
                        //console.log(objMap[item]);//取出选中项的值,打印到控制台
                        $("#create-customerId").val(objMap[item]);
                    }
                });
            });

            //给保存联系人按钮添加单击事件
            $("#saveCreateContactsBtn").click(function () {
                //收集参数
                var owner = $("#create-contactsOwner").val();
                var source = $("#create-clueSource").val();
                var customerId = $("#create-customerId").val();
                var fullName = $.trim($("#create-surname").val());
                var customerName = $.trim($("#create-customerName").val());
                var appellation = $("#create-call").val();
                var email = $.trim($("#create-email").val());
                var mphone = $.trim($("#create-mphone").val());
                var job = $.trim($("#create-job").val());
                var birth = $("#create-birth").val();
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (fullName == "") {
                    alert("姓名不能为空");
                    return;
                }
                //如果手机号码不为空
                if (mphone != "") {
                    //使用正则表达式验证字符串
                    var regExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
                    if (!regExp.test(mphone)) {
                        alert("请输入正确格式的手机号码");
                        return;
                    }
                }
                //如果邮箱不为空
                if (email != "") {
                    //使用正则表达式验证字符串
                    var regExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                    if (!regExp.test(email)) {
                        alert("请输入正确格式的邮箱地址");
                        return;
                    }
                }
                //发送请求
                $.ajax({
                    url: "workbench/contacts/saveCreateContact.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        owner: owner,
                        source: source,
                        customerId: customerId,
                        fullName: fullName,
                        customerName: customerName,
                        appellation: appellation,
                        email: email,
                        job: job,
                        mphone: mphone,
                        birth: birth,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    success: function (data) {
                        if (data.code == "1") {
                            //保存成功，隐藏创建联系人的模态窗口
                            $("#createContactsModal").modal("hide");
                            //alert("保存成功");
                            //显示首页，每页显示条数不变
                            queryContactsForPageByCondition(1,$("#contactsPage").bs_pagination("getOption","rowsPerPage"));
                        } else {
                            alert(data.message);
                            //显示创建联系人的模态窗口
                            $("#createContactsModal").modal("show");
                        }
                    }
                });
            });

            //页面加载完毕时，显示首页，每页显示10条记录
            queryContactsForPageByCondition(1, 10);
            //给查询按钮添加单击事件
            $("#queryContactsBtn").click(function () {
                //显示首页，每页显示记录条数不变
                queryContactsForPageByCondition(1, $("#contactsPage").bs_pagination("getOption", "rowsPerPage"));
            });

            //给联系人名称超链接添加单击事件,使用on函数
            $("#contactsBody").on("click", "a", function () {
                //收集参数
                var id = $(this).attr("contactsId");
                //发送同步请求
                window.location.href = "workbench/contacts/queryContactsForDetailById.do?id=" + id;
            });

            //全选和取消全选
            //给全选按钮添加单击事件
            $("#checkAll").click(function () {
                //将所有的子选择按钮的状态和全选按钮的状态保持一致
                $("#contactsBody input[type='checkbox']").prop("checked", $("#checkAll").prop("checked"));
            });
            //给所有的子选择按钮添加单击事件,使用on函数
            $("#contactsBody").on("click", "input[type='checkbox']", function () {
                //判断所有子选择dom对象的数组长度和所有已选择的dom对象的数组长度，决定全选按钮的状态
                if ($("#contactsBody input[type='checkbox']").size() == $("#contactsBody input[type='checkbox']:checked").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });

            //给删除按钮添加单击事件
            $("#deleteContactsBtn").click(function () {
                //收集参数
                var checkIds = $("#contactsBody input[type='checkbox']:checked");
                //表单验证
                if (checkIds.size() == 0) {
                    alert("请选择要删除的联系人");
                    return;
                }
                //遍历数组
                var idStr = "";
                $.each(checkIds, function () {
                    idStr += "id=" + this.value + "&";
                });
                //去掉最后一个&
                idStr = idStr.substr(0, idStr.length - 1);
                //提示是否删除
                if (window.confirm("确定删除联系人吗？")) {
                    //发送请求
                    $.ajax({
                        url: "workbench/contacts/deleteContactsByIds.do",
                        type: "post",
                        dataType: "json",
                        data: idStr,
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else {
                               //显示首页，每页显示条数不变
                                queryContactsForPageByCondition(1,$("#contactsPage").bs_pagination("getOption","rowsPerPage"));
                            }
                        }
                    });
                }
            });

            //给修改按钮添加单击事件
            $("#editContactsBtn").click(function(){
                //收集参数
                var checkIds = $("#contactsBody input[type='checkbox']:checked");
                //表单验证
                if(checkIds.size()>1){
                    alert("每次只能选择修改一条记录");
                    return;
                }
                if(checkIds.size()==0){
                    alert("请选择要修改的记录");
                    return;
                }
                var id = checkIds[0].value;
                //发送请求
                $.ajax({
                    url:"workbench/contacts/queryContactsById.do",
                    type:"post",
                    dataType:"json",
                    data:{
                        id:id
                    },
                    success:function(data){
                        //刷新列表，设值到form中
                        $("#contactsId").val(data.id);
                        $("#edit-contactsOwner").val(data.owner);
                        $("#edit-clueSource1").val(data.source);
                        $("#edit-fullName").val(data.fullName);
                        $("#edit-call").val(data.appellation);
                        $("#edit-job").val(data.job);
                        $("#edit-mphone").val(data.mphone);
                        $("#edit-email").val(data.email);
                        $("#edit-birth").val(data.birth);
                        $("#edit-customerId").val(data.customerId);
                        $("#edit-customerName").val(data.createBy);
                        $("#edit-description").val(data.description);
                        $("#edit-contactSummary").val(data.contactSummary);
                        $("#edit-nextContactTime").val(data.nextContactTime);
                        $("#edit-address").val(data.address);
                        //显示修改备注的模态窗口
                        $("#editContactsModal").modal("show");
                    }
                });

            });
            //给修改客户输入框添加键盘弹起事件
            $("#edit-customerName").keyup(function(){
                //创建对象，用来存储唯一的id值
                var temp = {};
                //使用自动补全插件
                $("#edit-customerName").typeahead({
                    source: function (query, process) {//指定数据源，query为用户输入的名称，process为回调函数，用来匹对数组使用
                       //发送请求
                       $.ajax({
                          url:"workbench/contacts/queryCustomerForDetailByName.do",
                           type:"post",
                           dataType:"json",
                           data:{
                              name:query,
                           },
                           success:function(data){
                              //将data对象转变成jquery对象
                              //alert(contacts.size());
                              if($(data).size()== 0){
                                  //清空客户id
                                  $("#edit-customerId").val("");
                              }else{
                                  //创建用来匹对的数组
                                  var customerName = [];
                                  //遍历数组
                                  $.each(data,function(index,obj){
                                      customerName.push(obj.name);
                                      //给对象声明属性name+赋值id
                                      temp[obj.name] = obj.id;
                                  });
                                  //使用回调函数
                                  process(customerName);
                                  //alert(666);
                              }
                           }
                       });
                   },
                    afterSelect:function(item){//用户选择的名称
                       //设置隐藏域的id
                        $("#edit-customerId").val(temp[item]);
                    }
                });
            });
            
            //给更新按钮添加单击事件
            $("#saveEditContactsBtn").click(function(){
                //收集参数
                var id = $("#contactsId").val()
                var owner = $("#edit-contactsOwner").val();
                var source = $("#edit-clueSource1").val();
                var customerId = $("#edit-customerId").val();
                var fullName = $.trim($("#edit-fullName").val());
                var customerName = $.trim($("#edit-customerName").val());
                var appellation = $("#edit-call").val();
                var email = $.trim($("#edit-email").val());
                var mphone = $.trim($("#edit-mphone").val());
                var job = $.trim($("#edit-job").val());
                var birth = $("#edit-birth").val();
                var description = $.trim($("#edit-description").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $.trim($("#edit-address").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (fullName == "") {
                    alert("姓名不能为空");
                    return;
                }
                //如果手机号码不为空
                if (mphone != "") {
                    //使用正则表达式验证字符串
                    var regExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
                    if (!regExp.test(mphone)) {
                        alert("请输入正确格式的手机号码");
                        return;
                    }
                }
                //如果邮箱不为空
                if (email != "") {
                    //使用正则表达式验证字符串
                    var regExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                    if (!regExp.test(email)) {
                        alert("请输入正确格式的邮箱地址");
                        return;
                    }
                }
                //发送请求
                $.ajax({
                    url: "workbench/contacts/updateContacts.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id:id,
                        owner: owner,
                        source: source,
                        customerId: customerId,
                        fullName: fullName,
                        customerName: customerName,
                        appellation: appellation,
                        email: email,
                        job: job,
                        mphone: mphone,
                        birth: birth,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    success: function (data) {
                        if (data.code == "1") {
                            //保存成功，隐藏创建联系人的模态窗口
                            $("#editContactsModal").modal("hide");
                           //显示当前页为修改之前的页面，每页显示记录条数不变
                            queryContactsForPageByCondition($("#contactsPage").bs_pagination("getOption","currentPage"),$("#contactsPage").bs_pagination("getOption","rowsPerPage"));
                        } else {
                            alert(data.message);
                            //显示创建联系人的模态窗口
                            $("#editContactsModal").modal("show");
                        }
                    }
                });
            });

        });

        //声明查询函数
        function queryContactsForPageByCondition(pageNo, pageSize) {
            //换页则取消全选
            $("#checkAll").prop("checked", false);
            //收集参数owner,fullName,customerName,source,birth,
            var owner = $.trim($("#queryContactsByOwner").val());
            var fullName = $.trim($("#queryContactsByFullName").val());
            var customerName = $.trim($("#queryContactsByCustomerName").val());
            var source = $("#queryContactsBySource").val();
            var birth = $("#queryContactsByBirth").val();
            //发送请求
            $.ajax({
                url: "workbench/contacts/queryContactsForPage.do",
                type: "post",
                dataType: "json",
                data: {
                    pageNo: pageNo,
                    pageSize: pageSize,
                    owner: owner,
                    fullName: fullName,
                    customerName: customerName,
                    source: source,
                    birth: birth
                },
                success: function (data) {
                    var htmlStr = "";
                    //遍历数组
                    $.each(data.contactsList, function (index, obj) {
                        //拼接HTML代码
                        //隔行换色
                        if (index % 2 == 0) {
                            htmlStr += "<tr>";
                        } else {
                            htmlStr += "<tr class=\"active\">";
                        }
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                        htmlStr += "<td><a contactsId=\"" + obj.id + "\" style=\"text-decoration: none; cursor: pointer;\"";
                        htmlStr += ">" + obj.fullName + "</a></td>";
                        htmlStr += "<td>" + obj.customerId + "</td>";
                        htmlStr += "<td>" + obj.owner + "</td>";
                        htmlStr += "<td>" + obj.source + "</td>";
                        htmlStr += "<td>" + obj.birth + "</td>";
                        htmlStr += "</tr>";
                    });
                    //刷新列表
                    $("#contactsBody").html(htmlStr);
                    //计算总页数
                    var totalPages = 0;
                    if (data.totalRows % pageSize == 0) {
                        totalPages = data.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(data.totalRows / pageSize) + 1;
                    }
                    //因为分页依赖于查询结果，所以在这里使用插件进行分页
                    $("#contactsPage").bs_pagination({
                        currentPage: pageNo,
                        rowsPerPage: pageSize,
                        totalRows: data.totalRows,
                        totalPages: totalPages,
                        visiblePageLinks: 5,
                        showGotoPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        onChangePage: function (e, pageObj) {
                            queryContactsForPageByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    })
                }
            });
        }
    </script>
</head>
<body>


<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form id="createContactForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-contactsOwner">
                                <option></option>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                                <%-- <option>zhangsan</option>
                                 <option>lisi</option>
                                 <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueSource">
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
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                                <%-- <option>先生</option>
                                 <option>夫人</option>
                                 <option>女士</option>
                                 <option>博士</option>
                                 <option>教授</option>--%>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control " id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--设计一个隐藏域，用来保存客户id--%>
                            <input type="hidden" id="create-customerId"/>
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveCreateContactsBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
    <%--这个div用于显示完整的时间窗口--%>
    <div style="height: 100px"></div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--设置隐藏域保存联系人id--%>
                            <input type="hidden" id="contactsId"/>
                            <select class="form-control" id="edit-contactsOwner">
                                <option></option>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                                <%--<option selected>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueSource1">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                               <%-- <option selected>广告</option>
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
                    </div>

                    <div class="form-group">
                        <label for="edit-fullName" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullName">
                        </div>
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                                <%--<option selected>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>--%>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--设置隐藏域--%>
                            <input  type="hidden" id="edit-customerId"/>
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveEditContactsBtn" type="button" class="btn btn-primary" >更新</button>
            </div>
        </div>
    </div>
    <%--这个div用于显示完整的时间窗口--%>
    <div style="height: 100px"></div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="queryContactsByOwner" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">姓名</div>
                        <input id="queryContactsByFullName" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input id="queryContactsByCustomerName" class="form-control" type="text">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="queryContactsBySource">
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
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">生日</div>
                        <input id="queryContactsByBirth" class="form-control myDate" type="text" readonly>
                    </div>
                </div>

                <button id="queryContactsBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createContactsBtn" type="button" class="btn btn-primary">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editContactsBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteContactsBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="checkAll" type="checkbox"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>生日</td>
                </tr>
                </thead>
                <tbody id="contactsBody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">李四</a></td>
                    <td>动力节点</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>2000-10-10</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">李四</a></td>
                    <td>动力节点</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>2000-10-10</td>
                </tr>--%>
                </tbody>
            </table>
            <div id="contactsPage"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 10px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>--%>

    </div>

</div>
</body>
</html>