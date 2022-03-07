<%@ page import="com.crm.settings.domain.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"; %>

<!DOCTYPE html>
<html>
<head>
	<base href="<%=base%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">

	$(function(){

		$(".liClass > a").css("color" , "black");
		$(".liClass:first").addClass("active");
		$(".liClass:first > a").css("color" , "white");
		$(".liClass").click(function(){
			$(".liClass").removeClass("active");
			$(".liClass > a").css("color" , "black");
			$(this).addClass("active");
			$(this).children("a").css("color","white");
		});

		window.open("workbench/main/index.html","workareaFrame");

		$("#signoutBtn").click(function () {
			window.location.href = "/user";
		})

	});
	
</script>

</head>
<body>
	
	<!-- profile -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Profile</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						Name：<b>${user.name}</b><br><br>
						Login Account：<b>zhangsan</b><br><br>
						Organization：<b>${user.deptno}，市场部，二级部门</b><br><br>
						Email：<b>${user.email}</b><br><br>
						Expire Time：<b>${user.expireTime}</b><br><br>
						allow IP：<b>${user.allowIps}</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<!-- update password -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='login.jsp';">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Sign out -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Sign out</h4>
				</div>
				<div class="modal-body">
					<p>Are you sure to exit the system ?</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button id="signoutBtn" type="button" class="btn btn-primary" data-dismiss="modal">Sure</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- top -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;</span></div>
		<div style="position: absolute; top: 15px; right: 120px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span> ${user.name} <span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="settings/index.html"><span class="glyphicon glyphicon-wrench"></span> Settings</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> Profile</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> Update Password</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> Sign out</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>

	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

		<div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">
		
			<ul id="no1" class="nav nav-pills nav-stacked">
				<li class="liClass"><a href="workbench/main/index.html" target="workareaFrame"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-tag"></span> 动态</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-time"></span> 审批</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户公海</a></li>
				<li class="liClass"><a href="workbench/activity/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> Market Activity</a></li>
				<li class="liClass"><a href="workbench/clue/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-search"></span> Clue</a></li>
				<li class="liClass"><a href="workbench/customer/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> Customer</a></li>
				<li class="liClass"><a href="workbench/contacts/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> Contacts</a></li>
				<li class="liClass"><a href="workbench/transaction/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> Transaction</a></li>
				<li class="liClass"><a href="workbench/visit/index.html" target="workareaFrame"><span class="glyphicon glyphicon-phone-alt"></span> After sale</a></li>
				<li class="liClass">
					<a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span> Statistic Chart</a>
					<ul id="no2" class="nav nav-pills nav-stacked collapse">
						<li class="liClass"><a href="workbench/chart/activity/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Activity Diagram</a></li>
						<li class="liClass"><a href="workbench/chart/clue/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Clue Diagram</a></li>
						<li class="liClass"><a href="workbench/chart/customerAndContacts/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Customer/Contacts Diagram</a></li>
						<li class="liClass"><a href="workbench/chart/transaction/index.jsp" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Transaction Diagram</a></li>
					</ul>
				</li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-file"></span> 报表</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-shopping-cart"></span> 销售订单</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-send"></span> 发货单</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 跟进</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-leaf"></span> 产品</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 报价</a></li>
			</ul>
			
			<!-- 分割线 -->
			<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
		</div>
		
		<!-- workarea -->
		<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>
		
	</div>
	
	<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>
	
	<!-- bottom -->
	<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>
	
</body>
</html>