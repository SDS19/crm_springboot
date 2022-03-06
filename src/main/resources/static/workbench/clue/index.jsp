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

			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});

			pageList(1,3);

			//checkbox
			$("#checkAll").click(function () {
				$("input[name=check]").prop("checked",this.checked);
			})
			$("#tbody-clue").on("click",$("input[name=check]"),function () {
				$("#checkAll").prop("checked",$("input[name=check]").length==$("input[name=check]:checked").length);
			})

			$("#queryBtn").click(function () {
				$("#hid-fullname").val($.trim($("#fullname").val()));
				$("#hid-company").val($.trim($("#company").val()));
				$("#hid-phone").val($.trim($("#phone").val()));
				$("#hid-source").val($.trim($("#source").val()));
				$("#hid-owner").val($.trim($("#owner").val()));
				$("#hid-mphone").val($.trim($("#mphone").val()));
				$("#hid-state").val($.trim($("#state").val()));
				pageList(1,3);
			});

			//create
			$("#addBtn").click(function () {
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
						$("#create-owner").val("${user.id}");
						$("#createClueModal").modal("show");
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
					alert("None clue is selected!")
				}else if ($checked.length>1){
					alert("Only can update one clue a time!")
				}else {
					var id = "id="+$checked.val();
					$.ajax({
						url:"clue/edit",
						data: id,
						type:"get",
						dataType:"json",
						success:function (data) {
							var html = "<option></option>";
							$.each(data.list,function (i,obj) {
								html += "<option value='"+obj.id+"'>"+obj.name+"</option>";
							})
							$("#edit-id").val(data.clue.id);
							$("#edit-owner").html(html);
							$("#edit-owner").val(data.clue.owner);
							$("#edit-company").val(data.clue.company);
							$("#edit-appellation").val(data.clue.appellation);
							$("#edit-fullname").val(data.clue.fullname);
							$("#edit-job").val(data.clue.job);
							$("#edit-email").val(data.clue.email);
							$("#edit-phone").val(data.clue.phone);
							$("#edit-website").val(data.clue.website);
							$("#edit-mphone").val(data.clue.mphone);
							$("#edit-state").val(data.clue.state);
							$("#edit-source").val(data.clue.source);
							$("#edit-description").val(data.clue.description);
							$("#edit-contactSummary").val(data.clue.contactSummary);
							$("#edit-nextContactTime").val(data.clue.nextContactTime);
							$("#edit-address").val(data.clue.address);
							$("#editClueModal").modal("show");
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
				if (checked.length==0) alert("None clues are selected!")
				else {
					if (confirm("Are you sure to delete selected clues?")) {
						var params = "";
						for (var i=0;i<checked.length;i++) {
							params += "id="+checked[i].value;
							if (i<checked.length-1) params += "&";
						}
						$.ajax({
							url:"clue/delete",
							data: params,
							type:"post",
							dataType:"json",
							success:function (data) {
								if (data=="1") {
									pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
								}else alert("Clue delete failed!");
							}
						})
					}
				}
			})


		});

		function pageList(pageNo,pageSize) {
			$("#checkAll").prop("checked",false);
			//get search condition form hidden field
			$("#fullname").val($.trim($("#hid-fullname").val()));
			$("#company").val($.trim($("#hid-company").val()));
			$("#phone").val($.trim($("#hid-phone").val()));
			$("#source").val($.trim($("#hid-source").val()));
			$("#owner").val($.trim($("#hid-owner").val()));
			$("#mphone").val($.trim($("#hid-mphone").val()));
			$("#state").val($.trim($("#hid-state").val()));
			$.ajax({
				url:"clue/clues",
				data: {
					"pageNo":pageNo,
					"pageSize":pageSize,
					"fullname":$.trim($("#fullname").val()),
					"company":$.trim($("#company").val()),
					"phone":$.trim($("#phone").val()),
					"source":$.trim($("#source").val()),
					"owner":$.trim($("#owner").val()),
					"mphone":$.trim($("#mphone").val()),
					"state":$.trim($("#state").val()),
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					if (data!=null) {
						var html = "";
						$.each(data.dataList,function (i,obj) {
							html += "<tr><td><input name='check' type='checkbox' value='"+obj.id+"'/></td>"
									+"<td><a style='text-decoration: none; cursor: pointer;' onclick=window.location.href=\'clue/detail?id="+obj.id+"\';>"+obj.appellation+obj.fullname+"</a></td>"
									+"<td>"+obj.company+"</td>"
									+"<td>"+obj.phone+"</td>"
									+"<td>"+obj.mphone+"</td>"
									+"<td>"+obj.source+"</td>"
									+"<td>"+obj.owner+"</td>"
									+"<td>"+obj.state+"</td></tr>";
						})
						$("#tbody-clue").html(html);
						var totalPages = data.total%pageSize==0 ? data.total/pageSize : Math.ceil(data.total/pageSize);
						//bootstrap pagination
						$("#cluePage").bs_pagination({
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
					} else alert("Clues query failed!");
				}
			})
		}

		function create() {
			$.ajax({
				url:"clue/save",
				data:{
					"fullname":$.trim($("#create-fullname").val()),
					"appellation":$.trim($("#create-appellation").val()),
					"owner":$.trim($("#create-owner").val()),
					"company":$.trim($("#create-company").val()),
					"job":$.trim($("#create-job").val()),
					"email":$.trim($("#create-email").val()),
					"phone":$.trim($("#create-phone").val()),
					"website":$.trim($("#create-website").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"state":$.trim($("#create-state").val()),
					"source":$.trim($("#create-source").val()),
					"description":$.trim($("#create-description").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"address":$.trim($("#create-address").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data=="1") {
						pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						$("#create-form")[0].reset();//reset form
						$("#createClueModal").modal("hide");
					}else alert("Clue added failed!")
				}
			});
		}

		function update() {
			$.ajax({
				url:"clue/update",
				data: {
					"id":$("#edit-id").val(),
					"owner":$.trim($("#edit-owner").val()),
					"company":$.trim($("#edit-company").val()),
					"appellation":$.trim($("#edit-appellation").val()),
					"fullname":$.trim($("#edit-fullname").val()),
					"job":$.trim($("#edit-job").val()),
					"email":$.trim($("#edit-email").val()),
					"phone":$.trim($("#edit-phone").val()),
					"website":$.trim($("#edit-website").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"state":$.trim($("#edit-state").val()),
					"source":$.trim($("#edit-source").val()),
					"description":$.trim($("#edit-description").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data=="1") {
						alert("Clue update succeed!");
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editClueModal").modal("hide");
					} else alert("Clue update failed!");
				}
			})
		}

	</script>
</head>
<body>
	<!-- hidden field for search condition -->
	<input type="hidden" id="hid-fullname" />
	<input type="hidden" id="hid-company" />
	<input type="hidden" id="hid-phone" />
	<input type="hidden" id="hid-source" />
	<input type="hidden" id="hid-owner" />
	<input type="hidden" id="hid-mphone" />
	<input type="hidden" id="hid-state" />

	<!-- create clue modal -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Create clue</h4>
				</div>
				<div class="modal-body">
					<form id="create-form" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">Appellation</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<option></option>
									<c:forEach items="${appellation}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">Fullname<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">Job</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">E-mail</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">Phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">Website</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">Mobil phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">Clue State</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<option></option>
									<c:forEach items="${clueState}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  	<option></option>
									<c:forEach items="${source}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">Contact summary</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">Next contact time</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
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
	
	<!-- update clue modal -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Edit clue</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input id="edit-id" type="hidden" />
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" />
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">Appellation</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option></option>
									<c:forEach items="${appellation}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">Fullname<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" />
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">Job</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" />
							</div>
							<label for="edit-email" class="col-sm-2 control-label">E-mail</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" />
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">Phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" />
							</div>
							<label for="edit-website" class="col-sm-2 control-label">Website</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" />
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">Mobil phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" />
							</div>
							<label for="edit-state" class="col-sm-2 control-label">Clue State</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<option></option>
									<c:forEach items="${clueState}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option></option>
									<c:forEach items="${source}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" readonly/>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
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
				<h3>Clues (Potential Customer)</h3>
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
				      <div class="input-group-addon">Fullname</div>
				      <input id="fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Company</div>
				      <input id="company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Phone</div>
				      <input id="phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Source</div>
					  <select id="source" class="form-control">
						  <option></option>
						  <c:forEach items="${source}" var="dicValue">
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Owner</div>
				      <input id="owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Mobil Phone</div>
				      <input id="mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">State</div>
					  <select id="state" class="form-control">
						  <option></option>
						  <c:forEach items="${clueState}" var="dicValue">
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="queryBtn" type="button" class="btn btn-default">Query</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> Create</button>
				  <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> Update</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> Delete</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>Fullname</td>
							<td>Company</td>
							<td>Tel</td>
							<td>Mobil</td>
							<td>Source</td>
							<td>Owner</td>
							<td>State</td>
						</tr>
					</thead>
					<tbody id="tbody-clue">

					</tbody>
				</table>
			</div>
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage">
					<!-- bootstrap pagination -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>