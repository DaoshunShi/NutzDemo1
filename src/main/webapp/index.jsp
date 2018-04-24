<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<html>
<body>
<h2>Hello World!</h2>
<%--错误写法--%>
<a href="jsp/user/login.jsp">login</a> <br>
<%--正确写法--%>
<a href="user/index">login2</a> <br>
<a href="${base}/user/index">login3</a> <br>

</body>
<script type="text/javascript">
    // 开启后自动跳转到登陆页面
    window.location = "${base}/user/index";
</script>
</html>
