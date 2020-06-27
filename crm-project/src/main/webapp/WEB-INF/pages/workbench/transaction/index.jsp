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
	<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		//给创建交易按钮添加单击事件
		$("#createTranBtn").click(function(){
			//页面跳转
			window.location.href="workbench/transaction/save.do";
		})
		//页面加载,完毕时，显示首页、每页显示10，
		queryTranByCondition(1,10);
		//给查询按钮添加单击事件,并且查询完毕之后显示首页，每页显示条数不变
		$("#queryTranBtn").click(function(){
			queryTranByCondition(1,$("#tranPage").bs_pagination("getOption","rowsPerPage"));
		});

		//给交易名称超链接添加单击事件
		$("#tranBody").on("click","a",function(){
			//收集参数
			var id = $(this).attr("tranId");
			//同步请求
			window.location.href="workbench/transaction/queryTranForDetail.do?id="+id;
		});

		//设置全选和取消全选
		//全选按钮是固有元素，使用事件函数
		$("#checkAllTran").click(function(){
			//所有的子元素的状态和全选按钮的状态保持一致
			$("#tranBody input[type='checkbox']").prop("checked",$("#checkAllTran").prop("checked"));
		})
		//给动态生成的子选择元素添加单击事件，使用on函数，
		$("#tranBody").on("click","input[type='checkbox']",function(){
			//通过判断所有的子元素的数组长度和已选择的子元素的数组长度决定全选按钮的状态
			if($("#tranBody input[type='checkbox']").size() == $("#tranBody input[type='checkbox']:checked").size()){
				$("#checkAllTran").prop("checked",true);
			}else{
				$("#checkAllTran").prop("checked",false);
			}
		});

		//给删除按钮添加单击事件
		$("#deleteTranBtn").click(function(){
			//收集参数
			var checkIds = $("#tranBody input[type='checkbox']:checked");
			if(checkIds.size()==0){
				alert("请选择要删除的交易");
				return;
			}
			//遍历数组
			var idStr = "";
			$.each(checkIds,function(){
				idStr+="id="+this.value+"&";
			})
			//截取字符串
			idStr = idStr.substr(0,idStr.length-1);
			//确认是否删除
			if(window.confirm("确认删除吗？")){
				//发送请求
				$.ajax({
					url:"workbench/transaction/deleteTranByIds.do",
					type:"post",
					dataType:"json",
					data:idStr,
					success:function(data){
						if(data.code == "0"){
							alert(data.message);
						}else{
							//显示首页，每页显示条数不变
							queryTranByCondition(1,$("#tranPage").bs_pagination("getOption","rowsPerPage"));
						}
					}
				});
			}

		});

		//给修改按钮添加单击事件
		$("#editTranBtn").click(function(){
			//收集参数
			var checkIds = $("#tranBody input[type='checkbox']:checked");
			if(checkIds.size() == 0){
				alert("请选择要修改的交易");
				return;
			}
			if(checkIds.size()>1){
				alert("每次只能修改一条记录");
				return;
			}
			//获取id
			var id = checkIds[0].value;
			//发送请求
			window.location.href="workbench/transaction/edit.do?id="+id;
		});
	});

	//创建分页查询函数
	function queryTranByCondition(pageNo,pageSize){
		//每分页一次，取消全选按钮
		$("#checkAllTran").prop("checked",false);
		//收集参数ownerName，customerName，tranName，stage，type，source，
		var ownerName = $.trim($("#queryOwnerName").val());
		var customerName = $.trim($("#queryCustomerName").val());
		var tranName = $.trim($("#queryTranName").val());
		var stage = $("#queryStage").val();
		var type = $("#queryType").val();
		var source = $("#querySource").val();

		//发送请求
		$.ajax({
			url:"workbench/transaction/queryTranForPageByCondition.do",
			type:"post",
			dataType:"json",
			data:{
				pageNo:pageNo,
				pageSize:pageSize,
				ownerName:ownerName,
				customerName:customerName,
				tranName:tranName,
				stage:stage,
				type:type,
				source:source
			},
			success:function(data){
				var htmlStr = "";
				//遍历结果拼接字符串
				$.each(data.tranList,function(index,obj){
				    //隔行换色
					if(index%2==0){
						htmlStr+="<tr>";
					}else{
						htmlStr+="<tr class=\"active\">";
					}

					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td><a tranId=\""+obj.id+"\" style=\"text-decoration: none; cursor: pointer;\">"+obj.customerId+"-"+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.customerId+"</td>";
					htmlStr+="<td>"+obj.stage+"</td>";
					htmlStr+="<td>"+obj.type+"</td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.source+"</td>";
					htmlStr+="<td>"+obj.contactsId+"</td>";
					htmlStr+="</tr>";
				});
				//刷新页面
				$("#tranBody").html(htmlStr);

				//计算总页数
				var totalPages = 0;
				if(data.totalRows%pageSize == 0){
					totalPages = data.totalRows/pageSize;
				}else{
					totalPages = parseInt(data.totalRows/pageSize)+1;
				}

				//因为分页是和数据相关的，需要和数据一起使用
				$("#tranPage").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					totalPages:totalPages,
					visiblePageLinks:5,
					showGotoPage:true,
					showRowsInfo:true,
					showRowsPerPage:true,
					onChangePage:function(e,pageObj){//递归，条件是页面改变执行该回调函数
						queryTranByCondition(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
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
				      <input id="queryOwnerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="queryTranName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="queryCustomerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="queryStage" class="form-control">
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
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="queryType" class="form-control">
					  	<option></option>
						  <c:forEach items="${transactionTypeList}" var="transactionType">
							  <option value="${transactionType.id}">${transactionType.value}</option>
						  </c:forEach>
					  	<%--<option>已有业务</option>
					  	<option>新业务</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select id="querySource" class="form-control" id="create-clueSource">
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
				      <div class="input-group-addon">联系人名称</div>
				      <input id="queryContactsName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryTranBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createTranBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editTranBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteTranBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAllTran" type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>--%>
                        <%--<tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="tranPage"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 20px;">
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