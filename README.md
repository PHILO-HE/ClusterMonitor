# ClusterMonitor
Monitor the CPU/Memory utilization rate for nodes in a cluster


This project has been tested on my server.
You can visit  

http://114.215.150.15:8080/JSP-Project/

and use the default IP address in the home page to experience the provided web service.


Project Requirements
===========
Below are the project requirements.

1. A Web application to monitor/present server CPU/Memory utilization trend
2. Front end requires two page. One page accept the request which allow user to input the server name/ip. 
   The second page presents the CPC/Memory utilization trend with auto refresh and disable button.
3. Back end to schedule the metric collection job against the requested server in 30sec interval.
4. Please send both source code and runnable war package within 5 working days.

This project was designed just according to my own understanding of the above requirements.
I did not figure out Item 3, so in my project it was not considered.


Introduction
============
The technologies used in my project: HTML, JavaScript, JSP, SVG, CSS.

The first page (source code: index.html) requires the user to type the IP address for a machine.
And the second page (source code: monitor.jsp) gives the monitor service.

With employing SVG, the second page presents the Memory Usage Rate and CPU Usage Rate.
Press Stop Refresh button, the second page will stop refreshing.
Press Auto Refresh button, the refreshing will continue. 
By default, the secont page is auto refreshing after its first loading.


Test Environment
================
1. Ubuntu 14.04
2. apache-tomcat-8.0.36
3. Firefox

I do not guarantee that this web service works well in the different environment.


Deployment
==========
Dispatch JSP-Project.war to the servers needed to be monitored.
JSP-Project.war is placed in the default web service path (for example, tomcat_install_path/webapps/ for tomcat by default).
And necessarily the service port is 8080.

