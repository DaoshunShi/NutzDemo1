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
<div id="app">
	<div id="top_nav">
		<a href="${base}/user/logout">登出</a>
	</div>
	<div>
		<%--<table id="table-User">--%>
			<%--<thead>--%>
				<%--<tr>--%>
					<%--<td>id</td>--%>
					<%--<td>用户名</td>--%>
					<%--<td>创建日期</td>--%>
					<%--<td>操作</td>--%>
				<%--</tr>--%>
			<%--</thead>--%>
			<%--<tbody>--%>

			<%--</tbody>--%>
		<%--</table>--%>
		<table id="tb1" border="2">
			<th>id</th>
			<th>用户名</th>
			<th>创建日期</th>
			<th>操作</th>
		</table>
	</div>
	<div>
		<a href="#">上一页</a>
		<a href="#">下一页</a>
	</div>
</div>
</body>
<script type="text/javascript" src="https://cdn.staticfile.org/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.staticfile.org/twitter-bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script type="text/javascript" src="https://cdn.staticfile.org/layer/2.3/layer.js"></script>
<script type="text/javascript">
    $(function(){
        //这里就是放页面加载的时候执行的函数。
		alert("登陆成功");
        $.ajax({
            url : "${base}/user/list",
            method : "GET",
            dataType : "json",
            success : function(resp) {
                // if (resp) {
					// alert("读取list");
                // }
                // $('#tb1').append('<tr><td>' + )
                // $('#tb1').html('');
				for (var i in resp.list) {
				    var d = resp.list[i];
				    $('#tb1').append('<tr><td>' + d.id + '</td><td>' + d.name + '</td><td>' + d.age + '</td><td>' + d.createTime + '</td></tr>')
                }
            },
			error : function (resp) {
				alert("读取List失败");
            }
        });
    })
</script>
</html>