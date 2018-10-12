<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript" src="/static/js/jquery-3.2.1.min.js"></script>
<link href="/static/bootstrap-3.3.7-dist/css/bootstrap.css" rel="stylesheet">
<script type="text/javascript" src="/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
<script type="text/javascript">

	$(function(){
		to_page(1);
	});

	// 到达指定页面
	function to_page(pageno){
		$.ajax({
			url: "emp/getAll",
			data: {time: new Date(), pageno: pageno},
			type: "get",
			success: function(data){
				// 信息表
				build_emp_table(data);
				// 分页信息
				build_page_info(data);
				// 分页数据
				build_page_nav(data);
			}
		});
	}

	// 填充数据表
	function build_emp_table(data){
		// 清除上一步的状态
		$("#tb_emp tbody").empty();
		var emps = data.extend.pageInfo.list;
		$.each(emps, function(index, ele){
			var checkBox = $("<td><input type='checkbox' class='check_item'/></td>");
			var empno = $("<td></td>").append(ele.empno);
			var ename = $("<td></td>").append(ele.ename);
			var gender = $("<td></td>").append(ele.gender == 'M' ? "男" : "女");
			var email = $("<td></td>").append(ele.email);
			var dname = $("<td></td>").append(ele.department.dname);
			var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
							.append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
							.append("Edit");
			editBtn.attr("edit-id", ele.empno);
			var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
							.append($("<span></span>").addClass("glyphicon glyphicon-trash"))
							.append("Delete");
			deleteBtn.attr("del-id", ele.empno);
			var btnTd = $("<td></td>").append(editBtn).append(" ").append(deleteBtn);
			$("<tr></tr>").append(checkBox)
						  .append(empno)
						  .append(ename)
						  .append(gender)
						  .append(email)
						  .append(dname)
						  .append(btnTd)
						  .appendTo("#tb_emp tbody");
		});
	}

	// 填充分页信息头
	function build_page_info(data){
		$("#page_info_area").empty();
		$("#page_info_area").append("第" + data.extend.pageInfo.pageNum + "页， 总"
			+ data.extend.pageInfo.pages + "页， 共"
			+ data.extend.pageInfo.total + "条记录");
		// global variable
		totalRecord = data.extend.pageInfo.total;
		currentPage = data.extend.pageInfo.pageNum;
	}

	// 填充分页主体按钮控制条
	function build_page_nav(data){
		$("#page_nav_area").empty();
		var $ul = $("<ul></ul>").addClass("pagination");

		var $firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
		var $prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
		if (data.extend.pageInfo.hasPreviousPage == false) {
			$firstPageLi.addClass("disabled");
			$prePageLi.addClass("disabled");
		} else {
			$firstPageLi.click(function(){
				to_page(1);
			});
			$prePageLi.click(function(){
				to_page(currentPage - 1);
			});
		}

		var $nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
		var $lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
		if (data.extend.pageInfo.hasNextPage == false) {
			$nextPageLi.addClass("disabled");
			$lastPageLi.addClass("disabled");
		} else {
			$nextPageLi.click(function(){
				to_page(currentPage + 1);
			});
			$lastPageLi.click(function(){
				to_page(data.extend.pageInfo.pages);
			});
		}

		// 添加首页和上一页到列表
		$ul.append($firstPageLi).append($prePageLi);

		// 分页可控制器
		$.each(data.extend.pageInfo.navigatepageNums, function(index, item){
			var $numLi = $("<li></li>").append($("<a></a>").append(item));
			if (currentPage == item) {
				$numLi.addClass("active");
			}
			$numLi.click(function(){
				to_page(item);
			});
			$ul.append($numLi);
		});

		// 添加下一页和末页到列表
		$ul.append($nextPageLi).append($lastPageLi);

		// 把当前列表加入到 nav
		var $navEle = $("<nav></nav>").append($ul).attr("aria-label", "Page navigation");
		$navEle.appendTo("#page_nav_area");
	}

	// 清空表单样式及内容
	function reset_form(ele){
		$(ele)[0].reset();
		$(ele).find("*").removeClass("has-error has-successs");
		$(ele).find(".help-block").text("");
	}

	$(function(){
		// 员工新增
		$("#emp_save_modal_btn").click(function(){
			// 清除表单数据
			reset_form("#empSaveModal form");
			// 发送 Ajax 请求, 查询部门信息, 显示在下拉列表中
			getDepts("#empSaveModal select");
			// 弹出模态框
			$("#empSaveModal").modal({
				backdrop: "static"
			});
		});

		// 获取所有部门信息
		function getDepts(ele){
			// 清空之前的下拉列表的值
			$(ele).empty();
			$.ajax({
				url: "dept/getAll",
				type: "get",
				success: function(data){
					$.each(data.extend.depts, function(){
						var $optionEle = $("<option></option>").append(this.dname).attr("value", this.deptno);
						// 将下拉选项添加到下拉框中
						$optionEle.appendTo(ele);
					});
				}
			});
		}

		// 提交按钮后进行的表单数据校验
		function validate_save_form(){
			// 获取需要校验的数据
			var $ename = $("#ename_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
			if (!regName.test($ename)) {
				show_validate_msg("#ename_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
				return false;
			} else {
				show_validate_msg("#ename_add_input", "success", "");
			}

			// 校验邮箱信息
			var $email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if (!regEmail.test($email)) {
				show_validate_msg("#email_add_input", "error", "邮箱个格式不正确");
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
			}
			return true;
		}

		// 显示校验结果的校验状态
		function show_validate_msg(ele, status, msg){
			// 清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");

			if ("success" == status) {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			} else if ("error" == status) {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}

		// 校验用户名是否可用
		$("#ename_add_input").change(function(){
			var ename = this.value;
			$.ajax({
				url: "emp/checkUser",
				data: {time: new Date(), ename: ename},
				type: "post",
				success: function(data){
					if (data.code == 100) {
						show_validate_msg("#ename_add_input", "success", "用户名可用");
						$("#emp_save_btn").attr("ajax-va", "success");
					} else {
						alert("err");
						show_validate_msg("#ename_add_input", "error", data.extend.va_msg);
						$("#emp_save_btn").attr("ajax-va", "error");
					}
				}
			});
		});

		// 点击保存, 保存员工
		$("#emp_save_btn").click(function(){
			// 模态框的表单数据提交到服务器, 在此之前先要进行校验
			if (!validate_save_form()) {
				return false;
			}
			if ($(this).attr("ajax-va") == "error") {
				return false;
			}
			alert($("#empSaveModal form").serialize());
			// 发送 Ajax 请求保存信息
			$.ajax({
				url: "emp/save",
				type: "post",
				data: $("#empSaveModal form").serialize(),
				success: function(data){
					if (data.code == 100) {
						// 员工保存成功
						// 关闭模态框
						$("#empSaveModal").modal("hide");
						// 发送 Ajax 请求显示最后一页数据
						to_page(totalRecord);
					} else {
						// 显示失败信息
						if (undefined != data.extend.errorFields.email) {
							show_validate_msg("#email_add_input", "error", data.extend.errorFields.email);
						}
						if (undefined != data.extend.errorFields.ename) {
							show_validate_msg("#ename_add_input", "error", data.extend.errorFields.ename);
						}
					}
				}
			});
		});

		// .edit_btn 在创建之前就已经执行如下绑定事件了, 所以不能通过常规的事件绑定驱动，需要用 on 来绑定
		$(document).on("click", ".edit_btn", function(){
			// 查询全部部门
			getDepts("#empUpdateModal select");
			// 获取员工信息
			getEmp($(this).attr("edit-id"));
			// 把员工的id传递给模态框的更新按钮
			$("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
			$("#empUpdateModal").modal({
				backdrop: "static"
			});
		});

		// Ajax 获取 id 对应的 emp 信息, 将其设置到模态框中
		function getEmp(id) {
			$.ajax({
				url: "emp/get/" + id,
				type: "get",
				success: function(data){
					var empData = data.extend.emp;
					$("#ename_update_static").text(empData.ename);
					$("#email_update_input").val(empData.email);
					$("#empUpdateModal input[name=gender]").val([empData.gender]);
					$("#empUpdateModal select").val([empData.deptno]);
				}
			});
		}

		// 更新员工信息
		$("#emp_update_btn").click(function(){
			// 校验邮箱
			var $email = $("#email_update_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test($email)){
				show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
				return false;
			}else{
				show_validate_msg("#email_update_input", "success", "");
			}

			// 发送 Ajax 请求到服务器更新员工信息
			$.ajax({
				url: "emp/update/" + $(this).attr("edit-id"),
				// Ajax 支持 put 请求, 不需要在 data 拼接  "&_method=put", 但是由于 Tomcat 只会对 post 请求参数封装所以需要处理下
				type: "put",
				data: $("#empUpdateModal form").serialize(),
				success: function(data){
					$("#empUpdateModal").modal("hide");
					// 回到本页面
					to_page(currentPage);
				}
			});
		});

		// 删除单条记录
		$(document).on("click", ".delete_btn", function(){
			var ename = $(this).parents("tr").find("td:eq(2)").text();
			var empno = $(this).attr("del-id");
			if (confirm("确认删除【" + ename + "】吗？")) {
				$.ajax({
					url: "emp/delete/" + empno,
					type: "delete",
					success: function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});

		// 全选功能
		$("#check_all").click(function(){
			var flag = this.checked;
			$(".check_item").prop("checked", flag);
		});
		$(document).on("click", ".check_item", function(){
			var flag = $(".check_item").length == $(".check_item:checked").length;
			$("#check_all").prop("checked", flag);
		});

		// 批量删除
		$("#emp_delete_all_btn").click(function(){
			var enames = "";
			var del_idstr = "";
			$.each($(".check_item:checked"), function(){
				enames += $(this).parents("tr").find("td:eq(2)").text() + ",";
				del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
			});
			enames = enames.substring(0, enames.length - 1);
			del_idstr = del_idstr.substring(0, del_idstr.length - 1);
			if (confirm("确认删除【" + enames + "】吗？")) {
				$.ajax({
					url: "emp/delete/" + del_idstr,
					type: "delete",
					success: function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});

	})


</script>
<body>

	<!-- 员工修改 Modal -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工修改</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">ename</label>
			    <div class="col-sm-10">
			      	<p class="form-control-static" id="ename_update_static"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_update_input" placeholder="drfeelin@163.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_update_input" value="W"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">dname</label>
			    <div class="col-sm-4">
			      <!-- 部门提交部门id即可 -->
			      <select class="form-control" name="deptno"></select>
			    </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">Update</button>
	      </div>
	    </div>
	  </div>
	</div>

	<!-- 员工添加 Modal -->
	<div class="modal fade" id="empSaveModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">ename</label>
			    <div class="col-sm-10">
			      <input type="text" name="ename" class="form-control" id="ename_add_input" placeholder="ename">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="drfeelin@163.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="W"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">dname</label>
			    <div class="col-sm-4">
			      <!-- 部门提交部门id即可 -->
			      <select class="form-control" name="deptno">
			      </select>
			    </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">Save</button>
	      </div>
	    </div>
	  </div>
	</div>

	<!-- 搭建页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-10">
				<button class="btn btn-info btn-sm" id="emp_save_modal_btn">Save</button>
				<button class="btn btn-danger btn-sm" id="emp_delete_all_btn">Delete</button>
			</div>
		</div>
		<!-- 表格 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="tb_emp">
					<thead>
						<tr>
							<th><input type="checkbox" id="check_all" /></th>
							<th>#</th>
							<th>ename</th>
							<th>gender</th>
							<th>email</th>
							<th>dname</th>
							<th>operation</th>
						</tr>
					</thead>
					<!-- 数据表, 通过 Ajax 来填充数据 -->
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<!-- 分页 -->
		<div class="row">
			<!-- 分页信息 -->
			<div class="col-md-6" id="page_info_area"></div>
			<!-- 分页控制 -->
			<div class="col-md-6" id="page_nav_area"></div>
		</div>
	</div>
</body>
</html>