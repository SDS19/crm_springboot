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

		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})

		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		/*---------- remark ----------*/

		remarkList();

		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url: "clue/addRemark",
				data: {
					"noteContent":$.trim($("#remark").val()),
					"clueId":"${clue.id}"
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data!=null) remarkList();
					else alert("Remark added failed!");
				}
			})
		})

		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val();
			$.ajax({
				url: "clue/updateRemark",
				data: {
					"id": id,
					"noteContent":$.trim($("#noteContent").val())
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data!=null){
						//update <h5> and <small>
						$("#"+id+" h5").html(data.noteContent);
						$("#"+id+" small").html(data.editTime+" by "+data.editBy);
						$("#editRemarkModal").modal("hide");
					} else alert("Remark updated failed!");
				}
			})
		})

		/*---------- activity ----------*/

		activityList();

		$("#checkAll").click(function () {
			$("input[name=activityId]").prop("checked",this.checked);
		})//checkbox for bind activity

		$("#searchActivityList").on("click",$("input[name=activityId]"),function () {
			$("#checkAll").prop("checked",$("input[name=activityId]").length==$("input[name=activityId]:checked").length);
		})

		$("#search-activity").keydown(function (event) {
			if (event.keyCode==13) {
				$.ajax({
					url: "clue/search",
					data: {
						"name": $.trim($("#search-activity").val()),
						"clueId": "${clue.id}"
					},
					type: "get",
					dataType: "json",
					success: function (data) {
						var html = "";
						$.each(data,function (i,obj) {
							html += "<tr><td><input name='activityId' value='"+obj.id+"' type='checkbox'/></td>"
									+"<td>"+obj.name+"</td>"
									+"<td>"+obj.startDate+"</td>"
									+"<td>"+obj.endDate+"</td>"
									+"<td>"+obj.owner+"</td></tr>"
						})
						$("#searchActivityList").html(html);
					}
				})
				return false;
			}
		})//search activity without being bound to clue

		$("#bindBtn").click(function () {
			var $activities = $("input[name=activityId]:checked");
			if ($activities.length==0) {
				alert("None activity is selected!")
			} else {
				var param = "clueId=${clue.id}";
				$.each($activities,function (i,activity) {
					param += "&activityId="+activity.value
				})
				$.ajax({
					url: "clue/bind",
					data: param,
					type: "post",
					dataType: "text",
					success: function (data) {
						if (data=="1") {
							activityList();
							//empty
							$("#bundModal").modal("hide");
						}else alert("Bind activities failed!")
					}
				})
			}

		})//bind the activity to clue

		$("#editBtn").click(function () {
			$.ajax({
				url: "user/owner",
				type: "get",
				dataType: "json",
				success: function (data) {
					var html = "<option></option>";
					$.each(data,function (i,obj) {
						html += "<option value='"+obj.id+"'>"+obj.name+"</option>";
					})
					$("#edit-owner").html(html);
					$.each(data,function (i,obj) {
						if ("${clue.owner}"==obj.name) $("#edit-owner").val(obj.id);
					})
				}
			})
			$("#edit-appellation").val("${clue.appellation}");
			$("#edit-state").val("${clue.state}");
			$("#edit-source").val("${clue.source}");
			$("#editClueModal").modal("show");
		})

		$("#updateBtn").click(function () { update(); })
		/*$(window).keydown(function (event) {
			if (event.keyCode==13) {
				update();
				return false;
			}
		})*/

		$("#deleteBtn").click(function () {
			if (confirm("Are you sure to delete activity?")) {
				$.ajax({
					url: "clue/delete",
					data: { "id" : "${clue.id}" },
					type: "post",
					dataType: "json",
					success: function (data) {
						if (data=="1") window.location.href = "workbench/clue/index.jsp";
						else alert("Clue delete failed!")
					}
				})
			}
		})
	});

	/*---------- activity ----------*/

	function activityList() {
		$.ajax({
			url: "clue/activity",
			data: {
				"clueId": "${clue.id}"
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				var html = "";
				$.each(data,function (i,obj) {
					html += "<tr>"
							+"<td>"+obj.name+"</td>"
							+"<td>"+obj.startDate+"</td>"
							+"<td>"+obj.endDate+"</td>"
							+"<td>"+obj.owner+"</td>"
							+'<td><a href="javascript:void(0);" onclick="unbind(\''+obj.id+'\')"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span> Unbind</a></td>'
							+"</tr>"
				})
				$("#activityList").html(html);
			}
		})
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
					window.location.href = "clue/detail?id=${clue.id}";
				} else alert("Clue update failed!");
			}
		})
	}

	function unbind(id) {
		$.ajax({
			url: "clue/unbind",
			data: { "id": id },
			type: "post",
			dataType: "text",
			success: function (data) {
				if (data=="1") activityList();
				else alert("Unbind failed!")
			}
		})
	}

	/*---------- remark ----------*/

	function remarkList() {
		$.ajax({
			url: "clue/remark",
			data: { "clueId": "${clue.id}" },
			type: "get",
			dataType: "json",
			success: function (data) {
				var html = "";
				$.each(data,function (i,obj) {
					html += '<div id="'+obj.id+'" class="remarkDiv" style="height: 60px;">'
							+'<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
							+'<div style="position: relative; top: -40px; left: 40px;" >'
							+'<h5>'+obj.noteContent+'</h5>'
							+'<font color="gray">Clue</font>'
							+'<font color="gray">-</font> <b>${clue.appellation} ${clue.fullname} - ${clue.company}</b>'
							+'<small style="color: gray;"> '+(obj.editFlag==0 ? obj.createTime : obj.editTime)+' by '+(obj.editFlag==0 ? obj.createBy : obj.editBy)+'</small>'
							+'<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
							+'<a class="myHref" href="javascript:void(0);" onclick="edit(\''+obj.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'
							+'&nbsp;&nbsp;&nbsp;&nbsp;'
							+'<a class="myHref" href="javascript:void(0);" onclick="remove(\''+obj.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'
							+'</div></div></div>';
				})
				$("#remarkList").html(html);
				$("#remark").val("");
			}
		})
	}

	function edit(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#"+id+" h5").html());
		$("#editRemarkModal").modal("show");
	}

	function remove(id) {
		$.ajax({
			url: "clue/removeRemark",
			data: { "id": id },
			type: "post",
			dataType: "json",
			success: function (data) {
				if (data=="1") $("#"+id).remove();
				else alert("Remove remark failed!");
			}
		})
	}
	
</script>

</head>
<body>

	<!-- Edit Activity Remark Modal -->
	<div class="modal fade" id="editRemarkModal" role="dialog">

		<!-- remark id -->
		<input id="remarkId" type="hidden" name="id" >

		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="ModalLabel">Update Remark</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">Content</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button id="updateRemarkBtn" type="button" class="btn btn-primary">Update</button>
				</div>
			</div>
		</div>
</div>

	<!-- bind activity modal -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Bind Activity</h4>
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
								<td><input id="checkAll" type="checkbox"/></td>
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
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button id="bindBtn" type="button" class="btn btn-primary" data-dismiss="modal">Bind</button>
				</div>
			</div>
		</div>
	</div>

    <!-- edit clue modal -->
    <div class="modal fade" id="editClueModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 90%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">Edit Clue</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
						<input id="edit-id" type="hidden" value="${clue.id}"/>
                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">

                                </select>
                            </div>
                            <label for="edit-company" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-company" value="${clue.company}" />
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
                                <input type="text" class="form-control" id="edit-fullname" value="${clue.fullname}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-job" class="col-sm-2 control-label">Job</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-job" value="${clue.job}">
                            </div>
                            <label for="edit-email" class="col-sm-2 control-label">E-mail</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-email" value="${clue.email}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">Phone</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" value="${clue.phone}"/>
                            </div>
                            <label for="edit-website" class="col-sm-2 control-label">Website</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="${clue.website}"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-mphone" class="col-sm-2 control-label">Mobil Phone</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-mphone" value="${clue.mphone}"/>
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
                            <label for="edit-source" class="col-sm-2 control-label">Clue Source</label>
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
                                <textarea class="form-control" rows="3" id="edit-description">${clue.description}</textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary">${clue.contactSummary}</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="edit-nextContactTime" value="${clue.nextContactTime}"/>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">${clue.address}</textarea>
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

	<!-- back button -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- titel -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.appellation}${clue.fullname}<small>&nbsp;&nbsp;${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?id=${clue.id}&fullname=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}';"><span class="glyphicon glyphicon-retweet"></span> Convert</button>
			<button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> Edit</button>
			<button id="deleteBtn" type="button" class="btn btn-danger" ><span class="glyphicon glyphicon-minus"></span> Delete</button>
		</div>
	</div>
	
	<!-- details -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">Fullname</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.appellation} ${clue.fullname}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Owner</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">Company</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Job</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">E-mail</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Phone</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">Website</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Mobil Phone</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">State</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Source</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">Create</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">Edit</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">Description</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}&nbsp;&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">Contact Summary</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}&nbsp;&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">Next Contact Time</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">Address</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- remark -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>Remark</h4>
		</div>
		
		<!-- remark 1~n -->
		<div id="remarkList"></div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="Add remark..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 710px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">Cancel</button>
					<button id="saveRemarkBtn" type="button" class="btn btn-primary">Save</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- activity -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>Activity</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>Name</td>
							<td>Start Date</td>
							<td>End Date</td>
							<td>Owner</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityList">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span> Bind Activity</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>