<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<base href="<%=base%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript">
		$(function(){

			$("#checkAll").click(function () {
				$("input[name=check]").prop("checked",this.checked);
			})
			$("#tbody-trans").on("click",$("input[name=check]"),function () {
				$("#checkAll").prop("checked",$("input[name=check]").length==$("input[name=check]:checked").length);
			})

			$("#queryBtn").click(function () {
				$("#hid-owner").val($.trim($("#owner").val()));
				$("#hid-name").val($.trim($("#name").val()));
				$("#hid-customerId").val($.trim($("#customerId").val()));
				$("#hid-stage").val($.trim($("#stage").val()));
				$("#hid-type").val($.trim($("#type").val()));
				$("#hid-source").val($.trim($("#source").val()));
				$("#hid-contactsId").val($.trim($("#contactsId").val()));
				transactionList(1,3);
			});

			transactionList(1,3);


		});

		function transactionList(pageNo,pageSize) {
			$("#checkAll").prop("checked",false);
			//get search condition form hidden field
			$("#owner").val($.trim($("#hid-owner").val()));
			$("#name").val($.trim($("#hid-name").val()));
			$("#customerId").val($.trim($("#hid-customerId").val()));
			$("#stage").val($.trim($("#hid-stage").val()));
			$("#type").val($.trim($("#hid-type").val()));
			$("#source").val($.trim($("#hid-source").val()));
			$("#contactsId").val($.trim($("#hid-contactsId").val()));
			$.ajax({
				url:"transaction/trans",
				data: {
					"pageNo":pageNo,
					"pageSize":pageSize,
					"owner":$.trim($("#owner").val()),
					"name":$.trim($("#name").val()),
					"customerId":$.trim($("#customerId").val()),
					"stage":$.trim($("#stage").val()),
					"type":$.trim($("#type").val()),
					"source":$.trim($("#source").val()),
					"contactsId":$.trim($("#contactsId").val()),
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					if (data!=null) {
						var html = "";
						$.each(data.dataList,function (i,obj) {
							html += "<tr><td><input name='check' type='checkbox' value='"+obj.id+"'/></td>"
									+"<td><a style='text-decoration: none; cursor: pointer;' onclick=window.location.href=\'transaction/detail?id="+obj.id+"\';>"+obj.name+"</a></td>"
									+"<td>"+obj.customerId+"</td>"
									+"<td>"+obj.stage+"</td>"
									+"<td>"+obj.type+"</td>"
									+"<td>"+obj.owner+"</td>"
									+"<td>"+obj.source+"</td>"
									+"<td>"+obj.contactsId+"</td></tr>";
						})
						$("#tbody-trans").html(html);
						var totalPages = data.total%pageSize==0 ? data.total/pageSize : Math.ceil(data.total/pageSize);
						//bootstrap pagination
						$("#tranPage").bs_pagination({
							currentPage: pageNo,
							rowsPerPage: pageSize,
							maxRowsPerPage: 20,
							totalPages: totalPages,
							totalRows: data.total,
							visiblePageLinks: 5,
							showGoToPage: true,
							showRowsPerPage: true,
							showRowsInfo: true,
							showRowsDefaultInfo: true,
							onChangePage : function(event, data){
								transactionList(data.currentPage , data.rowsPerPage);
							}
						});
					} else alert("Trans query failed!");
				}
			})
		}

	</script>
</head>
<body>
	<!-- hidden field for search condition -->
	<input type="hidden" id="hid-owner" />
	<input type="hidden" id="hid-name" />
	<input type="hidden" id="hid-customerId" />
	<input type="hidden" id="hid-stage" />
	<input type="hidden" id="hid-type" />
	<input type="hidden" id="hid-source" />
	<input type="hidden" id="hid-contactsId" />

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>Transaction List</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<!-- search condition -->
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Owner</div>
				      <input id="owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Name</div>
				      <input id="name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Customer</div>
				      <input id="customerId" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Stage</div>
					  <select id="stage" class="form-control">
						  <option></option>
						  <c:forEach items="${stage}" var="dicValue" >
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Type</div>
					  <select id="type" class="form-control">
					  	<option></option>
						  <c:forEach items="${transactionType}" var="dicValue" >
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Source</div>
				      <select id="source" class="form-control">
						  <option></option>
						  <c:forEach items="${source}" var="dicValue" >
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Contact</div>
				      <input id="contactsId" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryBtn" type="button" class="btn btn-default">Query</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='transaction/owner';"><span class="glyphicon glyphicon-plus"></span> Create</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> Update</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> Delete</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>name</td>
							<td>Customer Name</td>
							<td>Stage</td>
							<td>Type</td>
							<td>Owner</td>
							<td>Source</td>
							<td>Contact Name</td>
						</tr>
					</thead>
					<tbody id="tbody-trans">


					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage">
					<!-- bootstrap pagination -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>