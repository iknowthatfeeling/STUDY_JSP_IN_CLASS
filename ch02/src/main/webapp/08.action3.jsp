<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
String name = request.getParameter("name");
%>
include Action�� TOP�Դϵ���<p/>
<%=name %> Fighting!!!!!!�Ӣ�
</body>
</html>