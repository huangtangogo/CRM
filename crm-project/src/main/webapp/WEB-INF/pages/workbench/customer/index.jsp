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
                minView: "month",
                format: "yyyy-mm-dd",
                initialDate: new Date(),
                autoclose: true,
                todayBtn: true,
                clearBtn: true,
            });

            //给创建客户“创建”按钮添加单击事件
            $("#createCustomerBtn").click(function () {
                //显示模态窗口之前，先清除上次表单中的内容，使用dom对象的reset方法
                $("#createCustomerForm").get(0).reset();
                //显示模态窗口
                $("#createCustomerModal").modal("show");
            });
            //给创建客户“保存”按钮添加单击事件
            $("#saveCreateCustomerBtn").click(function () {
                //收集参数
                var owner = $("#create-customerOwner").val();
                var name = $.trim($("#create-customerName").val());
                var website = $.trim($("#create-website").val());
                var phone = $.trim($("#create-phone").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $.trim($("#create-nextContactTime").val());
                var description = $.trim($("#create-description").val());
                var address = $.trim($("#create-address1").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (website != "") {
                    var regExp = /^([a-zA-z]+:\/\/[^\s]*)|(http:\/\/([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?)$/;
                    if (!regExp.test(website)) {
                        alert("请输入格式正确的网站");
                        return;
                    }
                }
                if (phone != "") {
                    var regExp = /^(\d{3,4}-?\d{7,8})$/;
                    if (!regExp.test(phone)) {
                        alert("请输入格式正确的座机号码");
                        return;
                    }
                }
                //发送请求
                $.ajax({
                    url: "workbench/customer/saveCreateCustomer.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        owner: owner,
                        name: name,
                        website: website,
                        phone: phone,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        description: description,
                        address: address
                    },
                    success: function (data) {
                        if (data.code == "1") {
                            //关闭模态窗口
                            $("#createCustomerModal").modal("hide");
                            //刷新列表
                            queryCustomerByCondition(1, $("#customerPage").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            alert(data.message);
                            //显示模态窗口
                            $("#createCustomerModal").modal("show");
                        }
                    }
                });
            });

            //页面加载时查询，默认第一页为当前页，每页显示10条记录
            queryCustomerByCondition(1, 10);
            //给用户“查询”按钮添加单击事件
            $("#queryCustomerBtn").click(function () {
                queryCustomerByCondition(1, $("#customerPage").bs_pagination("getOption", "rowsPerPage"));
            });

            //设置全选和取消全选
            //给“全选”按钮添加单击事件，全选按钮是固有元素，直接使用jQuery事件函数
            $("#checkAllCustomer").click(function () {
                //各子选择按钮的状态设置为和全选按钮的状态一致
                $("#queryCustomerBody input[type='checkbox']").prop("checked", $("#checkAllCustomer").prop("checked"));
            });
            //给所有的子选择按钮添加单击事件，由于子选择按钮是动态生成的元素，只能使用jQuery的on函数
            $("#queryCustomerBody").on("click", "input[type='checkbox']", function () {
                //通过判断所有的子选择按钮的数组长度和是选择状态的子选择按钮长度来设置全选的状态
                if ($("#queryCustomerBody input[type='checkbox']").size() == $("#queryCustomerBody input[type='checkbox']:checked").size()) {
                    $("#checkAllCustomer").prop("checked", true);
                } else {
                    $("#checkAllCustomer").prop("checked", false);
                }
            });

            //给删除按钮添加单击事件
            $("#deleteCustomerBtn").click(function () {
                //收集参数
                var checkIds = $("#queryCustomerBody input[type='checkbox']:checked");
                if (checkIds.size() == 0) {
                    alert("请选择要删除的客户信息");
                    return;
                }
                //遍历jQuery数组，拼接字符串
                var idStr = "";
                $.each(checkIds, function () {
                    idStr += "id=" + this.value + "&";
                });
                //截取字符串最后一个"&"之前的字符串
                idStr = idStr.substr(0, idStr.length - 1);
                //一定要提示是否删除
                if(window.confirm("确认删除吗？")){
                    //发送ajax请求
                    $.ajax({
                        url: "workbench/customer/deleteCustomerByIds.do",
                        dataType: "json",
                        type: "post",
                        data: idStr,
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else {
                                //刷新列表，当前页是第一页，因为可能删除的是最后一页，每页显示记录条数不变
                                queryCustomerByCondition(1, $("#customerPage").bs_pagination("getOption", "rowsPerPage"));
                            }
                        }
                    });
                }

            });

            //给“修改”按钮添加单击事件
            $("#editCustomerBtn").click(function () {
                //收集参数
                var checkedId = $("#queryCustomerBody input[type='checkbox']:checked");
                if (checkedId.size() == 0) {
                    alert("请选择要修改的客户");
                    return;
                }
                if(checkedId.size()>1){
                    alert("每次只能选择修改一条记录");
                    return;
                }
                var id=checkedId[0].value;
                //发送请求
                $.ajax({
                    url:"workbench/customer/queryCustomerById.do",
                    dataType:"json",
                    type:"post",
                    data:{
                        id:id
                    },
                    success:function(data){
                        if(data.code=="0"){
                            alert(data.message);
                        }else{
                            //将查询结果设值到修改客户的模态窗口
                            $("#edit-id").val(data.id);
                            $("#edit-customerOwner").val(data.owner);
                            $("#edit-customerName").val(data.name);
                            $("#edit-phone").val(data.phone);
                            $("#edit-website").val(data.website);
                            $("#edit-contactSummary").val(data.contactSummary);
                            $("#edit-description").val(data.description);
                            $("#edit-nextContactTime").val(data.nextContactTime);
                            $("#edit-address").val(data.address);

                            //显示模态窗口
                            $("#editCustomerModal").modal("show");
                        }
                    }
                });
            });
            //给“更新”按钮添加单击事件
            $("#saveEditCustomerBtn").click(function(){
                //收集参数
                var id = $("#edit-id").val();
                var owner = $("#edit-customerOwner").val();
                var name = $("#edit-customerName").val();
                var phone = $("#edit-phone").val();
                var website = $("#edit-website").val();
                var contactSummary = $("#edit-contactSummary").val();
                var description = $("#edit-description").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $("#edit-address").val();
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (website != "") {
                    var regExp = /^([a-zA-z]+:\/\/[^\s]*)|(http:\/\/([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?)$/;
                    if (!regExp.test(website)) {
                        alert("请输入格式正确的网站");
                        return;
                    }
                }
                if (phone != "") {
                    var regExp = /^(\d{3,4}-?\d{7,8})$/;
                    if (!regExp.test(phone)) {
                        alert("请输入格式正确的座机号码");
                        return;
                    }
                }

                //发送请求
                $.ajax({
                    url:"workbench/customer/saveEditCustomer.do",
                    dataType:"json",
                    type:"post",
                    data:{
                        id:id,
                        owner:owner,
                        name:name,
                        website:website,
                        phone:phone,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        description:description,
                        address:address
                    },
                    success:function(data){
                        if(data.code == "1"){
                            //更新成功，隐藏模态窗口，显示当前页面为修改前的页面，每页显示记录条数不变
                            queryCustomerByCondition($("#customerPage").bs_pagination("getOption","currentPage"),$("#customerPage").bs_pagination("getOption","rowsPerPage"));
                            $("#editCustomerModal").modal("hide");
                        }else{
                            alert(data.message);
                            //更新失败，显示模态窗口
                            $("#editCustomerModal").modal("show");
                        }
                    }
                });
            });

        });

        //定义查询客户的方法
        function queryCustomerByCondition(pageNo, pageSize) {
            //每次查询之前先设置全选按钮的状态是false
            $("#checkAllCustomer").prop("checked", false);
            //收集参数
            var name = $.trim($("#queryCustomerName").val());
            var owner = $.trim($("#queryCustomerOwner").val());
            var phone = $.trim($("#queryCustomerPhone").val());
            var website = $.trim($("#queryCustomerWebsite").val());
            //发送ajax请求
            $.ajax({
                url: "workbench/customer/queryCustomerByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    name: name,
                    owner: owner,
                    phone: phone,
                    website: website,
                    pageNo: pageNo,
                    pageSize: pageSize,
                },
                success: function (data) {
                    //刷新页面
                    var htmlStr = "";
                    //遍历结果
                    $.each(data.customerList, function (index,obj) {
                        //隔行换色
                        if(index%2==0){
                            htmlStr+="<tr>";
                        }else{
                            htmlStr+="<tr class=\"active\">";
                        }
                        htmlStr += "<td><input value=\"" + this.id + "\" type=\"checkbox\" /></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/queryCustomerForDetailById.do?id="+this.id+"';\">" +this.name+ "</a></td>";
                        htmlStr += "<td>" + this.owner + "</td>";
                        htmlStr += "<td>" + this.phone + "</td>";
                        htmlStr += "<td>" + this.website + "</td>";
                        htmlStr += "</tr>";
                    });
                    //将字符串以HTML代码执行
                    $("#queryCustomerBody").html(htmlStr);
                    //因为分页是和数据紧密联系的，所以显示数据之后使用分页插件
                    //计算总页数
                    var totalPages = 0;
                    if (data.totalRows % pageSize == 0) {
                        totalPages = data.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(data.totalRows / pageSize) + 1;
                    }
                    $("#customerPage").bs_pagination({
                        currentPage: pageNo,
                        rowsPerPage: pageSize,
                        totalRows: data.totalRows,
                        totalPages: totalPages,
                        visiblePageLinks: 5,
                        showGotoPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        onChangePage: function (e, pageObj) {
                            queryCustomerByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form id="createCustomerForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-customerOwner">
                                <option></option>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                                <%-- <option>zhangsan</option>
                                 <option>lisi</option>
                                 <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
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
                            <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address1"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveCreateCustomerBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
    <%--这个div用于显示完整的时间窗口--%>
    <div style="height: 100px"></div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--设置隐藏域--%>
                            <input type="hidden" id="edit-id"/>
                            <select class="form-control" id="edit-customerOwner">
                                <option></option>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                                <%-- <option>zhangsan</option>
                                 <option>lisi</option>
                                 <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
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
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveEditCustomerBtn" type="button" class="btn btn-primary" >更新</button>
            </div>
        </div>
    </div>
    <%--这个div用于显示完整的时间窗口--%>
    <div style="height: 100px"></div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input id="queryCustomerName" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="queryCustomerOwner" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input id="queryCustomerPhone" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input id="queryCustomerWebsite" class="form-control" type="text">
                    </div>
                </div>

                <button id="queryCustomerBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createCustomerBtn" type="button" class="btn btn-primary"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editCustomerBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteCustomerBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="checkAllCustomer" type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="queryCustomerBody">
                <%--<tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>--%>
                </tbody>
            </table>
            <div id="customerPage"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 30px;">
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