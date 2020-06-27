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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/
		//动态生成的元素只能使用on函数
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});
		
		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});
		
		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#remarkBody").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		});
		
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#remarkBody").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		//使用日期插件
		$(".myDate").datetimepicker({
			language:"zh-CN",
			initialDate:new Date(),
			minView:"month",
			format:"yyyy-mm-dd",
			autoclose:true,
			todayBtn:true,
			clearBtn:true,
		});

		//给保存按钮添加单击事件
		$("#saveCreateContactsRemarkBtn").click(function(){
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var contactsId = '${contacts.id}';

			//表单验证
			if(noteContent == ""){
				alert("备注内容不能为空");
				return;
			}

			//发送请求
			$.ajax({
				url:"workbench/contacts/saveCreateContactsRemark.do",
				type:"post",
				dataType:"json",
				data:{
					noteContent:noteContent,
					contactsId:contactsId,
				},
				success:function(data){
					if(data.code == "0"){
						alert(data.message);
					}else{
						//拼接HTML代码，刷新备注信息
						var htmlStr = "";
						htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						htmlStr+="<img title=\"${contacts.owner}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr+="<h5>"+data.retData.noteContent+"</h5>";
						htmlStr+="<font color=\"gray\">联系人</font> <font color=\"gray\">-</font> <b>${contacts.fullName}${contacts.appellation}-${contacts.customerId}</b> <small style=\"color: gray;\"> "+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr+="<a name=\"editA\" remarkId=\""+data.retData.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr+="<a name=\"deleteA\" remarkId=\""+data.retData.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						htmlStr+="</div>";
					}
					//清空输入框信息
					$("#remark").val("");
					//在外部的后面显示
					$("#contactsRemarkDiv").after(htmlStr);
					//隐藏保存按钮
					$("#cancelAndSaveBtn").hide();
					cancelAndSaveBtnDefault = true;
				}
			});
		});

		//给删除图标添加单击事件，因为是动态生成的元素，使用on函数
		$("#remarkBody").on("click","a[name='deleteA']",function(){
			//收集参数
			var id = $(this).attr("remarkId");
			//发送请求
			$.ajax({
				url:"workbench/contacts/deleteContactsRemark.do",
				type:"post",
				dataType:"json",
				data:{
					id:id
				},
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
					}else{
						//删除div
						$("#div_"+id).remove();
					}
				}
			});
		});

		//给修改备注图标添加单击事件，使用on函数
		$("#remarkBody").on("click","a[name='editA']",function(){
			//收集参数
			var id = $(this).attr("remarkId");
			var noteContent = $("#div_"+id+" h5").text();
			//设值到修改备注的模态窗口
			$("#edit-id").val(id);
			$("#edit-noteContent").val(noteContent);
			//显示修改备注的模态窗口
			$("#editRemarkModal").modal("show");
		});

		//给更新按钮添加单击事件
		$("#updateRemarkBtn").click(function(){
			//收集参数
			var id = $("#edit-id").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			//表单验证
			if(noteContent == ""){
				alert("备注信息不能为空");
				return;
			}
			//发送请求
			$.ajax({
				url:"workbench/contacts/saveEditContactsRemark.do",
				type:"post",
				dataType:"json",
				data:{
					id:id,
					noteContent:noteContent,
				},
				success:function(data){
					if(data.code == "0"){
						alert(data.message);
						//显示修改备注的模态窗口
						$("#editRemarkModal").modal("show");
					}else{
						//隐藏修改备注的模态窗口
						$("#editRemarkModal").modal("hide");
						//更新备注信息
						$("#div_"+id+" h5").text(noteContent);
						$("#div_"+id+" small").text(" "+data.retData.editTime+" 由${sessionScope.sessionUser.name}修改")
					}
				}
			});
		});

		//给关联市场活动图标添加单击事件
		$("#bundActivityBtn").click(function(){
			//清空搜索框，和选择状态色设置为不选
			$("#activityName").val("");
			$("#activityBody").empty();
			//显示搜索市场活动模态窗口
			$("#bundActivityModal").modal("show");
		});
		//给搜索框添加键盘弹起事件
		$("#activityName").keyup(function(){
			//收集参数
			var name = $.trim($("#activityName").val());
			var contactsId = '${contacts.id}';
			//发送请求
			$.ajax({
				url:"workbench/contacts/bundActivity.do",
				type:"post",
				dataType:"json",
				data:{
					name:name,
					contactsId:contactsId,
				},
				success:function(data){
					var htmlStr = "";
					//清空信息
					$("#activityBody").empty();
					//遍历结果
					$.each(data,function(){
						//拼接HTML代码
						htmlStr+="<tr>";
						htmlStr+="<td><input type=\"checkbox\" value=\""+this.id+"\"/></td>";
						htmlStr+="<td>"+this.name+"</td>";
						htmlStr+="<td>"+this.startDate+"</td>";
						htmlStr+="<td>"+this.endDate+"</td>";
						htmlStr+="<td>"+this.owner+"</td>";
						htmlStr+="</tr>";
					});
					//刷新列表,追加的方式
					$("#activityBody").append(htmlStr);
				}
			});
		});

		//给关联市场模态窗口添加全选的和取消全选
		//给全选按钮添加单击事件
		$("#checkAll").click(function(){
			//将子元素的状态和全选的状态保持一致
			$("#activityBody input[type='checkbox']").prop("checked",$("#checkAll").prop("checked"));
		});
		//给所有动态生成的子元素添加单击事件
		$("#activityBody").on("click","input[type='checkbox']",function(){
			//通过判断所有的选择元素的数组长度和已选择的选择元素的数组长度来决定全选按钮的状态
			if($("#activityBody input[type='checkbox']").size() == $("#activityBody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked",true);
			}else{
				$("#checkAll").prop("checked",false);
			}
		});

		//给关联市场活动按钮添加单击事件,使用事件函数
		$("#bundContactsActivityRelationBtn").click(function(){
			//收集参数
			var contactsId = '${contacts.id}';
			var checkIds = $("#activityBody input[type='checkbox']:checked");
			//表单验证
			if(checkIds.size()==0){
				alert("请选择关联市场活动");
				return;
			}
			//遍历数组
			var idStr = "";
			$.each(checkIds,function(){
				idStr+="activityId="+this.value+"&";
			});
			//拼接字符串
			idStr = idStr+"contactsId="+contactsId;
			//发送请求
			$.ajax({
				url:"workbench/contacts/saveContactsActivityRelation.do",
				type:"post",
				dataType:"json",
				data:idStr,
				success:function(data){
					if(data.code == "0"){
						alert(data.message);
						//显示搜索市场活动模态窗口
						$("#bundActivityModal").modal("show");
					}else{
						var htmlStr = "";
						//遍历数组
						$.each(data.retData,function(){
							//拼接html代码
							htmlStr+="<tr id=\"tr_"+this.id+"\">";
							htmlStr+="<td><a name=\"detailActivity\"  activityId = \""+this.id+"\" href=\"../activity/detail.jsp\" style=\"text-decoration: none;\">"+this.name+"</a></td>";
							htmlStr+="<td>"+this.startDate+"</td>";
							htmlStr+="<td>"+this.endDate+"</td>";
							htmlStr+="<td>"+this.owner+"</td>";
							htmlStr+="<td><a name=\"deleteA\" activityId = \""+this.id+"\" href=\"javascript:void(0);\  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
							htmlStr+="</tr>";
						});
						//隐藏模态窗口
						$("#bundActivityModal").modal("hide");
						//刷新列表
						$("#contactsActivityBody").append(htmlStr);
					}
				}
			});
		});
		//给解除关联市场活动图标添加单击事件，使用on函数
		$("#contactsActivityBody").on("click","a[name='deleteA']",function(){
			//收集参数
			var contactsId = '${contacts.id}';
			var activityId = $(this).attr("activityId");
			//设值到隐藏域中
			$("#activityId").val(activityId)
			$("#contactsId").val(contactsId);
			//弹出模态窗口
			$("#unbundActivityModal").modal("show");
		});
		//给解除按钮添加单击事件
		$("#unbundActivityBtn").click(function(){
			//收集参数
			var contactsId = $("#contactsId").val();
			var activityId = $("#activityId").val();
			//发送请求
			$.ajax({
				url:"workbench/contacts/deleteContactsActivityRelation.do",
				dataType:"json",
				type:"post",
				data:{
					activityId:activityId,
					contactsId:contactsId
				},
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
						//弹出模态窗口
						$("#unbundActivityModal").modal("show");
					}else{
						//刷新列表
						$("#tr_"+activityId).remove();
						//隐藏模态窗口
						$("#unbundActivityModal").modal("hide");
					}
				}
			});
		});
		//给市场活动名称超链接添加单击事件
		$("#contactsActivityBody").on("click","a[name='detailActivity']",function(){
			//收集参数
			var id = $(this).attr("activityId");
			//发送请求
			window.location.href="workbench/activity/detailActivity.do?id="+id;
		});

		//给新建交易添加单击事件
		$("#createTranBtn").click(function(){
			//收集参数
			var id = '${contacts.id}';
			var fullName = '${contacts.fullName}';
			//发送请求
			window.location.href="workbench/contacts/save.do?id="+id+"&fullName="+fullName;
		});

		//给删除图标添加单击事件,使用on函数
		$("#tranBody").on("click","a[name='deleteTranA']",function(){
			//收集参数
			var tranId = $(this).attr("tranId");
			//设值到隐藏域中
			$("#tranId").val(tranId);
			//显示删除交易的模态窗口
			$("#removeTransactionModal").modal("show");
		});
		//给确认删除按钮添加单击事件
		$("#deleteTranBtn").click(function(){
			//收集参数
			var tranId = $("#tranId").val();
			//发送请求
			$.ajax({
				url:"workbench/contacts/deleteTranByTranId.do",
				type:"post",
				dataType:"json",
				data:{
					tranId:tranId,
				},
				success:function(data){
					if(data.code == "0"){
						alert(data.message);
						//显示删除交易的模态窗口
						$("#removeTransactionModal").modal("show");
					}else{
						//删除tr
						$("#tr_"+tranId).remove();
						//隐藏删除交易的模态窗口
						$("#removeTransactionModal").modal("hide");
					}
				}
			});
		});
		//给交易名称超链接添加单击事件
		$("#tranBody").on("click","a[name='detailTranA']",function(){
			//收集参数
			var id = $(this).attr("tranId");
			//发送请求
			window.location.href="workbench/transaction/queryTranForDetail.do?id="+id;
		});

		//给删除联系人图标添加单击事件
		$("#deleteContactsBtn").click(function(){
			//显示删除联系人的模态窗口
			$("#removeContactsModal").modal("show");
		});
		//给确认删除按钮添加单击事件
		$("#checkDeleteContactsBtn").click(function(){
			//收集参数
			var id = '${contacts.id}';
			//发送 请求
			$.ajax({
				url:"workbench/contacts/deleteContactsByIds.do",
				type:"post",
				dataType:"json",
				data:{
					id:id
				},
				success:function(data){
					if(data.code == "0"){
						alert(data.message);
						//显示删除联系人的模态窗口
						$("#removeContactsModal").modal("show");
					}else{
						//隐藏删除联系人的模态窗口
						$("#removeContactsModal").modal("hide");
						//跳转联系人首页
						window.location.href="workbench/contacts/index.do";
					}
				}
			});
		});

		//给编辑按钮添加单击事件
		$("#editContactsBtn").click(function(){
			//收集参数
			var id = '${contacts.id}';
			//发送请求
			$.ajax({
				url:"workbench/contacts/queryContactsById.do",
				type:"post",
				dataType:"json",
				data:{
					id:id
				},
				success:function(data){
					//设值到编辑的模态窗口
					$("#edit-contactsOwner").val(data.owner);
					$("#edit-clueSource").val(data.source);
					$("#edit-call").val(data.appellation);
					$("#edit-customerId").val(data.customerId);
					//显示模态窗口
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
			var id = "${contacts.id}";
			var owner = $("#edit-contactsOwner").val();
			var source = $("#edit-clueSource").val();
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
					if (data.code == "0") {
						alert(data.message);
						//显示创建联系人的模态窗口
						$("#editContactsModal").modal("show");
					} else {
						//保存成功，隐藏创建联系人的模态窗口
						$("#editContactsModal").modal("hide");
						//局部刷新，更新明细数据
						$("#detailContactsOwner").text(data.retData.owner);
						$("#detailContactsSource").text(data.retData.source);
						$("#detailContactsCustomer").text(data.retData.customerId);
						$("#detailContactsFullName").text(data.retData.fullName);
						$("#detailContactsEmail").text(data.retData.email);
						$("#detailContactsMphone").text(data.retData.mphone);
						$("#detailContactsJob").text(data.retData.job);
						$("#detailContactsBirth").text(data.retData.birth);
						$("#detailContactsCreateBy").text(data.retData.createBy);
						$("#detailContactsCreateTime").text(data.retData.createTime);
						$("#detailContactsEditBy").text(data.retData.editBy);
						$("#detailContactsEditTime").text(data.retData.editTime);
						$("#detailContactsDescription").text(data.retData.description);
						$("#detailContactsContactSummary").text(data.retData.contactSummary);
						$("#detailContactsNCT").text(data.retData.nextContactTime);
						$("#detailContactsAddress").text(data.retData.address);
					}
				}
			});
		});
	});
	
</script>

</head>
<body>
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
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button id="checkDeleteContactsBtn" type="button" class="btn btn-danger">删除</button>
			</div>
		</div>
	</div>
</div>

<!-- 修改备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myContactsModalLabel">修改备注</h4>
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

	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<%--创建隐藏域--%>
					<input type="hidden" id="activityId"/>
					<input type="hidden" id="contactsId"/>
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="unbundActivityBtn" type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="activityName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead id="activityDiv">
							<tr style="color: #B3B3B3;">
								<td><input id="checkAll" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="bundContactsActivityRelationBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
									<option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								 <%-- <option selected>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								  <%--<option selected>广告</option>
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
							<label for="edit-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullName" value="${contacts.fullName}">
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
								<input type="text" class="form-control" id="edit-job" value="${contacts.job}">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="${contacts.mphone}">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="${contacts.email}">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-birth" value="${contacts.birth}" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<%--设置隐藏域保存客户id--%>
								<input type="hidden" id="edit-customerId"/>
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="${contacts.customerId}">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">${contacts.description}</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">${contacts.contactSummary}</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" id="edit-nextContactTime" value="${contacts.nextContactTime}" readonly/>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">${contacts.address}</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditContactsBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${contacts.fullName} <small> - ${contacts.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="editContactsBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button id="deleteContactsBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="detailContactsOwner">${contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detailContactsSource">${contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="detailContactsCustomer">${contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detailContactsFullName">${contacts.fullName}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="detailContactsEmail">${contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detailContactsMphone">${contacts.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="detailContactsJob">${contacts.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detailContactsBirth">${contacts.birth}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detailContactsCreateBy">${contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="detailContactsCreateTime">${contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detailContactsEditBy">${contacts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="detailContactsEditTime">${contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="detailContactsDescription">
					${contacts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="detailContactsContactSummary">
					${contacts.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="detailContactsNCT">${contacts.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="detailContactsAddress">
                    ${contacts.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 20px; left: 40px;" id="remarkBody">
		<div class="page-header" id="contactsRemarkDiv">
			<h4>备注</h4>
		</div>
		<c:forEach items="${contactsRemarkList}" var="contactsRemark">
			<div id="div_${contactsRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${contacts.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${contactsRemark.noteContent}</h5>
					<font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullName}${contacts.appellation}-${contacts.customerId}</b> <small style="color: gray;"> ${contactsRemark.editFlag=='0'?contactsRemark.createTime:contactsRemark.editTime} 由${contactsRemark.editFlag=='0'?contactsRemark.createBy:contactsRemark.editBy}${contactsRemark.editFlag=='0'?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a name="editA" remarkId="${contactsRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a name="deleteA" remarkId="${contactsRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
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
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateContactsRemarkBtn" type="button" class="btn btn-primary">保存</button>
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
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
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
							<td><a name="detailTranA" tranId="${tran.id}" href="javascript:void(0);" style="text-decoration: none;">${tran.customerId}-${tran.name}</a></td>
							<td>${tran.money}</td>
							<td>${tran.stage}</td>
							<td>${tran.possibility}</td>
							<td>${tran.expectedDate}</td>
							<td>${tran.type}</td>
							<td><a name="deleteTranA" tranId="${tran.id}" href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</c:forEach>
						<%--<tr>
							<td><a href="../transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="createTranBtn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead >
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactsActivityBody">
					<c:forEach items="${activityList}" var="activity">
						<tr id="tr_${activity.id}">
							<td><a name="detailActivity" activityId = "${activity.id}" href="javascript:void(0);" style="text-decoration: none;">${activity.name}</a></td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a name="deleteA" activityId = "${activity.id}" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>
						<%--<tr>
							<td><a href="../activity/detail.jsp" style="text-decoration: none;">发传单</a></td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="bundActivityBtn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>