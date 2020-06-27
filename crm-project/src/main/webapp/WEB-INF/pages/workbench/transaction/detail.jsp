<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

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

		});*/
		//给动态生成的元素添加事件需要使用on函数
		$("#tranRemarkDiv").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});


		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#tranRemarkDiv").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});
		
		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#tranRemarkDiv").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		});
		
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#tranRemarkDiv").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		//给保存备注按钮添加单击事件
		$("#saveTranRemarkBtn").click(function(){
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var tranId = '${tran.id}';
			//表单验证
			if(tranRemark == ""){
				alert("备注内容不能为空");
				return;
			}
			//发送请求
			$.ajax({
				url:"workbench/transaction/saveCreateTranRemark.do",
				type:"post",
				dataType:"json",
				data:{
					noteContent:noteContent,
					tranId:tranId,
				},
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
					}else{
						//刷新列表
						var htmStr = "";
						htmStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						htmStr+="<img title=\"${tran.owner}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmStr+="<h5>"+data.retData.noteContent+"</h5>";
						htmStr+="<font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>${tran.customerId}-${tran.name}</b> <small style=\"color: gray;\"> "+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmStr+="<a name=\"editA\" remarkId=\""+data.retData.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmStr+="<a name=\"deleteA\" remarkId=\""+data.retData.id+"\" class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmStr+="</div>";
						htmStr+="</div>";
						htmStr+="</div>";

						//清空文本框
						$("#remark").val("");
						//追加到外部元素的后面
						$("#tranRemark").after(htmStr);
						//隐藏按钮
						$("#cancelAndSaveBtn").hide();
						cancelAndSaveBtnDefault = true;
					}
				}
			});
		});

		//给删备注图标添加单击事件，因为是动态生成的元素，使用on函数
		$("#tranRemarkDiv").on("click","a[name='deleteA']",function(){
			//收集参数
			var id = $(this).attr("remarkId");
			//发送请求
			$.ajax({
				url:"workbench/transaction/deleteTranRemarkById.do",
				type:"post",
				dataType:"json",
				data:{
					id:id
				},
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
					}else{
						//清除div
						$("#div_"+id).remove();
					}
				}
			});
		});

		//给修改备注图标添加单击事件，因为是动态生成的元素使用on函数
		$("#tranRemarkDiv").on("click","a[name='editA']",function(){
			//收集参数，id设值到隐藏域，noteContent设值到文本框
			var id=$(this).attr("remarkId");
			var noteContent = $("#div_"+id+" h5").text();
			//设值
			$("#edit-id").val(id);
			$("#edit-noteContent").val(noteContent);
			//显示修改客户备注的模态窗口
			$("#editRemarkModal").modal("show");
		});

		//给更新备注按钮添加单击事件
		$("#updateRemarkBtn").click(function(){
			//收集参数
			var id = $("#edit-id").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			//表单验证
			if(noteContent == ""){
				alert("备注不能为空");
				return;
			}
			//发送请求
			$.ajax({
				url:"workbench/transaction/saveEditTranRemark.do",
				type:"post",
				dataType:"json",
				data:{
					id:id,
					noteContent:noteContent,
				},
				success:function(data){
					if(data.code=="0"){
						alert(data.message);
						//显示修改备注的模态窗口
						$("#editRemarkModal").modal("show");
					}else{
						//关闭修改备注的模态窗口
						$("#editRemarkModal").modal("hide");
						//跟新备注内容
						$("#div_"+id+" h5").text(noteContent);
						$("#div_"+id+" small").text(" "+data.retData.editTime+" 由${sessionScope.sessionUser.name}修改");
					}
				}
			});
		});
	});
	
	
	
</script>

</head>
<body>
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
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${tran.customerId}-${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-thumbs-up mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<c:forEach items="${stageList}" var="stage" varStatus="vs">
			<%--倒数第一个图标是固定的--%>
			<c:if test="${vs.count==fn:length(stageList)||vs.count==fn:length(stageList)-1}">
				<%--如果是失败阶段颜色变红--%>
				<c:if test="${stage.value == tran.stage}">
					<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" style="color: red" data-content="${stage.value}"></span>
					-------------
				</c:if>
				<%--如果不是失败阶段，颜色不变--%>
				<c:if test="${stage.value != tran.stage }">
					<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
					-------------
				</c:if>
			</c:if>
			<%--倒数第三个图标也是固定的--%>
			<c:if test="${vs.count == fn:length(stageList)-2}">
				<%--如果是成功阶段，颜色变绿--%>
				<c:if test="${stage.value==tran.stage}">
					<span class="glyphicon glyphicon-thumbs-up mystage" data-toggle="popover" data-placement="bottom" style="color: #90F790;" data-content="${stage.value}"></span>
					-----------
				</c:if>
				<%--如果不是成功阶段，颜色不变--%>
				<c:if test="${stage.value!=tran.stage}">
					<span class="glyphicon glyphicon-thumbs-up mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
					-----------
				</c:if>
			</c:if>
			<%--如果是普通业务相关的阶段，图标是从倒数第四个开始的--%>
			<c:if test="${vs.count <= fn:length(stageList)-3}">
				<%--还需要考虑当前交易是不是处于失败阶段，如果是，交易曾经经过哪些阶段，到成功之前的那个A阶段颜色变黄，在A阶段之后的颜色不变，A阶段之前颜色变绿--%>
				<%--这个交易不是失败的交易--%>
				<c:if test="${tran.orderNo<stageList[fn:length(stageList)-2].orderNo}">
					<%--在当前交易阶段之前的全部变绿--%>
					<c:if test="${stage.orderNo<tran.orderNo}">
						<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
						-----------
					</c:if>
					<%--在当前交易阶段之后的全部不变--%>
					<c:if test="${stage.orderNo>tran.orderNo}">
						<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
						-----------
					</c:if>
					<%--在当前阶段的变成地图图标--%>
					<c:if test="${stage.orderNo==tran.orderNo}">
						<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
						-----------
					</c:if>
				</c:if>
				<%--这个交易是失败的交易--%>
				<c:if test="${tran.orderNo>stageList[fn:length(stageList)-3].orderNo}">
					<%--需要获取到这个阶段曾经到达的位置，前端不好判断，只能后端获取--%>
					<%--在曾经到达过之前的阶段颜色变绿--%>
					<c:if test="${stage.orderNo<theOrderNo}">
						<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
						-----------
					</c:if>
					<%--曾经到达过的阶段颜色变黄--%>
					<c:if test="${stage.orderNo==theOrderNo}">
						<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: yellow;"></span>
						-----------
					</c:if>
					<%--在曾经到达过的阶段之后的，颜色不变--%>
					<c:if test="${stage.orderNo>theOrderNo}">
						<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
						-----------
					</c:if>
				</c:if>

			</c:if>
		</c:forEach>
		<span class="closingDate">${tran.expectedDate}</span>
	</div>

	<!-- 详细信息 -->
	<div  style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}-${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}单</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>

	<!-- 备注 -->
	<div id="tranRemarkDiv" style="position: relative; top: 100px; left: 40px;">
		<div  id="tranRemark" class="page-header">
			<h4>备注</h4>
		</div>
		<c:forEach items="${tranRemarkList}" var="tranRemark">
			<div id="div_${tranRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${tran.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${tranRemark.noteContent}</h5>
					<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.customerId}-${tran.name}</b> <small style="color: gray;"> ${tranRemark.editFlag=='0'?tranRemark.createTime:tranRemark.editTime} 由${tranRemark.editFlag=='0'?tranRemark.createBy:tranRemark.editBy}${tranRemark.editFlag=='0'?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a name="editA" remarkId="${tranRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a name="deleteA" remarkId="${tranRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
					<button id="saveTranRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预期成交日期</td>
							<td>创建人</td>
							<td>创建时间</td>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${tranHistoryList}" var="tranHistory">
						<tr>
							<td>${tranHistory.stage}</td>
							<td>${tranHistory.money}</td>
							<td>${tranHistory.expectedDate}</td>
							<td>${tranHistory.createBy}</td>
							<td>${tranHistory.createTime}</td>
						</tr>
					</c:forEach>
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>