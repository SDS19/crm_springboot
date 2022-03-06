<%@ page import="com.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<% 
	List<DicValue> stageList = (List<DicValue>) application.getAttribute("stage");
	Map<String,String> s2pMap = (Map<String, String>) application.getAttribute("s2pMap");//01-10, ... ,07-100
	int index = 0;
	for (int i = 0; i < stageList.size(); i++) {//find boundary index
		String stage = stageList.get(i).getValue().substring(0,2);
		String possibility = s2pMap.get(stage);
		if ("0".equals(possibility)) {
			index = i;
			break;
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=base%>">
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

	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				$("#remarkDiv").css("height","130px");
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			$("#cancelAndSaveBtn").hide();
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		//stage prompt
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

		tranRemarkList();

		tranHistoryList();

	});
	
	function tranRemarkList() {
		$.ajax({
			url: "transaction/remark",
			data:{	"tranId":"${tran.id}" },
			type: "get",
			dataType: "json",
			success: function (data) {
				var html = "";
				$.each(data,function (i,obj) {
					html += '<div class="remarkDiv" style="height: 60px;">'
							+'<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
							+'<div style="position: relative; top: -40px; left: 40px;" >'
							+'<h5>'+obj.noteContent+'</h5>'
							+'<font color="gray">Transaction</font>'
							+'<font color="gray">-</font> <b>${tran.customerId} - ${tran.name}</b>'
							+'<small style="color: gray;"> '+(obj.editFlag==0 ? obj.createTime : obj.editTime)+' by '+(obj.editFlag==0 ? obj.createBy : obj.editBy)+'</small>'
							+'<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
							+'<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>'
							+'&nbsp;&nbsp;&nbsp;&nbsp;'
							+'<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>'
							+'</div></div></div>';
				})
				$("#tranHistoryTable").html(html);
			}
		})
	}
	
	function tranHistoryList() {
		$.ajax({
			url: "transaction/history",
			data:{	"tranId":"${tran.id}" },
			type: "get",
			dataType: "json",
			success: function (data) {
				var html = "";
				$.each(data,function (i,obj) {
					html += "<tr><td>"+obj.stage+"</td>"
							+"<td>"+obj.money+"</td>"
							+"<td>"+obj.possibility+"</td>"
							+"<td>"+obj.expectedDate+"</td>"
							+"<td>"+obj.createTime+"</td>"
							+"<td>"+obj.createBy+"</td></tr>";
				})
				$("#tranHistoryTable").html(html);
			}
		})
	}

	function changeStage(stage,i) {
		if (confirm("Are you sure to change the stage?")) {
			$.ajax({
				url: "transaction/stage",
				data:{
					"id":"${tran.id}",
					"stage":stage,
					"money":"${tran.money}",//tranHistory
					"expectedDate":"${tran.expectedDate}"//tranHistory
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data!=null) {
						$("#stage").html(data.stage);
						$("#possibility").html(data.possibility);
						$("#editBy").html(data.editBy+"&nbsp;&nbsp;");
						$("#editTime").html(data.editTime);
						changeIcon(stage,i);
					} else alert("Stage change failed!");
				}
			})
		}
	}

	function changeIcon(stage,idx) {
		var currentPossibility = $("#possibility").html();
		var index = idx;//stage index
		var point = "<%=index%>";
		if (currentPossibility=="0") {
			for (var i=0;i<point;i++) {//black O
				$("#"+i).removeClass();//remove old class
				$("#"+i).addClass("glyphicon glyphicon-record mystage");//add new class
				$("#"+i).css("color","#000000");//change color
			}
			for (var i=point;i<<%=stageList.size()%>;i++) {
				if (i==index) { //current stage (red X)
					$("#"+i).removeClass();
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					$("#"+i).css("color","#FF0000");
				} else { //black X
					$("#"+i).removeClass();
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					$("#"+i).css("color","#000000");
				}
			}
		} else {
			for (var i=0;i<point;i++) {
				if (i==index) {//current stage (green V)
					$("#"+i).removeClass();
					$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
					$("#"+i).css("color","#90F790");
				} else if (i<index) {//before current stage (green O)
					$("#"+i).removeClass();
					$("#"+i).addClass("glyphicon glyphicon-record mystage");
					$("#"+i).css("color","#90F790");
				} else {//after current stage (black O)
					$("#"+i).removeClass();//remove old class
					$("#"+i).addClass("glyphicon glyphicon-record mystage");//add new class
					$("#"+i).css("color","#000000");//change color
				}
			}
			for (var i=point;i<<%=stageList.size()%>;i++) {//black X
				$("#"+i).removeClass();
				$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				$("#"+i).css("color","#000000");
			}
		}
		tranHistoryList();
	}

</script>

</head>
<body>
	
	<!-- back back -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- titel -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${tran.customerId}-${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-edit"></span> Edit</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> Delete</button>
		</div>
	</div>

	<!-- stage -->
	<div style="position: relative; left: 40px; top: -50px;">
		Stage&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%
			//current stage and possibility
			Tran tran = (Tran) request.getAttribute("tran");
			String currentStage = tran.getStage().substring(0,2);//01 ... ...
			String currentPossibility = tran.getPossibility();
			if ("0".equals(currentPossibility)) {// 7 black X
				//compare every stage with current stage
				for (int i = 0; i < stageList.size(); i++) {
					DicValue dicValue = stageList.get(i);//dicValue = {id,value,text,orderNo,typeCode}
					String stage = dicValue.getValue();
					String possibility = s2pMap.get(stage);
					if ("0".equals(possibility)) {
						if (currentStage.equals(stage)) {//red X
		%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
			  class="glyphicon glyphicon-remove mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=dicValue.getText()%>" style="color: #FF0000;"></span>
		-----------
		<%				} else {//black X	%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
			  class="glyphicon glyphicon-remove mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
		-----------
		<%				}
					} else {//black O %>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
			  class="glyphicon glyphicon-record mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
		-----------
		<%			}
				}
			} else { //current stage possibility is not 0
				//get index of current stage
				for (int i = 0; i < stageList.size(); i++) {
					String stage = stageList.get(i).getValue();
					if (currentStage.equals(stage)) {
						index = i;
						break;
					}
				}
				for (int i = 0; i < stageList.size(); i++) {
					DicValue dicValue = stageList.get(i);
					String stage = dicValue.getValue();
					String possibility = s2pMap.get(stage);
					if ("0".equals(possibility)) {//black X
		%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
			  class="glyphicon glyphicon-remove mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
		-----------
		<%			} else {
						if (index==i) {//current stage (green V)
		%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
			  class="glyphicon glyphicon-map-marker mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=dicValue.getText()%>" style="color: #90F790;"></span>
		-----------
		<%				} else if (i<index) {//before current stage (green O) %>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
			  class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=dicValue.getText()%>" style="color: #90F790;"></span>
		-----------
		<%				} else {//after current stage (black O)	%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
			  class="glyphicon glyphicon-record mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
		-----------
		<%
						}
					}
				}


			}
		%>
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
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-----------
		<span class="closingDate">2010-10-10</span>--%>
	</div>
	
	<!-- detail -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">Owner</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Money</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">Name</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Expected Date</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">Customer Name</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Stage</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${tran.stage}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">Type</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Possibility</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${tran.possibility}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">Source</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Activity Source</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">Contacts Name</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">Created By</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">Edit By</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${tran.editBy}&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">Description</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">Contact Summary</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${tran.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">Next Contact Time</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${tran.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- Remark -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>Remark</h4>
		</div>
		
		<!-- remark1 -->
		<div id="tranRemark">

		</div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- Stage History -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>Transaction History</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>Stage</td>
							<td>Money</td>
							<td>Possibility</td>
							<td>Expected Date</td>
							<td>Create Time</td>
							<td>Create By</td>
						</tr>
					</thead>
					<tbody id="tranHistoryTable">
						<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>

					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>