<html>
<body>
<h2>Hello World!</h2>
<%--错误写法--%>
<a href="jsp/user/login.jsp">login</a> <br>
<%--正确写法--%>
<a href="user/index">login2</a> <br>
<a href="${base}/user/index">login3</a> <br>
</body>
</html>
