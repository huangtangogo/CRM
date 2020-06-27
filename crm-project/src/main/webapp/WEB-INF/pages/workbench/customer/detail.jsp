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
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"  rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            /*$(".remarkDiv").mouseover(function(){
                $(this).children("div").children("div").show();
            });*/
            //给动态生成的元素添加事件只能使用on函数
            $("#customerRemarkDiv").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            /*$(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });*/
            $("#customerRemarkDiv").on("mouserout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            /*$(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });*/
            $("#customerRemarkDiv").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });


            /*$(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });*/
            $("#customerRemarkDiv").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //给保存备注添加单击事件
            $("#saveCreateRemarkBtn").click(function () {
                //收集参数
                var customerId = '${customer.id}';
                var noteContent = $.trim($("#remark").val());
                //表单验证
                if (noteContent == "") {
                    alert("备注不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url: "workbench/customer/saveCustomerRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        customerId: customerId,
                        noteContent: noteContent,
                    },
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else {
                            //刷新列表
                            var htmlStr = "";
                            htmlStr += "<div id=\"div_" + data.retData.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">";
                            htmlStr += "<img title=\"zhangsan\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
                            htmlStr += "<h5>" + data.retData.noteContent + "</h5>";
                            htmlStr += "<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${customer.name}</b> <small style=\"color: gray;\"> " + data.retData.createTime + " 由${sessionScope.sessionUser.name}创建</small>";
                            htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr += "<a name=\"editA\"  remarkId=\"" + data.retData.id + "\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr += "<a name=\"deleteA\"  remarkId=\"" + data.retData.id + "\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            //追加到外部元素的前面
                            $("#remarkDiv").before(htmlStr);
                            //保存图标隐藏
                            $("#cancelAndSaveBtn").hide();
                            cancelAndSaveBtnDefault = true
                            //清空填写备注栏
                            $("#remark").val("");
                        }
                    }
                });
            });

            //给删除图标添加单击事件,因为是动态生成的元素，所以使用on函数
            $("#customerRemarkDiv").on('click', "a[name='deleteA']", function () {
                //收集参数
                var id = $(this).attr("remarkId");

                //发送请求
                $.ajax({
                    url: "workbench/customer/deleteCustomerRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id
                    },
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else {
                            //删除div
                            $("#div_" + id).remove();
                        }
                    }
                });
            });

            //给修改图标添加单击事件,动态元素，使用on函数
            $("#customerRemarkDiv").on("click", "a[name='editA']", function () {
                //获取参数
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_" + id + " h5").text();

                //设值修改内容到更新备注的模态窗口
                $("#edit-id").val(id);
                $("#edit-noteContent").val(noteContent);
                //显示模态窗口
                $("#editRemarkModal").modal("show");
            });

            //给备注更新按钮添加单击事件,固有元素，使用事件函数
            $("#updateRemarkBtn").click(function () {
                //收集参数
                var id = $("#edit-id").val();
                var noteContent = $.trim($("#edit-noteContent").val());
                //表单验证
                if (noteContent == "") {
                    alert("备注不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url: "workbench/customer/updateCustomerRemark.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                            //显示模态窗口
                            $("#editRemarkModal").modal("show");
                        } else {
                            //隐藏模态窗口
                            $("#editRemarkModal").modal("hide");
                            //将结果设值到对应的备注中
                            $("#div_" + id + " h5").text(noteContent);
                            $("#div_" + id + " small").test(" " + data.retData.editTime + " 由${sessionScope.sessionUser.name}修改");
                        }
                    }
                });
            });

            //给删除交易图标添加单击事件,因为是动态生成的数据，使用on函数
            $("#tranBody").on("click", "a[name='deleteTranA']", function () {
                //将tranId保存到隐藏域中
                var tranId = $(this).attr("tranId");
                $("#tranId").val(tranId);
                //显示删除交易的模态窗口
                $("#removeTransactionModal").modal("show");
            });
            //给确认删除按钮添加单击事件
            $("#deleteTranBtn").click(function () {
                //收集参数
                var tranId = $("#tranId").val();
                //发送请求
                $.ajax({
                    url: "workbench/customer/deleteTranOfCustomerDetail.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        tranId: tranId
                    },
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                            //显示删除交易的模态窗口
                            $("#removeTransactionModal").modal("show");
                        } else {
                            //隐藏删除交易的模态窗口
                            $("#removeTransactionModal").modal("hide");
                            //删除tr
                            $("#tr_" + tranId).remove();
                        }
                    }
                });
            });

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

			//给新建联系人按钮添加单击事件
            $("#createConstantsBtn").click(function(){
                //alert("666666666666");调试经常使用
                //表单重置
                $("#createContactsModal form")[0].reset();
                //显示创建联系人的模态窗口
                $("#createContactsModal").modal("show");
            });


            //给保存按钮添加单击事件
			$("#saveCreateContactsBtn").click(function(){
				//收集参数
				var owner =$("#create-contactsOwner").val();
				var source = $("#create-clueSource").val();
				var customerId = $("#create_customerId").val();
				var fullName = $.trim($("#create-surname").val());
				var appellation = $("#create-call").val();
				var email = $.trim($("#create-email").val());
				var mphone = $.trim($("#create-mphone").val());
				var job = $.trim($("#create-job").val());
				var birth = $("#create-birth").val();
				var description = $.trim($("#create-description").val());
				var contactSummary = $.trim($("#create-contactSummary").val());
				var nextContactTime = $.trim($("#create-nextContactTime").val());
				var address = $.trim($("#create-address").val());

				//表单验证
				if(owner == ""){
					alert("所有者不能为空");
					return;
				}
				if(fullName == ""){
					alert("姓名不能为空");
					return;
				}
				//如果手机号不为空，使用正则表达式验证字符串
				if(mphone != ""){
					var regExp = new RegExp("^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$");
					if(!regExp.test(mphone)){
						alert("请输入正确格式的手机号码");
						return;
					}
				}
				//如果邮箱地址不为空，使用正则表达式验证字符串
				if(email != ""){
					var regExp = new RegExp("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$");
					if(!regExp.test(email)){
						alert("请输入正确格式的邮箱地址");
						return;
					}
				}
				//发送请求
				$.ajax({
					url:"workbench/customer/saveCreateContactOfCustomer.do",
					dataType:"json",
					type:"post",
					data:{
						owner:owner,
						source:source,
                        customerId:customerId,
						fullName:fullName,
						appellation:appellation,
						email:email,
						mphone:mphone,
						job:job,
						birth:birth,
						description:description,
						contactSummary:contactSummary,
						nextContactTime:nextContactTime,
						address:address
					},
					success:function(data){
						if(data.code=="0"){
							alert(data.message);
                            //显示创建联系人模态窗口
                            $("#createContactsModal").modal("show");
						}else{
						    //关闭创建联系人模态窗口
                            $("#createContactsModal").modal("hide");
							//刷新页面
							var htmlStr = "";
                            htmlStr+="<tr id=\"tr_"+data.retData.id+"\">";
                            htmlStr+="<td><a name=\"detailContactsA\" contactsId=\""+data.retData.id+"\" href=\"../contacts/detail.jsp\" style=\"text-decoration: none;\">"+data.retData.fullName+"</a>";
                            htmlStr+="</td>";
                            htmlStr+="<td>"+data.retData.email+"</td>";
                            htmlStr+="<td>"+data.retData.mphone+"</td>";
                            htmlStr+="<td><a name=\"deleteContactsA\" contactsId=\""+data.retData.id+"\" href=\"javascript:void(0);\" ";
                            htmlStr+="style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>删除</a>";
                            htmlStr+="</td>";
                            htmlStr+="</tr>";
							//在内部元素的后面以HTML代码执行
                            $("#contactsBody").append(htmlStr);
						}
					}
				});
			});

			//给动态元素删除联系人图标添加单击事件，使用JQuery的on函数
            $("#contactsBody").on("click","a[name='deleteContactsA']",function(){
               //获取联系人id值
               var id = $(this).attr("contactsId");
               //设值到删除联系人的模态窗口隐藏域
                $("#contactsId").val(id);
                //显示删除联系人的模态窗口
                $("#removeContactsModal").modal("show");
            });
            //给删除按钮添加单击事件
            $("#deleteContactsBtn").click(function(){
                //收集参数
                var id = $("#contactsId").val();
                //发送请求
                $.ajax({
                    url:"workbench/customer/deleteContactsOfCustomerById.do",
                    type:"post",
                    dataType:"json",
                    data:{
                        id:id
                    },
                    success:function(data){
                        if(data.code=="0"){
                            alert(data.message);
                            //显示删除联系人模态窗口
                            $("#removeContactsModal").modal("show");
                        }else{
                            //关闭删除联系人模态窗口
                            $("#removeContactsModal").modal("hide");
                            //刷新列表
                            $("#tr_"+id).remove();
                        }
                    }
                });
            });

            //给删除按钮添加单击事件
            $("#deleteCustomerBtn").click(function(){
                //显示删除客户的模态窗口
                $("#removeCustomerModal").modal("show");
            });
            //给确认删除按钮添加单击事件
            $("#checkDeleteCustomerBtn").click(function(){
                //收集参数
                var id=$("#customerId").val();
                //发送请求
                $.ajax({
                   url:"workbench/customer/deleteCustomerByIds.do",
                    type:"post",
                    dataType:"json",
                    data:{
                       id:id
                    },
                    success:function(data){
                       if(data.code=="0"){
                           alert(data.message);
                           //显示删除客户的模态窗口
                           $("#removeCustomerModal").modal("show");
                       }else{
                           //关闭模态窗口
                           $("#removeCustomerModal").modal("show");
                           //回到显示页面,同步请求
                           window.location.href="workbench/customer/index.do";
                       }
                    }
                });
            });

            //给编辑按钮添加单击事件
            $("#editCustomerBtn").click(function(){
                //给发送个异步请求，设值下拉框id到文本中，完成初始化
                var id = "${customer.id}";
                $.ajax({
                    url:"workbench/customer/queryCustomerById.do",
                    type:"post",
                    dataType:"json",
                    data:{
                        id:id,
                    },
                    success:function(data){
                        $("#edit-customerOwner").val(data.owner);
                        //显示修改客户的模态窗口
                        $("#editCustomerModal").modal("show");
                    }
                });

            });
            //给更新按钮添加单击事件
            $("#saveEditCustomerBtn").click(function(){
                //收集参数
                var id = '${customer.id}';
                var owner = $("#edit-customerOwner").val();
                var name = $.trim($("#edit-customerName").val());
                var website = $.trim($("#edit-website").val());
                var phone = $.trim($("#edit-phone").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $.trim($("#edit-nextContactTime").val());
                var description = $.trim($("#edit-description").val());
                var address = $.trim($("#edit-address").val());

                //表单验证
                if(owner == ""){
                    alert("所有者不能为空");
                    return;
                }
                if(name == ""){
                    alert("名称不能为空");
                    return;
                }
                if(website != ""){
                    //使用正则表达式
                    var regExp = new RegExp("^([a-zA-z]+:\\/\\/[^\\s]*)|(http:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w-./?%&=]*)?)$");
                    if(! regExp.test(website)){
                        alert("请输入正确格式的网站地址");
                        return;
                    }
                }
                if(phone != ""){
                    //使用正则表达式
                    var regExp = new RegExp("^(\\d{3,4}-?\\d{7,8})$");
                    if(! regExp.test(phone)){
                        alert("请输入正确格式的电话号码");
                        return;
                    }
                }
                //发送请求
                $.ajax({
                   url:"workbench/customer/saveEditCustomer.do",
                    type:"post",
                    dataType:"json",
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
                       if(data.code=="0"){
                           alert(data.message);
                           //显示修改客户的模态窗口
                           $("#editCustomerModal").modal("show");
                       }else{
                           //发送请求，查询保存修改好的用户
                           $.ajax({
                               url:"workbench/customer/queryCustomerAfterEditById.do",
                               type:"post",
                               dataType:"json",
                               data: {
                                   id: id
                               },
                               success:function(data){
                                   //隐藏修改客户的模态窗口
                                   $("#editCustomerModal").modal("hide");
                                   //局部刷新页面信息
                                   $("#detailOwner").text(data.owner);
                                   $("#detailName").text(data.name);
                                   $("#detailWebsite").text(data.website);
                                   $("#detailPhone").text(data.phone);
                                   $("#detailCreateBy").text(data.createBy);
                                   $("#detailCreateTime").text(" "+data.createTime);
                                   $("#detailEditBy").text(data.editBy);
                                   $("#detailEditTime").text(" "+data.editTime);
                                   $("#detailContactSummary").text(data.contactSummary);
                                   $("#detailNextContactTime").text(data.nextContactTime);
                                   $("#detailDescription").text(data.description);
                                   $("#detailAddress").text(data.address);
                                  //可以可以，保持思考
                                   var htmlStr = "";
                                    htmlStr += "<h3>"+data.name+" <small><a href=\""+data.website+"\" target=\"_blank\">"+data.website+"</a></small></h3>";
                                   $("#detailBigName").html(htmlStr);
                               }
                           });
                       }
                    }
                });
            });

            //给新建交易图标添加单击事件
            $("#createTranBtn").click(function () {
                //收集参数
                var customerId = '${customer.id}';
                var name = '${customer.name}';

                //同步请求
                window.location.href="workbench/customer/save.do?customerId="+customerId+"&name="+name;
            })
            //给交易超链接添加单击事件
            $("#tranBody").on("click","a[name='detailTranA']",function(){
                //收集参数
                var id = $(this).attr("tranId");
                //发送请求
                window.location.href="workbench/transaction/queryTranForDetail.do?id="+id;
            });
            //给联系人超链接添加单击事件
            $("#contactsBody").on("click","a[name='detailContactsA']",function(){
               //收集参数
               var id= $(this).attr("contactsId");
               //发送请求
                window.location.href="workbench/contacts/queryContactsForDetailById.do?id="+id;
            });
        });

    </script>

</head>
<body>
<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="-myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
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
                            <input type="text" class="form-control" id="edit-customerName" value="${customer.name}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="${customer.website}">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="${customer.phone}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description" >${customer.description}</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary" >${customer.contactSummary}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime" value="${customer.nextContactTime}" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">${customer.address}</textarea>
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

<!-- 修改客户备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <%-- 备注的id --%>
                            <input type="hidden" id="edit-id"/>
                            <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除客户的模态窗口 -->
<div class="modal fade" id="removeCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除客户</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该客户吗？</p>
            </div>
            <div class="modal-footer">
                <input type="hidden" id="customerId" value="${customer.id}"/>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="checkDeleteCustomerBtn" type="button" class="btn btn-danger">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除联系人的模态窗口 -->
<div class="modal fade" id="removeContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除联系人</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该联系人吗？</p>
            </div>
            <div class="modal-footer">
                <input type="hidden" id="contactsId"/>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="deleteContactsBtn" type="button" class="btn btn-danger">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除交易的模态窗口 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除交易</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该交易吗？</p>
            </div>
            <div class="modal-footer">
                <input type="hidden" id="tranId"/>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button id="deleteTranBtn" type="button" class="btn btn-danger">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

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
                            <input type="text" class="form-control" id="create-mphone">
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
							<%--这里的客户名称只读，并且这样才符合需求，不然客户和联系人无法绑定在一起--%>
                            <input type="hidden" id="create_customerId" value="${customer.id}"/>
                            <input type="text" class="form-control" id="create-customerName"
                                   value="${customer.name}" readonly>
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
                            <label for="create-address" class="col-sm-2 control-label">联系地址</label>
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


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header" id="detailBigName">
        <h3>${customer.name} <small><a href="${customer.website}" target="_blank">${customer.website}</a></small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button id="editCustomerBtn" type="button" class="btn btn-default"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button id="deleteCustomerBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;" id="detailOwner"><b>${customer.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;" id="detailName"><b>${customer.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;" id="detailWebsite"><b>${customer.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;" id="detailPhone"><b>${customer.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b id="detailCreateBy">${customer.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;" id="detailCreateTime">${customer.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;" >
            <b id="detailEditBy">${customer.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;" id="detailEditTime">${customer.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;" >联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="detailContactSummary">
                ${customer.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;" id="detailNextContactTime"><b>${customer.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="detailDescription">
                ${customer.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="detailAddress">
                ${customer.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="customerRemarkDiv" style="position: relative; top: 10px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <c:forEach items="${customerRemarkList}" var="customerRemark">
        <div id="div_${customerRemark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${customer.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${customerRemark.noteContent}</h5>
                <font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small
                    style="color: gray;"> ${customerRemark.editFlag=='0'?customerRemark.createTime:customerRemark.editTime}
                由${customerRemark.editFlag=='0'?customerRemark.createBy:customerRemark.editBy}${customerRemark.editFlag=='0'?'创建':'修改'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a name="editA" remarkId="${customerRemark.id}" class="myHref" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a name="deleteA" remarkId="${customerRemark.id}" class="myHref" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <%--<!-- 备注1 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>哎呦！</h5>
            <font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>呵呵！</h5>
            <font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveCreateRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 交易 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable2" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="tranBody">
                <c:forEach items="${tranList}" var="tran">
                    <tr id="tr_${tran.id}">
                        <td><a name="detailTranA" tranId="${tran.id}" href="javascript:void(0);" style="text-decoration: none;">${tran.name}</a></td>
                        <td>${tran.money}</td>
                        <td>${tran.stage}</td>
                        <td>${tran.possibility}</td>
                        <td>${tran.expectedDate}</td>
                        <td>${tran.type}</td>
                        <td><a name="deleteTranA" tranId="${tran.id}" href="javascript:void(0);"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>
                        </td>
                    </tr>
                </c:forEach>
                <%--<tr>
                    <td><a href="../transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>
                    <td>5,000</td>
                    <td>谈判/复审</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>新业务</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeTransactionModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a id="createTranBtn" href="javascript:void(0);" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 联系人 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>联系人</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>邮箱</td>
                    <td>手机</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="contactsBody" >
                <c:forEach items="${contactsList}" var="contacts">
                    <tr id="tr_${contacts.id}">
                        <td><a name="detailContactsA" contactsId="${contacts.id}" href="javascript:void(0);" style="text-decoration: none;">${contacts.fullName}</a>
                        </td>
                        <td>${contacts.email}</td>
                        <td>${contacts.mphone}</td>
                        <td><a name="deleteContactsA" contactsId="${contacts.id}" href="javascript:void(0);"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>
                        </td>
                    </tr>
                </c:forEach>
                <%--<tr>
                    <td><a href="../contacts/detail.jsp" style="text-decoration: none;">李四</a></td>
                    <td>lisi@bjpowernode.com</td>
                    <td>13543645364</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a id="createConstantsBtn" href="javascript:void(0);"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
        </div>
    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>