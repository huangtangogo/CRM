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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#clueRemark").focus(function(){
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
		//对于动态生成的数据只能使用on函数
		$("#clueRemarkDiv").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});
		
		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#clueRemarkDiv").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});
		
		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#clueRemarkDiv").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		});
		
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#clueRemarkDiv").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		//给线索备注“保存”按钮添加单击事件
		$("#saveCreateClueRemarkBtn").click(function(){
			//收集参数
			var clueId = '${clue.id}';
			var noteContent = $.trim($("#clueRemark").val());
			//表单验证
			if(noteContent == ""){
				alert("内容不能为空");
				return;
			}
			//发送请求
			$.ajax({
				url:"workbench/clue/saveCreateClueRemark.do",
				dataType:"json",
				type:"post",
				data:{
					clueId:clueId,
					noteContent:noteContent
				},
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
					}else{
						//清空文本框
						$("#clueRemark").val("");
						//按键消失，这个设计挺好的啊
						$("#cancelAndSaveBtn").hide();
						cancelAndSaveBtnDefault = true;
						//拼接HTML代码
						var htmlStr = "";
						htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr+="<h5>"+data.retData.noteContent+"</h5>";
						htmlStr+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr+="<a name=\"editA\" remarkId=\""+data.retData.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr+="<a name=\"deleteA\" remarkId=\""+data.retData.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						//通过追加到元素外部的前面
						//$("#remarkDiv").before(htmlStr);
						//这次试试追加到外部元素的后面
						$("#beforeRemarkDiv").after(htmlStr);
					}
				}
			});
		});

		//给动态数据绑定事件使用on函数，给所有的"删除图标"绑定单击事件
		$("#clueRemarkDiv").on("click","a[name='deleteA']",function () {
			//收集参数
			var id = $(this).attr("remarkId");
			//发送ajax请求
			$.ajax({
				url:"workbench/clue/deleteClueRemark.do",
				type:"post",
				dataType:"json",
				data:{
					id:id,
				},
				success:function(data){
					if(data.code == "0"){
						alert(data.message);
					}else{
						//清除对应的备注标签
						$("#div_"+id).remove();
					}
				}
			});
		});

		//给动态生成的元素绑定事件使用on函数，给所有的"修改图标"绑定单击事件
		$("#clueRemarkDiv").on("click","a[name='editA']",function () {
			//收集参数
			var id = $(this).attr("remarkId");
			var noteContent = $("#div_"+id+" h5").text();
			//设值到修改线索备注的模态窗口
			$("#edit-id").val(id);
			$("#edit-noteContent").val(noteContent);
			//显示模态窗口
			$("#editRemarkModal").modal("show");
		});
		//给固有元素使用事件函数绑定事件
		$("#updateRemarkBtn").click(function(){
			//收集参数
			var id = $("#edit-id").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			//表单验证
			if(noteContent == ""){
				alert("内容不能为空");
				return;
			}
			//发送请求
			$.ajax({
				url:"workbench/clue/saveEditRemark.do",
				type:"post",
				dataType:"json",
				data:{
					id:id,
					noteContent:noteContent
				},
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
						//显示模态窗口
						$("#editRemarkModal").modal("show");
					}else{
						//更新备注
						$("#div_"+id+" h5").text(noteContent);
						$("#div_"+id+" small").text(" "+data.retData.editTime+" 由${sessionScope.sessionUser.name}修改");
						//隐藏模态窗口
						$("#editRemarkModal").modal("hide");
					}
				}
			})
		});

		//给“关联市场活动”添加单击事件
		$("#bundActivityBtn").click(function () {
			//打开关联市场活动时发现上次浏览的记录仍存在,点击关联就关联两次了
			//清空搜索框
			$("#activityName").val("");
			//清空模糊查询结果
			$("#clueActivityRelationTbody").html("");
			//全选按钮手动设置为不选
			$("#checkAllActivity").prop("checked",false);

			//显示关联市场活动的模态窗口
			$("#bundModal").modal("show");
		});

		//全选和取消全选
		//给全选按钮添加单击事件，全选是固有元素，使用jQuery的事件函数
		$("#checkAllActivity").click(function(){
			//所有的子元素的状态应和全选按钮的状态一致,设置true和false使用prop函数
			$("#clueActivityRelationTbody input[type='checkbox']").prop("checked",$("#checkAllActivity").prop("checked"));
		});
		//给子选择按钮添加事件，子选择是动态生成的元素使用jQuery的on函数
		$("#clueActivityRelationTbody").on("click","input[type='checkbox']",function(){
			//判断所有的子选择元素的数组长度和已选中的子选择元素的数组长度大小来设置全选的状态
			if($("#clueActivityRelationTbody input[type='checkbox']").size()==$("#clueActivityRelationTbody input[type='checkbox']:checked").size()){
				$("#checkAllActivity").prop("checked",true);
			}else{
				$("#checkAllActivity").prop("checked",false);
			}
		});

		//给关联市场活动搜索框添加键盘弹起事件
		$("#activityName").keyup(function(){
			//收集参数
			var activityName = this.value;
			var clueId = '${clue.id}';
			//发送请求
			$.ajax({
				url:"workbench/clue/queryActivityForDetailByNameClueId.do",
				type:"post",
				dataType:"json",
				data:{
					activityName:activityName,
					clueId:clueId,
				},
				success:function(data){
					//将查询结果显示在线索关联市场活动的窗口
					var htmlStr = "";
					$.each(data,function(index,obj){
						htmlStr+="<tr>";
						htmlStr+="<td><input id=\"checkActivity\" value=\""+obj.id+"\" type=\"checkbox\"/></td>";
						htmlStr+="<td>"+obj.name+"</td>";
						htmlStr+="<td>"+obj.startDate+"</td>";
						htmlStr+="<td>"+obj.endDate+"</td>";
						htmlStr+="<td>"+obj.owner+"</td>";
						htmlStr+="</tr>";
					});

					//以HTML代码显示
					$("#clueActivityRelationTbody").html(htmlStr);
				}
			});
		});
		//给线索关联市场活动“关联”按钮添加单击事件
		$("#saveBundClueActivityBtn").click(function(){
			//收集参数
			var clueId = '${clue.id}';
			var checkedId = $("#clueActivityRelationTbody input[type='checkbox']:checked");
			//表单验证
			if(checkedId.size()==0){
				alert("请选择关联市场活动");
				return;
			}
			//遍历数组，拼接字符串
			var str = "";
			$.each(checkedId,function(){
				str+="activityId="+this.value+"&";
			});
			str=str+"clueId="+clueId;
			//发送请求
			$.ajax({
				url:"workbench/clue/saveBundActivity.do",
				dataType:"json",
				type:"post",
				data:str,
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
						//显示模态窗口
						$("#bundModal").modal("show");
					}else{
						//隐藏模态窗口
						$("#bundModal").modal("hide");
						//遍历结果，追加到显示窗口
						var htmlStr = "";
						$.each(data.retData,function (index,obj) {
							htmlStr+="<tr id=\"remove_"+obj.id+"\">";
							htmlStr+="<td>"+obj.name+"</td>";
							htmlStr+="<td>"+obj.startDate+"</td>";
							htmlStr+="<td>"+obj.endDate+"</td>";
							htmlStr+="<td>"+obj.owner+"</td>";
							htmlStr+="<td><a name=\"removeClueActivityRelation\" href=\"javascript:void(0);\" activityId=\""+obj.id+"\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
							htmlStr+="</tr>";
						});
						//追加
						$("#showClueActivityRelationTbody").append(htmlStr);
					}
				}
			});
		});

		//给动态生成的“解除线索关联市场活动的图标”添加单击事件，使用jQuery的on函数
		$("#showClueActivityRelationTbody").on("click","a[name='removeClueActivityRelation']",function(){
			//收集参数
			var clueId = '${clue.id}';
			var activityId = $(this).attr("activityId");
			//用户确认删除
			if(window.confirm("确认解除关联吗？")){
				//发送请求
				$.ajax({
					url:"workbench/clue/removeClueActivityRelation.do",
					type:"post",
					dataType:"json",
					data:{
						clueId:clueId,
						activityId:activityId
					},
					success:function(data){
						if(data.code == "0"){
							alert(data.message);
						}else{
							//解除成功，清空tr
							$("#remove_"+activityId).remove();
						}
					}
				});
			}
		});

		//用户在线索明细窗口点击“转换”图标
		$("#convertBtn").click(function(){
			//同步请求,使用地址栏的方法
			window.location.href="workbench/clue/convert.do?id=${clue.id}";
		});
	});
	
</script>

</head>
<body>
<!-- 修改线索备注的模态窗口 -->
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

<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
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
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="checkAllActivity" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="clueActivityRelationTbody">
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
					<button id="saveBundClueActivityBtn" type="button" class="btn btn-primary">关联</button>
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
			<h3>${clue.fullName}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="convertBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullName}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="clueRemarkDiv" style="position: relative; top: 40px; left: 40px;">
		<div id="beforeRemarkDiv" class="page-header">
			<h4>备注</h4>
		</div>
		<c:forEach items="${remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${remark.editFlag=='0'?remark.createTime:remark.editTime} 由${remark.editFlag=='0'?remark.createBy:remark.editBy}${remark.editFlag=='0'?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a name="editA" remarkId="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a name="deleteA" remarkId="${remark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="clueRemark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateClueRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="showClueActivityRelationTbody">
					<c:forEach items="${activityList}" var="activity">
						<tr id="remove_${activity.id}">
							<td>${activity.name}</td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a name="removeClueActivityRelation" activityId="${activity.id}" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
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