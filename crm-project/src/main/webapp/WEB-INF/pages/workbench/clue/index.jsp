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
            //给创建线索添加单击事件
            $("#createClueBtn").click(function () {
                //在弹出创建线索模态窗口之前清空创建线索表单中内容,使用dom对象的reset方法
                $("#createClueForm")[0].reset();
                //显示创建线索模态窗口
                $("#createClueModal").modal("show");
            });

            //给保存按钮添加单击事件
            $("#saveCreateClueBtn").click(function () {
                //收集参数
                var owner = $("#create-clueOwner").val();
                var company = $.trim($("#create-company").val());
                var appellation = $("#create-call").val();
                var fullName = $.trim($("#create-surname").val());
                var job = $.trim($("#create-job").val());
                var email = $.trim($("#create-email").val());
                var mphone = $.trim($("#create-mphone").val());
                var website = $.trim($("#create-website").val());
                var phone = $.trim($("#create-phone").val());
                var state = $("#create-status").val();
                var source = $("#create-source").val();
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());

                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司不能为空");
                    return;
                }
                if (fullName == "") {
                    alert("姓名不能为空");
                    return;
                }

                if (email != "") {
                    //使用正则表达式验证邮箱
                    var regExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                    if (!regExp.test(email)) {
                        alert("请输入正确的邮箱格式");
                        return;
                    }
                }
                if (phone != "") {
                    //使用正则表达式验证座机
                    var regExp = /^(\d{3,4}-?\d{7,8})$/;
                    if (!regExp.test(phone)) {
                        alert("请输入正确的座机号码");
                        return;
                    }
                }
                if (website != "") {
                    //使用正则表达式验证网站信息
                    var regExp = /^([a-zA-z]+:\/\/[^\s]*)|(http:\/\/([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?)$/;
                    if (!regExp.test(website)) {
                        alert("请输入正确的网站地址");
                        return;
                    }
                }
                if (mphone != "") {
                    //使用正则表达式验证手机号码
                    var regExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
                    if (!regExp.test(mphone)) {
                        alert("请输入正确的手机号码");
                        return;
                    }
                }
                //发送请求
                $.ajax({
                    url: "workbench/clue/saveCreateClue.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        owner: owner,
                        company: company,
                        appellation: appellation,
                        fullName: fullName,
                        job: job,
                        email: email,
                        mphone: mphone,
                        website: website,
                        phone: phone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },

                    success: function (data) {
                        if (data.code == "1") {
                            //关闭创建线索的模态窗口
                            $("#createClueModal").modal("hide");
                            //模拟创建成功
                            //alert("创建线索成功");
                            //创建成功之后,关闭模态窗口,刷新市场活动列，显示第一页数据，保持每页显示条数不变
                            queryClueForPageByCondition(1, $("#divOfClueForPage").bs_pagination("getOption", "rowsPerPage"))
                        } else {
                            alert(data.message);
                            //显示创建线索的模态窗口
                            $("#createClueModal").modal("show");
                        }
                    }
                });
            });
            //使用日期插件
            $(".myDate").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd",
                minView: "month",
                initialDate: new Date(),
                autoclose: true,
                todayBtn: true,
                clearBtn: true,
            });

            //页面加载完成之后查询数据，默认显示当前页是第一页，显示条数是10条
            queryClueForPageByCondition(1, 10);
            //给“查询”按钮添加单击事件，但是查询时候是应该回到第一页，但是每页显示记录条数应该不变
            $("#queryClueBtn").click(function () {
                queryClueForPageByCondition(1, $("#divOfClueForPage").bs_pagination("getOption", "rowsPerPage"));
            });

            //给“删除”按钮添加单击事件
            $("#deleteClueBtn").click(function () {
                //收集参数
                var checkIds = $("#clueBody input[type='checkbox']:checked");
                //表单验证
                if (checkIds.size() == 0) {
                    alert("请选择要删除的线索");
                    return;
                }
                //遍历数组，拼接id
                var idStr = "";
                $.each(checkIds, function () {
                    idStr += "id=" + this.value + "&";
                });
                //去掉最后一个"&"
                idStr = idStr.substr(0, idStr.length - 1);

                //提示是否删除
                if(window.confirm("确定删除线索吗？")){
                    //发送请求
                    $.ajax({
                        url: "workbench/clue/deleteClueByIds.do",
                        dataType: "json",
                        type: "post",
                        data: idStr,
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else {
                                //删除成功，刷新列表，当前页为第一页，为了避免删除最后一页时显示无数据页面，每页显示记录条数不变
                                queryClueForPageByCondition(1, $("#divOfClueForPage").bs_pagination("getOption", "rowsPerPage"));
                            }
                        }
                    });
                }
            });
            //设置全选和取消全选
            //给“全选”按钮添加点击事件，直接使用事件函数，因为全选时固有元素
            $("#checkAllClue").click(function () {
                $("#clueBody input[type='checkbox']").prop("checked", $("#checkAllClue").prop("checked"));
            });
            //给子元素“选择”全部添加单击事件，使用on函数，因为是动态生成的数据
            $("#clueBody").on("click", "input[type='checkbox']", function () {
                //通过判断子元素的jQuery数组长度和已选择子元素的jQuery数组长度来设置全选的状态
                if ($("#clueBody input[type='checkbox']").size() == $("#clueBody input[type='checkbox']:checked").size()) {
                    $("#checkAllClue").prop("checked", true);
                } else {
                    $("#checkAllClue").prop("checked", false);
                }
            });

            //给“修改”按钮添加单击事件
            $("#editClueBtn").click(function () {
                //收集参数
                var checkId = $("#clueBody input[type='checkbox']:checked");
                if (checkId.size() == 0) {
                    alert("请选择要修改的线索");
                    return;
                }
                if (checkId.size() > 1) {
                    alert("每次只能选择修改一条线索");
                    return;
                }
                var id = checkId[0].value;
                //发送请求
                $.ajax({
                    url: "workbench/clue/queryClueById.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id
                    },
                    success: function (data) {
                       //设值到修改线索的模态窗口
                        $("#edit-clueId").val(data.id);
                        $("#edit-clueOwner").val(data.owner);
                        $("#edit-company").val(data.company);
                        $("#edit-call").val(data.appellation);
                        $("#edit-surname").val(data.fullName);
                        $("#edit-job").val(data.job);
                        $("#edit-email").val(data.email);
                        $("#edit-phone").val(data.phone);
                        $("#edit-website").val(data.website);
                        $("#edit-mphone").val(data.mphone);
                        $("#edit-status").val(data.state);
                        $("#edit-source").val(data.source);
                        $("#edit-description").val(data.description);
                        $("#edit-contactSummary").val(data.contactSummary);
                        $("#edit-nextContactTime").val(data.nextContactTime);
                        $("#edit-address").val(data.address);

                        //显示模态窗口
                        $("#editClueModal").modal("show");
                    }
                });
            });

            //给线索“更新”按钮添加单击事件
            $("#saveEditClueBtn").click(function(){
                //收集参数
                var id = $("#edit-clueId").val();
                var owner = $("#edit-clueOwner").val();
                var company = $("#edit-company").val();
                var appellation = $("#edit-call").val();
                var fullName = $("#edit-surname").val();
                var job = $("#edit-job").val();
                var email = $("#edit-email").val();
                var phone = $("#edit-phone").val();
                var website = $("#edit-website").val();
                var mphone = $("#edit-mphone").val();
                var state = $("#edit-status").val();
                var source = $("#edit-source").val();
                var description = $("#edit-description").val();
                var contactSummary = $("#edit-contactSummary").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $("#edit-address").val();

                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司不能为空");
                    return;
                }
                if (fullName == "") {
                    alert("姓名不能为空");
                    return;
                }

                if (email != "") {
                    //使用正则表达式验证邮箱
                    var regExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                    if (!regExp.test(email)) {
                        alert("请输入正确的邮箱格式");
                        return;
                    }
                }
                if (phone != "") {
                    //使用正则表达式验证座机
                    var regExp = /^(\(\d{3,4}-)|(\d{3,4}-?\d{7,8})$/;
                    if (!regExp.test(phone)) {
                        alert("请输入正确的座机号码");
                        return;
                    }
                }
                if (website != "") {
                    //使用正则表达式验证网站信息
                    var regExp = /^([a-zA-z]+:\/\/[^\s]*)|(http:\/\/([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?)$/;
                    if (!regExp.test(website)) {
                        alert("请输入正确的网站地址");
                        return;
                    }
                }
                if (mphone != "") {
                    //使用正则表达式验证手机号码
                    var regExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
                    if (!regExp.test(mphone)) {
                        alert("请输入正确的手机号码");
                        return;
                    }
                }

                //发送请求
                $.ajax({
                    url:"workbench/clue/saveEditClue.do",
                    type:"post",
                    dataType:"json",
                    data:{
                        id:id,
                        owner: owner,
                        company: company,
                        appellation: appellation,
                        fullName: fullName,
                        job: job,
                        email: email,
                        mphone: mphone,
                        website: website,
                        phone: phone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    success:function(data){
                        if(data.code == "0"){
                            alert(data.message);
                            //模态窗口显示
                            $("#editClueModal").modal("show");
                        }else{
                            //关闭模态窗口
                            $("#editClueModal").modal("hide");
                            //刷新列表，显示页面仍是当前页，每页显示条数不变
                            queryClueForPageByCondition($("#divOfClueForPage").bs_pagination("getOption","currentPage"),$("#divOfClueForPage").bs_pagination("getOption","rowsPerPage"));
                        }
                    }
                })
            });
        });

        //声明查询方法
        function queryClueForPageByCondition(pageNo, pageSize) {
            //有个问题页面跳转时,解决，全选应该不选上
            $("#checkAllClue").prop("checked",false);
            //收集参数 fullName,company,phone,source,owner,mphone,state,pageNo,pageSize
            var fullName = $.trim($("#queryClueByFullName").val());
            var company = $.trim($("#queryClueByCompany").val());
            var phone = $.trim($("#queryClueByPhone").val());
            var source = $("#queryClueBySource").val();
            var owner = $.trim($("#queryClueByOwner").val());
            var mphone = $.trim($("#queryClueByMphone").val());
            var state = $("#queryClueByState").val();

            //发送请求
            $.ajax({
                url: "workbench/clue/queryClueForPageByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    fullName: fullName,
                    company: company,
                    phone: phone,
                    source: source,
                    owner: owner,
                    mphone: mphone,
                    state: state,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    //总记录
                    $("#totalRows").text(data.totalRows);
                    //遍历记录
                    var htmlStr = "";
                    $.each(data.clueList, function (index,obj) {
                        //隔行换色
                        if(index%2==0){
                            htmlStr+="<tr>";
                        }else{
                            htmlStr+="<tr class=\"active\">";
                        }
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + this.id + "\"/></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\"onclick=\"window.location.href='workbench/clue/queryClueForDetail.do?id="+this.id+"';\">" + this.fullName+this.appellation + "</a></td>";
                        htmlStr += "<td>" + this.company + "</td>";
                        htmlStr += "<td>" + this.phone + "</td>";
                        htmlStr += "<td>" + this.mphone + "</td>";
                        htmlStr += "<td>" + this.source + "</td>";
                        htmlStr += "<td>" + this.owner + "</td>";
                        htmlStr += "<td>" + this.state + "</td>";
                        htmlStr += "</tr>";
                    });
                    //以HTML代码执行
                    $("#clueBody").html(htmlStr);

                    //在这里使用分页插件，因为分页是和数据联合使用的，没有数据哪来的分页
                    //计算总页数
                    var totalPages = 0;
                    if (data.totalRows % pageSize == 0) {
                        totalPages = data.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(data.totalRows / pageSize) + 1;
                    }
                    $("#divOfClueForPage").bs_pagination({
                        currentPage: pageNo,//设置当前页
                        rowsPerPage: pageSize,//每页显示条数
                        totalRows: data.totalRows,//总记录条数
                        totalPages: totalPages,//总页数
                        visiblePageLinks: 5,//显示翻页数
                        showGoToPage: true,//显示跳转到指定页
                        showRowsPerPage: true,//显示每页显示条数
                        showRowsInfo: true,//显示记录信息
                        onChangePage: function (e, pageObj) {//每当页面改变会执行此函数，可以返回值获取到当前页面和每页显示记录条数等信息
                            queryClueForPageByCondition(pageObj.currentPage, pageObj.rowsPerPage);//是递归，有终止条件的递归
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form id="createClueForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                                <option></option>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
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
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-status">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                                <%-- <option>试图联系</option>
                                 <option>将来联系</option>
                                 <option>已联系</option>
                                 <option>虚假线索</option>
                                 <option>丢失线索</option>
                                 <option>未联系</option>
                                 <option>需要条件</option>--%>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                                <%--<option>广告</option>
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
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
                <button id="saveCreateClueBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
    <%--这个div用于显示完整的时间窗口--%>
    <div style="height: 100px"></div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--设值隐藏域，保存id值，为了修改--%>
                            <input id="edit-clueId" type="hidden"/>
                            <select class="form-control" id="edit-clueOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                                <%-- <option>zhangsan</option>
                                 <option>lisi</option>
                                 <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                                <%-- <option selected>先生</option>
                                 <option>夫人</option>
                                 <option>女士</option>
                                 <option>博士</option>
                                 <option>教授</option>--%>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                                <%-- <option>试图联系</option>
                                 <option>将来联系</option>
                                 <option selected>已联系</option>
                                 <option>虚假线索</option>
                                 <option>丢失线索</option>
                                 <option>未联系</option>
                                 <option>需要条件</option>--%>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
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
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime" value="2017-05-01" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveEditClueBtn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
    <%--这个div用于显示完整的时间窗口--%>
    <div style="height: 100px"></div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input id="queryClueByFullName" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input id="queryClueByCompany" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input id="queryClueByPhone" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select id="queryClueBySource" class="form-control">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.value}">${source.value}</option>
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

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="queryClueByOwner" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input id="queryClueByMphone" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select id="queryClueByState" class="form-control">
                            <option></option>
                            <c:forEach items="${clueStateList}" var="clueState">
                                <option value="${clueState.value}">${clueState.value}</option>
                            </c:forEach>
                            <%-- <option>试图联系</option>
                             <option>将来联系</option>
                             <option>已联系</option>
                             <option>虚假线索</option>
                             <option>丢失线索</option>
                             <option>未联系</option>
                             <option>需要条件</option>--%>
                        </select>
                    </div>
                </div>

                <button id="queryClueBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createClueBtn" type="button" class="btn btn-primary"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editClueBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteClueBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="checkAllClue" type="checkbox"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueBody">
                <%-- <tr>
                     <td><input type="checkbox"/></td>
                     <td><a style="text-decoration: none; cursor: pointer;"
                            onclick="window.location.href='detail.jsp';">李四先生</a></td>
                     <td>动力节点</td>
                     <td>010-84846003</td>
                     <td>12345678901</td>
                     <td>广告</td>
                     <td>zhangsan</td>
                     <td>已联系</td>
                 </tr>
                 <tr class="active">
                     <td><input type="checkbox"/></td>
                     <td><a style="text-decoration: none; cursor: pointer;"
                            onclick="window.location.href='detail.jsp';">李四先生</a></td>
                     <td>动力节点</td>
                     <td>010-84846003</td>
                     <td>12345678901</td>
                     <td>广告</td>
                     <td>zhangsan</td>
                     <td>已联系</td>
                 </tr>--%>
                </tbody>

            </table>
            <div id="divOfClueForPage"></div>

        </div>

        <%--<div style="height: 50px; position: relative;top: 60px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows">50</b>条记录</button>
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