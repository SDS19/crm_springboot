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

			/*$("#definedColumns > li").click(function(e) {
				e.stopPropagation();
			});*/

			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			customerList(1,3);

			//checkbox
			$("#checkAll").click(function () {
				$("input[name=check]").prop("checked",this.checked);
			})
			$("#tbody-customer").on("click",$("input[name=check]"),function () {
				$("#checkAll").prop("checked",$("input[name=check]").length==$("input[name=check]:checked").length);
			})

			$("#createBtn").click(function () {
				$.ajax({
					url:"owner",
					type:"get",
					dataType:"json",
					success:function (data) {
						if (data!=null) {
							var html = "";
							$.each(data, function (i, obj) {
								html += "<option value='"+obj.id+"'>"+obj.name+"</option>";
							})
							$("#create-owner").html(html);
							$("#create-owner").val("${user.id}");
						}
					}
				})
			})
			$("#saveBtn").click(function () {
				$.ajax({
					url:"customer",
					data: {
						"owner":$.trim($("#create-owner").val()),
						"name":$.trim($("#create-name").val()),
						"website":$.trim($("#create-website").val()),
						"phone":$.trim($("#create-phone").val()),
						"description":$.trim($("#create-description").val()),
						"contactSummary":$.trim($("#create-contactSummary").val()),
						"nextContactTime":$.trim($("#create-nextContactTime").val()),
						"address":$.trim($("#create-address").val())
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data=="1") {
							customerList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
							$("#create-form")[0].reset();
							$("#createCustomerModal").modal("hide");
						} else alert("Create customer failed!");
							$("#create-owner").html(html);
							$("#create-owner").val("${user.id}");
					}
				})
			})
		
		});

		function customerList(pageNo,pageSize) {
			$("#checkAll").prop("checked",false);
			$("#name").val($.trim($("#hid-name").val()));
			$("#owner").val($.trim($("#hid-owner").val()));
			$("#phone").val($.trim($("#hid-phone").val()));
			$("#website").val($.trim($("#hid-website").val()));
			$.ajax({
				url:"customer",
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#name").val()),
					"owner":$.trim($("#owner").val()),
					"phone":$.trim($("#phone").val()),
					"website":$.trim($("#website").val())
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					if (data!=null) {
						var html = "";
						$.each(data.dataList,function (i,obj) {
							html += "<tr><td><input name='check' type='checkbox' value='"+obj.id+"'/></td>"
									+"<td><a style='text-decoration: none; cursor: pointer;' onclick=window.location.href=\'customer/detail?id="+obj.id+"\';>"+obj.name+"</a></td>"
									+"<td>"+obj.owner+"</td>"
									+"<td>"+obj.phone+"</td>"
									+"<td>"+obj.website+"</td></tr>";
						})
						$("#tbody-customer").html(html);
						var totalPages = data.total%pageSize==0 ? data.total/pageSize : Math.ceil(data.total/pageSize);
						//bootstrap pagination
						$("#customerPage").bs_pagination({
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
								customerList(data.currentPage , data.rowsPerPage);
							}
						});
					} else alert("Customers query failed!");
				},
				/*error:function (XMLHttpRequest,textStatus) {
					var redirect = XMLHttpRequest.getResponseHeader("x-Redirect");
					if (redirect=="true") {
						alert("Please login!");
						window.location.href = XMLHttpRequest.getResponseHeader("x-Path");
					}
				}*/
			})
		}


	
	</script>
</head>
<body>

	<input type="hidden" id="hid-name" />
	<input type="hidden" id="hid-owner" />
	<input type="hidden" id="hid-phone" />
	<input type="hidden" id="hid-website" />

	<!-- create customer modal -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">Create Customer</h4>
				</div>
				<div class="modal-body">
					<form id="create-form" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">owner<span style="font-size: 15px; color: red;">*</span></label>
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
                            <label for="create-website" class="col-sm-2 control-label">Website</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">Phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button id="saveBtn" type="button" class="btn btn-primary" data-dismiss="modal">Save</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- update customer modal  -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Update Customer</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="create-nextContactTime2">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>Customer List</h3>
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
				      <input id="name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Owner</div>
				      <input id="owner" class="form-control" type="text">
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
				      <div class="input-group-addon">Website</div>
				      <input id="website" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default">Query</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createBtn" type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"><span class="glyphicon glyphicon-plus"></span> Create</button>
				  <button id="updateBtn" type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal"><span class="glyphicon glyphicon-pencil"></span> Update</button>
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
							<td>Phone</td>
							<td>Website</td>
						</tr>
					</thead>
					<tbody id="tbody-customer">

					</tbody>
				</table>
			</div>
			<div id="customerPage" style="height: 70px; position: relative;top: 30px;">
				<!-- bootstrap pagination -->
			</div>
		</div>
	</div>
</body>
</html>