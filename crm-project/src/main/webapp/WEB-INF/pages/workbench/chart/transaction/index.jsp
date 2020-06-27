<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2020/6/11
  Time: 23:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <title>Title</title>
    <script src="jquery/jquery-1.11.1-min.js" type="text/javascript"></script>
    <script src="jquery/echarts/echarts.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function(){
            $.ajax({
                url:"workbench/chart/transaction/queryCountOfTranGroupByStage.do",
                dataType:"json",
                type:"post",
                success:function (data) {
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易统计图表',
                            subtext: '交易各阶段的统计数量'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}"
                        },

                        series: [
                            {
                                name: '',
                                type: 'funnel',
                                left: '10%',
                                width: '80%',
                                label: {
                                    formatter: '{b}'
                                },
                                labelLine: {
                                    show: true
                                },
                                itemStyle: {
                                    opacity: 0.8
                                },
                                emphasis: {
                                    label: {
                                        position: 'inside',
                                        formatter: '{b}数据量: {c}'
                                    }
                                },
                                data: data
                            },
                        ]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
                })

            });


    </script>
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>
</body>
</html>
