<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="keywords" content="jquery,ui,easy,easyui,web">
	<meta name="description" content="easyui help you build your web page easily!">
	<title>jQuery EasyUI CRUD Demo</title>
	<link rel="stylesheet" type="text/css" href="../themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="../themes/icon.css">
	<link rel="stylesheet" type="text/css" href="demo.css">
	<script type="text/javascript" src="../jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="../jquery.easyui.min.js"></script>
	<style type="text/css">
		#fm{
			margin:0;
			padding:10px 30px;
		}
		.ftitle{
			font-size:14px;
			font-weight:bold;
			color:#666;
			padding:5px 0;
			margin-bottom:10px;
			border-bottom:1px solid #ccc;
		}
		.fitem{
			margin-bottom:5px;
		}
		.fitem label{
			display:inline-block;
			width:80px;
		}
	</style>
	<script type="text/javascript">
		var url = "";
		function newUser(){
			
			$("#dlg").dialog("open").dialog("setTitle","新添加用户");
			
			//$("#fm").form("clear");
			
			url = "<%=basePath%>/servlet/FirstEasyuiServlet?flag=addNew";
			
		}
		
		//编辑某个用户,弹出加载界面 
		function editUser(){
			
			var row = $("#dg").datagrid("getSelected");
			
			if (row){
				
				$("#dlg").dialog("open").dialog("setTitle","编辑用户信息");
				
				$("#fm").form("load",row);
				
				url = "<%=basePath%>/servlet/FirstEasyuiServlet?flag=edit";		
				
			} else {
				
				alert("请选中一行再操作！");
				
			}
		}
		//保存某个用户信息
		function saveUser(){
			
			$("#fm").form("submit",{
				
				url: url,
				
				onSubmit: function(){
					
					return $(this).form("validate");
					
				},
				
				success: function(result){
					
					var result = eval("("+result+")");
					
					if (result.success){
						
						alert(result.msg);
						
						$("#dlg").dialog("close");		// close the dialog
						
						$("#dg").datagrid("reload");	// reload the user data
						
					} else {
						
						$.messager.show({
							
							title: "Error",
							
							msg: result.msg
							
						});
						
					}
				}
			});
		}
		function removeUser(){
			
			var row = $("#dg").datagrid("getSelected");
			
			if (row){
				
				$.messager.confirm("Confirm","你确认要删除此用户记录吗?",function(r){
					
					if (r){
						
						$.post("<%=basePath%>/servlet/FirstEasyuiServlet?flag=remove",{id:row.id},function(result){
							
							if (result.success){
								
								$("#dg").datagrid("reload");	// reload the user data
								
							} else {
								
								$.messager.show({	// show error message
									
									title: "Error",
									
									msg: result.msg
									
								});
								
							}
						},"json");
					}
				});
			}
		}
	</script>
</head>
<body>
	<h2>Basic CRUD Application</h2>
	<div class="demo-info" style="margin-bottom:10px">
		<div class="demo-tip icon-tip">&nbsp;</div>
		<div>Click the buttons on datagrid toolbar to do crud actions.</div>
	</div>
	
	<!-- url为查询路径 ,注意以绝对路径方式-->
	<table id="dg" title="My Users" class="easyui-datagrid" style="width:700px;height:250px"
			url="<%=basePath%>/servlet/FirstEasyuiServlet"
			toolbar="#toolbar" pagination="true"
			rownumbers="true" fitColumns="true" singleSelect="true">
		<thead>
			<tr>
				<th field="firstName" width="50">First Name</th>
				<th field="lastName" width="50">Last Name</th>
				<th field="phone" width="50">Phone</th>
				<th field="email" width="50">Email</th>
			</tr>
		</thead>
	</table>
	<div id="toolbar">
		<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newUser()">New User</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editUser()">Edit User</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="removeUser()">Remove User</a>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
			closed="true" buttons="#dlg-buttons">
		<div class="ftitle">User Information</div>
		<form id="fm" method="post">
		
		<!-- 隐藏ID,隐藏域不用验证，，，， -->
		<div class="fitem">
			<input type="hidden" name="id" class="easyui-validatebox" >
		</div>
			
			<div class="fitem">
				<label>First Name:</label>
				<input name="firstName" class="easyui-validatebox" required="true">
			</div>
			<div class="fitem">
				<label>Last Name:</label>
				<input name="lastName" class="easyui-validatebox" required="true">
			</div>
			<div class="fitem">
				<label>Phone:</label>
				<input name="phone">
			</div>
			<div class="fitem">
				<label>Email:</label>
				<input name="email" class="easyui-validatebox" validType="email">
			</div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveUser()">Save</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
	</div>
</body>
</html>