<%@page import="java.net.ConnectException"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.Authenticator"%>
<%@ page import="java.net.PasswordAuthentication"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="static java.lang.System.*"%>
<%@ page import="java.lang.management.ManagementFactory"%>
<%@ page import="java.lang.management.OperatingSystemMXBean"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="java.lang.reflect.Modifier"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<!--By He Feilong
1.本文件放在所有监控的机器。
2.用Java获取系统的freeMemorySize，totalMemorySize（从而获得内存的Usage Rate），CPUUsageRate。
     对于每次服务请求，服务端获取10个上面的三个参数值，两次之间的时间间隔为10ms（用Thread.sleep(10)实现）。
     这样，每次请求可以得到10个内存利用率数值（%）和10个CUP利用率数值（%）。 
3.图形化的显示用SVG实现，柱状图的高度表示内存利用率数值（%）或CUP利用率数值（%）。
     可能会有柱形缺失，源于获取的该数值为0（有可以忽略的精度损失）。
4.页面的刷新：setTimeout('myrefresh()',3000); //指定3秒刷新一次（myrefresh()函数见下面的定义） 。
     点击Stop Refresh Button停止页面的刷新，点击Auto Refresh Button，重启页面的自动刷新。  
--> 

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"
	charset="utf-8"></script>
<style type="text/css">

#mydivcss {
	margin: auto;
	border: 0px solid #000;
	width: 66%;
	height: 100px
}
</style>

<title>Monitor</title>
</head>

<body>
<div id="mydivcss">

<BR><BR>
	<center>
  
	<strong> Memory Usage & CPU Usage Monitor </strong> <BR> <BR>

<%
  out.println("IP address: "+new String(request.getParameter("data").getBytes("ISO-8859-1")));
%>
		</center>

<script type="text/javascript">
  var memoryUsageRate=new Array(), CPUUsageRate=new Array();
 </script>

<script language="JavaScript">

function myrefresh()
{
 window.location.reload();
}

var t;
t=setTimeout('myrefresh()',3000); //指定3秒刷新一次
 
function stop()
{
   clearTimeout(t);
 }

</script>

		<BR> <input type=button value="Auto Refresh"
			onclick="myrefresh()" name="autoRefreshButton"> <input
			type=button value="Stop Refresh" onclick="stop()"><BR>

		<% //response.setIntHeader("Refresh", 5);%>

		<%
int i=0;
while(i++<10){ 
%>

		<% 
  OperatingSystemMXBean operatingSystemMXBean = ManagementFactory.getOperatingSystemMXBean();
  for (Method method : operatingSystemMXBean.getClass().getDeclaredMethods()) {
    method.setAccessible(true);
    if ( ( method.getName().equals("getFreePhysicalMemorySize") || method.getName().equals("getTotalPhysicalMemorySize") || method.getName().equals("getSystemCpuLoad") )
        && Modifier.isPublic(method.getModifiers())) {
            Object value;
        try {
            value = method.invoke(operatingSystemMXBean);
        } catch (Exception e) {
            value = e;
        } // try

        String methodName=method.getName();
     
       %>
		<%//=methodName %>
		<%//=value %>
		<script type="text/javascript">
  var name='<%=methodName%>';
  var freeMemorySize, totalMemorySize;
  if(name=="getFreePhysicalMemorySize")
    freeMemorySize='<%=value %>';
  else if(name=="getTotalPhysicalMemorySize")
    totalMemorySize='<%=value %>';
  else if(name="getSystemCpuLoad")
    CPUUsageRate.push(['<%=value %>']);

 </script>

 <%
    } // if
 try{
  Thread.sleep(10);
   }
 catch(InterruptedException ex){
   %>
  <%=ex.getMessage() %>
  <%
  } 
  } // for
%>

<script type="text/javascript">
  memoryUsageRate.push([(totalMemorySize-freeMemorySize)/totalMemorySize]);
</script>

<%
 }   //while
%>

	<p>Memory Usage Monitor (%)</p>

	<p></p>
	<script type="text/javascript">

	var dataset=[];
	for (var i = 0; i < 10; i++) {
	var axisY=(memoryUsageRate[i])*100;   // percentage
    axisY=axisY.toFixed(2);
	dataset.push(axisY);
	}

      var w = 800;
      var h = 500;
      var barPadding = 1;
      
      //var dataset = [ 5, 10, 13, 19, 21, 25, 22, 18, 15, 13,
      //        11, 12, 15, 20, 18, 17, 16, 18, 23, 25 ];
      
      //Create SVG element
      var svg = d3.select("p")
            .append("svg")
            .attr("width", w)
            .attr("height", h);

      svg.selectAll("rect")
         .data(dataset)
         .enter()
         .append("rect")
         .attr("x", function(d, i) {
            return i * (w / dataset.length);
         })
         .attr("y", function(d) {
            return h - (d * 4);
         })
         .attr("width", w / dataset.length - barPadding)
         .attr("height", function(d) {
            return d * 4;
         })
         .attr("fill", function(d) {
          return "rgb(0, 0, " + (d * 10) + ")";
         });

      svg.selectAll("text")
         .data(dataset)
         .enter()
         .append("text")
         .text(function(d) {
            return d;
         })
         .attr("text-anchor", "middle")
         .attr("x", function(d, i) {
            return i * (w / dataset.length) + (w / dataset.length - barPadding) / 2;
         })
         .attr("y", function(d) {
            return h - (d * 4) + 14;
         })
         .attr("font-family", "sans-serif")
         .attr("font-size", "11px")
         .attr("fill", "white");

</script>

		<p>CPU Usage Monitor (%)</p>

		<script type="text/javascript">

  var dataset=[];
  for (var i = 0; i < 10; i++) {

  var axisY=(CPUUsageRate[i])*100;   // percentage
  axisY=axisY.toFixed(2);
  dataset.push(axisY);
  }

      var w = 800;
      var h = 500;
      var barPadding = 1;
      
      //var dataset = [ 5, 10, 13, 19, 21, 25, 22, 18, 15, 13,
      //        11, 12, 15, 20, 18, 17, 16, 18, 23, 25 ];
      
      //Create SVG element
      var svg = d3.select("p")
            .append("svg")
            .attr("width", w)
            .attr("height", h);

      svg.selectAll("rect")
         .data(dataset)
         .enter()
         .append("rect")
         .attr("x", function(d, i) {
            return i * (w / dataset.length);
         })
         .attr("y", function(d) {
            return h - (d * 4);
         })
         .attr("width", w / dataset.length - barPadding)
         .attr("height", function(d) {
            return d * 4;
         })
         .attr("fill", function(d) {
          return "rgb(0, 0, " + (d * 10) + ")";
         });

      svg.selectAll("text")
         .data(dataset)
         .enter()
         .append("text")
         .text(function(d) {
            return d;
         })
         .attr("text-anchor", "middle")
         .attr("x", function(d, i) {
            return i * (w / dataset.length) + (w / dataset.length - barPadding) / 2;
         })
         .attr("y", function(d) {
            return h - (d * 4) + 14;
         })
         .attr("font-family", "sans-serif")
         .attr("font-size", "11px")
         .attr("fill", "white");

</script>

</div> 
</body>
</html>
