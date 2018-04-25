<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.6/css/bootstrap.min.css">
<title>用户的CURD</title>
</head>
<body>
<div id="top_nav">
	<a href="${base}/user/logout">登出</a>
</div>
<div class="center-wrapper">
	<div class="center-content">
		<div class="row no-m">
			<div class="col-xs-10 col-xs-offset-1 col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4">
				<header class="panel-heading no-b text-center" style="font-size:30px;"> 用户列表 </header>
				<div id="app">

					<div>
						<table id="tb1" border="2">
							<thead>
							<tr>
								<td>id</td>
								<td>用户名</td>
								<td>年龄</td>
								<td>创建日期</td>
								<td>操作</td>
								<td>操作</td>
							</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
					</div>
					<div>
						<a href="#">上一页</a>
						<a href="#">下一页</a>
					</div>
				</div>
			</div>
		</div>
		<div class="row no-m">
			<div class="col-xs-5 col-xs-offset-1 col-sm-3 col-sm-offset-1 col-md-2 col-md-offset-2">
				<section class="panel bg-white no-b fadeIn animated"> <header class="panel-heading no-b text-center" style="font-size:30px;"> 添加用户 </header>
				<form id="add_form" action="#" role="form" method="post">
					<div class="form-group">
						<input type="text" id="username" name="name" required class="form-control input-lg mb25" placeholder="用户名">
					</div>
					<div class="form-group">
						<input type="password" id="password" name="password" required class="form-control input-lg mb25" placeholder="密码">
					</div>
					<div class="form-group">
						<input type="text" id="age" name="age"  required class="form-control input-lg mb25" placeholder="年龄">
					</div>
					<p id="tip" class="bg-danger p15" style="display: none"></p>

					<div class="show">
						<button class="btn btn-primary btn-lg btn-block" type="submit" id="add_button" data-loading-text="添加">添加</button>
					</div>
					<p id="tip2" class="bg-danger p15" style="display: none"></p>

					<div class="show">
						<button class="btn btn-primary btn-lg btn-block" type="submit" id="update_button" data-loading-text="更新">更新</button>
					</div>
					<p id="tip3" class="bg-danger p15" style="display: none"></p>
					<div class="show">
						<button class="btn btn-primary btn-lg btn-block" type="submit" id="delete_button" data-loading-text="删除">删除</button>
					</div>
				</form>
			</div>
		</div>

	</div>
</div>

</body>
<script type="text/javascript" src="https://cdn.staticfile.org/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.staticfile.org/twitter-bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="https://cdn.staticfile.org/layer/2.3/layer.js"></script>
<script type="text/javascript">
    $(function(){
        //这里就是放页面加载的时候执行的函数。
        getList();
    })

	function getList() {
        // alert("登陆成功");
        $.ajax({
            url : "${base}/user/list",
            method : "GET",
            dataType : "json",
            success : function(resp) {
                $('#tb1').html('<thead>\n' + '<tr>' +'<td>id</td>' +'<td>用户名</td>' +'<td>年龄</td>' +'<td>创建日期</td>' +'<td>操作</td>' +'<td>操作</td>' +'</tr>' +'</thead>' +'<tbody>' +'' +'</tbody>')
				// $('#tb1').append
                for (var i in resp.list) {
                    var d = resp.list[i];
                    $('#tb1').append('<tr><td>' + d.id + '</td><td>' + d.name +  '</td><td>' + d.age + '</td><td>' + d.createTime + '</td><td>' + '修改' + '</td><td>' + '删除' + '</td></tr>');
                }
            }
        });
	}


    $("#add_button").click(function() {
        // alert("添加用户");
        $.ajax({
            url : "${base}/user/add",
            data : $("#add_form").serialize(),
            method : "POST",
            dataType : "json",
            success : function(resp) {
                // var res = resp;

                // alert("添加成功");
                if (resp.ok) {
                    // alert("true");
                    // getList();
					var d = resp.data;
					$('#tb1').append('<tr><td>' + d.id + '</td><td>' + d.name +  '</td><td>' + d.age + '</td><td>' + d.createTime + '</td><td>' + '修改' + '</td><td>' + '删除' + '</td></tr>');
					alert('添加成功');
                } else {
                    alert('false ' + resp.msg);
                }
            }
        });
        return false;
	});

    $("#update_button").click(function() {
		$.ajax({
			url : "${base}/user/update",
			data : $("#add_form").serialize(),
			method : "POST",
			dataType : "json",
			success : function(resp) {
			    if (resp.ok) {
			        getList();
			        alert('修改成功');
                } else {
			        alert('fasle ' + resp.msg);
                }
            }
		});
		return false;
	});

</script>
</html>