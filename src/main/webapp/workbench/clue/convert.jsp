<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<base href="<%=base%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">
	$(function(){

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$("#openSearchActivityModal").click(function () {
			$("#searchActivityModal").modal("show");
		})

		//attach keydown event handler function to the "search-activity" modal
		$("#search-activity").keydown(function (event) {
			if (event.keyCode==13) {
				$.ajax({
					url: "clue/transaction",
					data: { "name": $.trim($("#search-activity").val())	},
					type: "get",
					dataType: "json",
					success: function (data) {
						var html = "";
						$.each(data,function (i,obj) {
							html += "<tr><td><input name='id' value='"+obj.id+"' type='radio'/></td>"
									+"<td id='"+obj.id+"'>"+obj.name+"</td>"
									+"<td>"+obj.startDate+"</td>"
									+"<td>"+obj.endDate+"</td>"
									+"<td>"+obj.owner+"</td></tr>";
						})
						$("#searchActivityList").html(html);
					}
				})
				return false;
			}
		})

		//Attach click event handler function to the button to bind activity
		$("#bindActivityBtn").click(function () {
			var activityId = $("input[name=id]:checked").val();
			var activityName = $("#"+activityId).html();
			$("#activityId").val(activityId);
			$("#activityName").val(activityName);
			$("#searchActivityModal").modal("hide");			
		})

		//Attach click event handler function to the button to convert clue
		$("#convertBtn").click(function () {
			if ($("#isCreateTransaction").prop("checked")) $("#tranForm").submit();//create transaction or not
			else window.location.href = "clue/convert?clueId=${param.id}";//detail.jsp?id=$ {clue.id}...
		})

	});
</script>

</head>
<body>
	
	<!-- search activity modal -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Search Activity</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-activity" type="text" class="form-control" style="width: 300px;" placeholder="Please enter the activity name...">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>Name</td>
								<td>Start Date</td>
								<td>End Date</td>
								<td>Owner</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="searchActivityList">

						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
						<button id="bindActivityBtn" type="button" class="btn btn-primary">Bind</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>Clue convert <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		New Client：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		New Contact：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		Create transaction for client
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<!-- transaction form -->
		<form id="tranForm" action="clue/convert" method="post">
			<input type="hidden" name="clueId" value="${param.id}"/>
			<div class="form-group" style="width: 400px; position: relative; left: 20px;">
				<label for="amountOfMoney">Amount of Money</label>
				<input type="text" class="form-control" id="amountOfMoney" name="money">
			</div>
			<div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="tradeName">Trade Name</label>
				<input type="text" class="form-control" id="tradeName" name="name">
			</div>
			<div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="expectedClosingDate">Expected Date</label>
				<input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate" readonly />
			</div>
			<div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="stage">Stage</label>
				<select id="stage"  class="form-control" name="stage">
					<option></option>
					<c:forEach items="${stage}" var="dicValue" >
						<option value="${dicValue.value}">${dicValue.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="activityName">Activity Source&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
				<input type="text" class="form-control" id="activityName" name="source" placeholder="Search" readonly>
				<input type="hidden" id="activityId" name="activityId" />
			</div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		Owner：<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convertBtn" class="btn btn-primary" type="button" value="Convert">&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="Cancel" onclick="window.history.back();">
	</div>
</body>
</html>