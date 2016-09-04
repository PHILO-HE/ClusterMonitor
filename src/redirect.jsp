<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<html>

<!-- 代码说明     By He Feilong

收到用户提供的监控机器的IP地址后，访问该监控机器下的jsp文件（位于下面的path路径下），同时也将IP地址发送给该jsp文件
--> 

<body>

<%String ip= new String(request.getParameter("ip").getBytes("ISO-8859-1")); %>
<%String path="http://"+ip+":8080/JSP-Project/monitor.jsp?data="+ip; %>
<%response.sendRedirect(path);%>

</body>
</html>