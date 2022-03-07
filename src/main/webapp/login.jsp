<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String base = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath(); %>

<!DOCTYPE html>
<html>
<head>
	<base href="<%=base%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-3.6.0.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {
			if (window.top!=window) {
				window.top.location = window.location;
			}

			//empty the input after page load
			//$("#loginAct").val("");
			//$("#loginPwd").val("");
			//默认登录用户名，密码（部署项目后删除）
			$("#loginAct").val("root");
			$("#loginPwd").val("toor");

			//focus on username field
			$("#loginAct").focus();

			//submit form
			$("#submitBtn").click(function () {
				login();
			});
			$(window).keydown(function (event) {//event can get which key is pressed
				if (event.keyCode==13) login();
			})
		})

		function login() {
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			if (loginAct==""||loginPwd=="") {
				$("#msg").html("Account or password can't be null!");
				return false;//stop login method
			}
			$("#msg").html("");
			$.ajax({
				url:"user",
				data:{
					"loginAct":loginAct,
					"loginPwd":loginPwd
				},
				type:"POST",
				dataType:"json",
				success:function (data) {
					if (data.success=="1") window.location.href = "workbench/index.jsp";
					else $("#msg").html(data.msg);
				}}
			)


		}
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>Login</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" name="loginAct" class="form-control" type="text" placeholder="Username">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" name="loginPwd" class="form-control" type="password" placeholder="Password">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<button id="submitBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">Login</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>