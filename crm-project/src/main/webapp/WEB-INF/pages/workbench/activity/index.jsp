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
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">
        $(function () {
            //给创建按钮添加单击事件
            $("#createActivityBtn").click(function () {
                //重置表单中的信息
                $("#createActivityForm")[0].reset();
                //显示模态窗口
                $("#createActivityModal").modal("show");
            })

            //给保存添加单击事件
            $("#saveActivity").click(function () {
                //收集参数
                var owner = $("#create-activityOwner").val();
                var name = $.trim($("#create-activityName").val());
                var startDate = $.trim($("#create-startDate").val());
                var endDate = $.trim($("#create-endDate").val());
                var cost = $.trim($("#create-cost").val());
                var description = $.trim($("#create-description").val());

                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }

                //js语法是弱类型的语法，可以直接比较字符串的大小
                if (startDate != "" && endDate != "") {
                    if (startDate > endDate) {
                        alert("结束日期不能比开始日期小");
                        return;
                    }
                }
                //成本只能为非负整数,使用正则表达式,不为空才验证
                if(cost != ""){
                    var regExp = /^(([1-9]\d*)|0)$/;
                    if (!regExp.test(cost)) {
                        alert("成本只能为非负整数");
                        return;
                    }
                }

                //发送ajax请求
                $.ajax({
                    url: "workbench/activity/saveCreateActivity.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description,
                    },
                    success: function (data) {
                        if (data.code == "1") {
                            window.location.href = "workbench/activity/index.do";
                            //关闭模块窗口
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert(data.message);
                            //显示模块窗口
                            $("#createActivityModal").modal("show");
                        }
                    }
                })
            });

            //当容器加载完毕，调用工具函数,给创建市场活动使用日期插件
            $(".mydate").datetimepicker({
                language: 'zh-CN',//语言
                format: "yyyy-mm-dd",//日期格式
                minView: "month",//日期选择器上最小能显示日期的视图
                initialDate: new Date(),//日期的初始化显示日期
                autoclose: true,//选择日期之后自动关闭日历
                todayBtn: true,//显示当前日期的按钮
                clearBtn: true,//显示清空日期的按钮
                container: "#createActivityModal",//在创建的模态窗口上显示日历
            });

            //给查询市场活动添加日期插件
            $(".queryDate").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                minView: 'month',
                initialDate: new Date(),
                autoclose: true,
                todayBtn: true,
                clearBtn: true,
                container: ".queryActivityModal",
            });

            //页面加载完成，查询市场活动，默认显示第一页，显示10条记录
            queryActivityForPageByCondition(1, 10);
            //给查询按钮添加单击事件
            $("#queryActivityBtn").click(function () {
                //按照条件查询，默认显示第一页，显示记录条数为用户上次设置的显示条数使用函数
                queryActivityForPageByCondition(1, $("#activity_pag").bs_pagination('getOption', 'rowsPerPage'));
            })


            //给修改市场活动添加日期插件
            $(".editDate").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                minView: 'month',
                initialDate: new Date(),
                autoclose: true,
                todayBtn: true,
                clearBtn: true,
                container: "#editActivityModal",
            });
            //给“修改”按钮添加单击事件
            $("#editActivityBtn").click(function () {
                //收集参数
                var checkId = $("#query-activity input[type='checkbox']:checked");
                //表单验证
                if (checkId.size() == 0) {
                    alert("请选择要修改的记录");
                    return;
                }
                if (checkId.size() > 1) {
                    alert("一次只能选择修改一条记录");
                    return;
                }
                var id = checkId[0].value;
                //发送请求tbl_activity_remark
                $.ajax({
                    url: "workbench/activity/editActivity.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id
                    },
                    success: function (data) {
                        //alert(data.name);
                        //手动显示模态窗口
                        $("#editActivityModal").modal("show");
                        //显示市场活动信息
                        $("#edit-id").val(data.id);
                        $("#edit-marketActivityOwner").val(data.owner);
                        $("#edit-marketActivityName").val(data.name);
                        $("#edit-startDate").val(data.startDate);
                        $("#edit-endDate").val(data.endDate);
                        $("#edit-cost").val(data.cost);
                        $("#edit-description").val(data.description);
                    }
                })
            });

            //给“更新”按钮添加单击事件
            $("#saveEditActivityBtn").click(function () {
                //收集数据
                var id = $("#edit-id").val();
                var owner = $("#edit-marketActivityOwner").val();
                var name = $.trim($("#edit-marketActivityName").val());
                var startDate = $("#edit-startDate").val();
                var endDate = $("#edit-endDate").val();
                var cost = $.trim($("#edit-cost").val());
                var description = $("#edit-description").val();

                //表单验证
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (startDate > endDate) {
                    alert("开始日期不能大于结束日期");
                    return;
                }
                var regExp = /^(([1-9]\d*)|0)$/;
                if (!regExp.test(cost)) {
                    alert("成本只能为非负整数");
                    return;
                }
                //发送请求
                $.ajax({
                    url: "workbench/activity/saveEditActivity.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description,
                    },
                    success: function (data) {
                        if (data.code == "1") {
                            //返回到市场活动主界面，同时当前页数和每页显示条数应该不变
                            queryActivityForPageByCondition($("#activity_pag").bs_pagination("getOption", "currentPage"), $("#activity_pag").bs_pagination("getOption", "rowsPerPage"));
                            //关闭修改市场活动的模态窗口
                            $("#editActivityModal").modal("hide");
                        } else {
                            //提示信息
                            alert(data.message);
                            //显示修改市场活动的模态窗口
                            $("#editActivityModal").modal("show");
                        }
                    }
                })
            });

            //给“删除”按钮添加单击事件
            $("#deleteActivityBtn").click(function () {
                //收集参数
                var checkIds = $("#query-activity input[type='checkbox']:checked");
                //验证
                if (checkIds.size() == 0) {
                    alert("请选择要删除的市场活动");
                    return;
                }
                //遍历数组
                var idStr = ""
                $.each(checkIds, function () {
                    idStr += "id=" + this.value + "&";
                });
                //去掉最后一个“&”
                idStr = idStr.substr(0, idStr.length - 1);
                //让用户选择是否删除
                if (window.confirm("确定删除吗？")) {
                    //发送请求
                    $.ajax({
                        url: "workbench/activity/deleteActivityByIds.do",
                        type: "post",
                        dataType: "json",
                        data: idStr,
                        success: function (data) {
                            if (data.code == "1") {
                                //显示第一页，每页显示条数不变
                                queryActivityForPageByCondition(1, $("#activity_pag").bs_pagination("getOption", "rowsPerPage"));
                            } else {
                                alert(data.message);
                            }
                        }
                    })
                }
            });

            //给"批量导出"按钮添加单击事件
            $("#exportActivityAllBtn").click(function () {
                //发送同步请求
                window.location.href = "workbench/activity/exportAllActivity.do";
            });
            //给"选择导出"按钮添加单击事件
            $("#exportActivityXzBtn").click(function () {
                //收集参数
                var checkIds = $("#query-activity input[type='checkbox']:checked");
                //表单验证
                if (checkIds.size() == 0) {
                    alert("请选择要导出的市场活动");
                    return;
                }
                //遍历数组
                var ids = "";
                $.each(checkIds, function () {
                    ids += "id=" + this.value + "&";
                })
                //截取字符串
                ids = ids.substr(0, ids.length - 1);
                //发送同步请求
                window.location.href = "workbench/activity/exportActivitySelective.do?" + ids;
            });

            //给“上传列表数据（导入）”按钮添加单击事件
            $("#importActivityListBtn").click(function () {
                //手动显示导入文件的模态窗口
                $("#importActivityModal").modal("show");
            });
            //给“导入”按钮添加单击事件
            $("#importActivityBtn").click(function () {
                //收集参数
                //alert($("#activityFile").val());
                var fileName = $("#activityFile").val();
                //取文件名的后缀,因为文件的后缀不区分大小写，为了方便验证，全部变成大写验证
                var suffix = fileName.substr(fileName.lastIndexOf(".") + 1).toUpperCase();
                //alert(suffix);
                if (suffix == "XLS" || suffix == "XLSX") {
                    //获取file文件
                    //alert($("#activityFile")[0].files[0]);
                    var activityFile = $("#activityFile")[0].files[0];
                    //表单验证
                    //alert(activityFile.size);字节数
                    if(activityFile.size > 5*1024*1024 ){
                        alert("请确认您的文件大小不超过5MB");
                        return;
                    }
                    //第三种传送数据的方式，使用formdata对象
                    var formData = new FormData();
                    formData.append("activityFile",activityFile);
                    //发送请求
                    $.ajax({
                        url:"workbench/activity/importActivity.do",
                        type:"post",
                        data:formData,
                        dataType:"json",
                        processData:false,//默认浏览器使用的是字符串的方式传送数据
                        contentType:false,//默认采用的是urlencoded方式传送数据，这种编码只对文本数据有效
                        success:function(data){
                            if(data.code == "1"){
                                alert("成功上传"+data.count+"记录");
                                //手动关闭模态窗口
                                $("#importActivityModal").modal("hide");
                                //刷新市场活动，显示主页面第1页，显示记录条数不变
                                queryActivityForPageByCondition(1,$("#activity_pag").bs_pagination("getOption","rowsPerPage"))
                            }else{
                                alert(data.message);
                                //显示模态窗口
                                $("#importActivityModal").modal("show");
                            }
                        }
                    });
                } else {
                    alert("只支持上传excel格式文件");
                    return;
                }

            });

            //全选和取消全选
            //给“全选”按钮添加单击事件
            $("#checkAllActivity").click(function () {
                //所有的子复选框checked属性值和全选的保持一致
                $("#query-activity input[type='checkbox']").prop("checked", this.checked);
            });
            //给所有的子复选框添加单击事件，放在这里就是动态元素了，不可以直接添加事件函数，需要使用父选择器
            $("#query-activity").on("click","input[type='checkbox']",function () {
                //通过判断所有复选框的个数和选中复选框的个数来设置“全选”的checkbox值
                if ($("#query-activity input[type='checkbox']").size() == $("#query-activity input[type='checkbox']:checked").size()) {
                    $("#checkAllActivity").prop("checked", true);
                } else {
                    $("#checkAllActivity").prop("checked", false);
                }
            });
        });

        //方法可以定义在页面加载完毕的方法外面，因为方法声明会先执行,调用会执行。
        function queryActivityForPageByCondition(pageNo, pageSize) {
            //页面跳转时，子复选框全都默认不选了，但是“全选”的状态还在，需要在页面跳转这里设置初始化为false
            $("#checkAllActivity").prop("checked", false);
            //收集参数
            //var pageNo = 1;
            //var pageSize = 10;
            var name = $("#query-name").val();
            var owner = $("#query-owner").val();
            var startDate = $("#query-startDate").val();
            var endDate = $("#query-endDate").val();
            //发送请求
            $.ajax({
                url: "workbench/activity/queryActivityForPageByCondition.do",
                type: "post",
                dataType: "json",
                data: {
                    pageNo: pageNo,
                    pageSize: pageSize,
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate
                },
                success: function (data) {
                    //拼接字符串
                    var htmlStr = "";
                    $.each(data.activityList, function (index, obj) {
                        //隔行换色
                        if(index%2==0){
                            htmlStr+="<tr>";
                        }else{
                            htmlStr+="<tr class=\"active\">";
                        }
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\"onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"'\">" + obj.name + "</a></td>";
                        htmlStr += "<td>" + obj.owner + "</td>";
                        htmlStr += "<td>" + obj.startDate + "</td>";
                        htmlStr += "<td > " + obj.endDate + " </td></tr>"
                    });
                    $("#query-activity").html(htmlStr);

                    //查询结果之后使用分页插件，因为分页是和业务数据一起的
                    //计算总页数，记住：js中整数除以整数和java不一样，js为小数
                    var totalPages = 1;
                    if (data.totalRows % pageSize == 0) {
                        totalPages = data.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(data.totalRows / pageSize) + 1;
                    }
                    $("#activity_pag").bs_pagination({
                        currentPage: pageNo,//显示当前页
                        rowsPerPage: pageSize,//每页显示条数
                        totalRows: data.totalRows,//总记录条数
                        totalPages: totalPages,//总页数
                        visiblePageLinks: 5,//显示翻页卡片数
                        showGoToPage: true,//显示跳转到第几页
                        showRowsPerPage: true,//显示每页显示条数
                        showRowsInfo: true,//显示记录的信息
                        //每次切换页面会执行此函数，可以返回当前页和总记录条数
                        onChangePage: function (e, pageObj) {
                            //alert(pageObj.currentPage+pageObj.rowsPerPage);
                            //递归，但是不是死循环，因为页面改变才会执行，有限定条件
                            queryActivityForPageByCondition(pageObj.currentPage, pageObj.rowsPerPage);

                        }
                    });
                }
            });
        }
    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="createActivityForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-activityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-activityOwner">
                                <option></option>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-activityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-activityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveActivity">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <%--设置隐藏域，保存市场活动的id--%>
                <input type="hidden" id="edit-id"/>
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label ">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control editDate" id="edit-startDate" value="2020-10-10">
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control editDate" id="edit-endDate" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveEditActivityBtn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS/XLSX的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar queryActivityModal" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner"/>
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon ">开始日期</div>
                        <input class="form-control queryDate" type="text" id="query-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon ">结束日期</div>
                        <input class="form-control queryDate" type="text" id="query-endDate" readonly>
                    </div>
                </div>
                <%--submit是w3c规定提交表单的，会导致页面全部刷新，需改成button--%>
                <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createActivityBtn" type="button" class="btn btn-primary"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editActivityBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteActivityBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="importActivityListBtn" type="button" class="btn btn-default">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAllActivity"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="query-activity">
                <%-- <tr class="active">
                     <td><input type="checkbox"/></td>
                     <td><a style="text-decoration: none; cursor: pointer;"
                            onclick="window.location.href='detail.jsp';">$</a></td>
                     <td>zhangsan</td>
                     <td>2020-10-10</td>
                     <td>2020-10-20</td>
                 </tr>
                 <tr class="active">
                     <td><input type="checkbox"/></td>
                     <td><a style="text-decoration: none; cursor: pointer;"
                            onclick="window.location.href='detail.jsp';">发传单</a></td>
                     <td>zhangsan</td>
                     <td>2020-10-10</td>
                     <td>2020-10-20</td>
                 </tr>--%>
                </tbody>

            </table>
            <div id="activity_pag"></div>
        </div>

        <%--  <div style="height: 50px; position: relative;top: 30px;">
              <div>
                  <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows">50</b>条记录
                  </button>
              </div>
              <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                  <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                  <div class="btn-group">
                      <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                          10
                          <span class="caret" id="pageSize"></span>
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
          </div>
      </div>
  </div>--%>
</body>
</html>