<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>

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

			//date time picker
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//load activity list by default (pageNo:1, pageSize:5)
			pageList(1,3);

			//checkbox
			$("#checkAll").click(function () {
				$("input[name=check]").prop("checked",this.checked);
			})
			$("#tbody-activity").on("click",$("input[name=check]"),function () {
				$("#checkAll").prop("checked",$("input[name=check]").length==$("input[name=check]:checked").length);
			})

			//query
			$("#queryBtn").click(function () {
				//save the query condition into hidden field
				$("#hid-name").val($.trim($("#name").val()));
				$("#hid-owner").val($.trim($("#owner").val()));
				$("#hid-startDate").val($.trim($("#startDate").val()));
				$("#hid-endDate").val($.trim($("#endDate").val()));
				pageList(1,3);
			});

			//create
			$("#addBtn").click(function () {//get owner name
				$.ajax({
					url:"user/owner",
					type:"get",
					dataType:"json",
					success:function (data) {
						var html = "<option></option>";
						$.each(data,function (i,obj) {
							html += "<option value='"+obj.id+"'>"+obj.name+"</option>";
						})
						$("#create-owner").html(html);
						$("#create-owner").val("${user.id}");//set current user as default value
						$("#createActivityModal").modal("show");
					}
				})
			})
			$("#saveBtn").click(function () {
				create();
			})
			$(window).keydown(function (event) {
				if (event.keyCode==13) create();
			})

			//update
			$("#editBtn").click(function () {
				var $checked = $("input[name=check]:checked");
				if ($checked.length==0) {
					alert("None activity is selected!")
				}else if ($checked.length>1){
					alert("Only can update one activity a time!")
				}else {
					var id = "id="+$checked.val();
					$.ajax({
						url:"activity/edit",
						data: id,
						type:"get",
						dataType:"json",
						success:function (data) {
							var html = "<option></option>";
							$.each(data.list,function (i,obj) {
								html += "<option value='"+obj.id+"'>"+obj.name+"</option>";
							})
							$("#edit-owner").html(html);
							$("#edit-id").val(data.activity.id);
							$("#edit-name").val(data.activity.name);
							$("#edit-owner").val(data.activity.owner);
							$("#edit-startDate").val(data.activity.startDate);
							$("#edit-endDate").val(data.activity.endDate);
							$("#edit-cost").val(data.activity.cost);
							$("#edit-description").val(data.activity.description);
							$("#editActivityModal").modal("show");
						}
					})
				}
			})
			$("#updateBtn").click(function () {
				update();
			})
			$(window).keydown(function (event) {
				if (event.keyCode==13) update();
			})

			//delete
			$("#deleteBtn").click(function () {
				var checked = $("input[name=check]:checked");
				if (checked.length==0) {
					alert("None activities are selected!")
				}else {
					if (confirm("Are you sure to delete selected activities?")) {
						var params = "_=_";
						for (var i=0;i<checked.length;i++) {
							params += "&id="+checked[i].value;
							//if (i<checked.length-1) params += "&";
						}
						$.ajax({
							url:"activity/delete",
							data: params,
							type:"post",
							dataType:"json",
							success:function (data) {
								if (data=="1") pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
								else alert("Delete operation failed!");
							}
						})
					}
				}
			})

		});

		function pageList(pageNo,pageSize) {
			//empty checkbox
			$("#checkAll").prop("checked",false);
			//get query condition form hidden field and set the value to condition field
			$("#name").val($.trim($("#hid-name").val()));
			$("#owner").val($.trim($("#hid-owner").val()));
			$("#startDate").val($.trim($("#hid-startDate").val()));
			$("#endDate").val($.trim($("#hid-endDate").val()));
			$.ajax({
				url:"activity/activities",
				data: {
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#name").val()),
					"owner":$.trim($("#owner").val()),
					"startDate":$.trim($("#startDate").val()),
					"endDate":$.trim($("#endDate").val())
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					if (data!=null) {
						var html = "";
						$.each(data.dataList,function (i,obj) {
							html += "<tr class='active'><td><input name='check' type='checkbox' value='"+obj.id+"'/></td>"
									+"<td><a style='text-decoration: none; cursor: pointer;' onclick=window.location.href=\'activity/detail?id="+obj.id+"\';>"+obj.name+"</a></td>"
									+"<td>"+obj.owner+"</td>"
									+"<td>"+obj.startDate+"</td>"
									+"<td>"+obj.endDate+"</td></tr>";
						})
						$("#tbody-activity").html(html);
						var totalPages = data.total%pageSize==0 ? data.total/pageSize : Math.ceil(data.total/pageSize);
						//bootstrap pagination
						$("#activityPage").bs_pagination({
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
								pageList(data.currentPage , data.rowsPerPage);
							}
						});
					} else alert("Activities query failed!");
				}
			})
		}

		function create() {
			$.ajax({
				url:"activity/save",
				data:{
					"owner":$.trim($("#create-owner").val()),
					"name":$.trim($("#create-name").val()),
					"startDate":$.trim($("#create-startDate").val()),
					"endDate":$.trim($("#create-endDate").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-description").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data=="1") {
						//refresh activity list
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						//reset form
						$("#create-form")[0].reset();
						$("#createActivityModal").modal("hide");
					}else alert("Activity added failed!")
				}
			})
		}

		function update() {
			$.ajax({
				url:"activity/update",
				data: {
					"id":$.trim($("#edit-id").val()),
					"owner":$.trim($("#edit-owner").val()),
					"name":$.trim($("#edit-name").val()),
					"startDate":$.trim($("#edit-startDate").val()),
					"endDate":$.trim($("#edit-endDate").val()),
					"cost":$.trim($("#edit-cost").val()),
					"description":$.trim($("#edit-description").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data=="1") {
						alert("Activity update succeed!");
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editActivityModal").modal("hide");
					} else {
						alert("Activity update failed!");
					}
				}
			})
		}

	</script>
</head>
<body>
	<input type="hidden" id="hid-name" />
	<input type="hidden" id="hid-owner" />
	<input type="hidden" id="hid-startDate" />
	<input type="hidden" id="hid-endDate" />

	<!-- create activity -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">Create Activity</h4>
				</div>
				<div class="modal-body">
				
					<form id="create-form" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">Start Date</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">End Date</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">Cost</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button id="saveBtn" type="button" class="btn btn-primary">Save</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- update activity -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">Update Activity</h4>
				</div>
				<div class="modal-body">
				
					<form id="update-form" class="form-horizontal" role="form">
						<input id="edit-id" type="hidden" name="id" />
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" name="name" />
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">Start Date</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" name="startDate" readonly/>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">End Date</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" name="endDate" readonly/>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">Cost</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" name="cost" />
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button id="updateBtn" type="button" class="btn btn-primary" data-dismiss="modal">Update</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>Activities</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Name</div>
				      <input id="name" name="name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Owner</div>
				      <input id="owner" name="owner" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Start Date</div>
					  <input id="startDate" name="startDate" class="form-control time" type="text" id="startTime" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">End Date</div>
					  <input id="endDate" name="endDate" class="form-control time" type="text" id="endTime" readonly/>
				    </div>
				  </div>
				  
				  <button id="queryBtn" type="button" class="btn btn-default">Query</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> Create</button>
				  <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> Update</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> Delete</button>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>Name</td>
                            <td>Owner</td>
							<td>Start Date</td>
							<td>End Date</td>
						</tr>
					</thead>
					<tbody id="tbody-activity">

					</tbody>
				</table>
			</div>
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage">
					<!-- bootstrap pagination -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>