<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<html>
<head>
    <base href="<%=base%>">
    <title>Title</title>
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>
    <script>
        $(function () {
            charts();
        })
        function charts() {
            var myChart = echarts.init(document.getElementById('main'));
            $.ajax({
                url: "transaction/chart",
                type: "get",
                dataType: "json",
                success: function (data) {
                    option = {
                        title: {
                            text: 'Transaction Funnel',
                            subtext: 'Number of Transaction Stages '
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b} : {c}%'
                        },
                        /* toolbox: {
                             feature: {
                                 dataView: { readOnly: false },
                                 restore: {},
                                 saveAsImage: {}
                             }
                         },
                        legend: {
                            data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
                        },*/
                        series: [
                            {
                                name: 'Transaction Funnel',
                                type: 'funnel',
                                left: '10%',
                                top: 60,
                                bottom: 60,
                                width: '80%',
                                min: 0,
                                max: data.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data.dataList
                                /*[
                                    { value: 60, name: 'Visit' },
                                    { value: 40, name: 'Inquiry' },
                                    { value: 20, name: 'Order' },
                                    { value: 80, name: 'Click' },
                                    { value: 100, name: 'Show' }
                                ]*/
                            }
                        ]
                    };
                    myChart.setOption(option);
                }
            })
        }
    </script>
</head>
<body>
    <div id="main" style="width: 800px;height:600px;"></div>
</body>
</html>
