<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%request.setCharacterEncoding("EUC-KR"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
String season = request.getParameter("season");
String fruit = request.getParameter("fruit");
String id = (String)session.getAttribute("idKey");
String sessionId = session.getId();
int intervalTime = session.getMaxInactiveInterval();
%>
<%
	if(id != null){
%>
<h1>Session Ex</h1>
<%=id %>님은 <%=season %>과 <%=fruit %>를 사랑하십니다.<p/>
세션 ID : <%=sessionId %><p/>
세션 유지시간 : <%=intervalTime %>초<p/>
<%
	session.invalidate();
} else {
	out.print("세션의 시간이 경과하였거나 다른 이유로 연결할 수 없습니다.");
}
%>
</body>
</html>