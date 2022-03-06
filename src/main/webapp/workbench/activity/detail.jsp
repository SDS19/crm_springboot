<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"; %>

<!DOCTYPE html>
<html>
<head>
	<base href="<%=base%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

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

		//update and delete icon
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })

        remarkList();

        //edit activity
        $("#editBtn").click(function () {
            var id = "id=${activity.id}";
            $.ajax({
                url:"user/owner",
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html = "<option></option>";
                    $.each(data,function (i,obj) {
                        html += "<option value='"+obj.id+"'>"+obj.name+"</option>";
                    })
                    $("#edit-owner").html(html);
                    $.each(data,function (i,obj) {
                        if ("${activity.owner}" == obj.name) $("#edit-owner").val(obj.id);
                    })
                    $("#editActivityModal").modal("show");
                }
            })
        })
		$("#updateBtn").click(function () { update(); })

		$(window).keydown(function (event) {
			if (event.keyCode==13) {
				update();
				return false;
			}
		})

		//delete activity
		$("#deleteBtn").click(function () {
			if (confirm("Are you sure to delete activity?")) {
				$.ajax({
					url:"activity/delete",
					data: { "id" : "${activity.id}" },
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data=="1") window.location.href = "workbench/activity/index.jsp";
						else alert("Delete operation failed!");
					}
				})
			}
		})

        //add remark
        $("#saveRemarkBtn").click(function () {
            $.ajax({
                url: "activity/addRemark",
                data: {
                    "noteContent":$.trim($("#remark").val()),
                    "activityId":"${activity.id}"
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data!=null) remarkList();
                    else alert("Remark added failed!");
                }
            })
        })

        //update remark
        $("#updateRemarkBtn").click(function () {
            var id = $("#remarkId").val();
            $.ajax({
                url: "activity/updateRemark",
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
                        //Plan B: remarkList();
                    } else alert("Remark updated failed!");
                }
            })
        })

    });

	function remarkList() {
		$.ajax({
			url: "activity/remarks",
			data: { "activityId": "${activity.id}" },
			type: "get",
			dataType: "json",
			success: function (data) {
				var html = "";
				$.each(data,function (i,obj) {
					html += '<div id="'+obj.id+'" class="remarkDiv" style="height: 60px;">'
                            +'<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                            +'<div style="position: relative; top: -40px; left: 40px;" >'
							+'<h5>'+obj.noteContent+'</h5>'
                            +'<font color="gray">Activity</font>'
							+'<font color="gray">-</font> <b>${activity.name}</b>'
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

	//update activity
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
					$("#editActivityModal").modal("hide");
					window.location.href = "activity/detail?id=${activity.id}";
				} else {
					alert("Activity update failed!");
				}
			}
		})
	}

	//edit remark
	function edit(id) {
	    $("#remarkId").val(id);
	    $("#noteContent").val($("#"+id+" h5").html());
        $("#editRemarkModal").modal("show");
    }
    //remove remark
	function remove(id) {
        $.ajax({
            url: "activity/removeRemark",
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
		<%-- Remark Id --%>
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

    <!-- Edit Activity Modal -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">Edit Activity</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">
						<input id="edit-id" type="hidden" value="${activity.id}" />
                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">

                                </select>
                            </div>
                            <label for="edit-name" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="${activity.name}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startDate" class="col-sm-2 control-label">Start Date</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startDate" value="${activity.startDate}">
                            </div>
                            <label for="edit-endDate" class="col-sm-2 control-label">End Date</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endDate" value="${activity.endDate}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">Cost</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="${activity.cost}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description">${activity.description}</textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="updateBtn" type="button" class="btn btn-primary">Update</button>
                </div>
            </div>
        </div>
    </div>

	<!-- back button -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- topic -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>Activity-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> Edit</button>
			<button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> Delete</button>
		</div>
	</div>
	
	<!-- detail -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">Owner</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Name</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">Start Date</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">End Date</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">Cost</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">creat</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">edit</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">Description</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- remark -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div id="remarkAppend" class="page-header">
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
	<div style="height: 200px;"></div>
</body>
</html>