<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="poll.*, java.util.Vector" %>
<jsp:useBean id="pMgr" class="poll.PollMgr" />
<%
	int num = 0;
/*혹시나 null값이 들어올까봐 if문 넣어줘써용용  */
	if(!(request.getParameter("num")==null || request.getParameter("num").equals(""))) {
		num = Integer.parseInt(request.getParameter("num"));
	}
	PollListBean plBean = pMgr.getList(num);
	Vector<String> vlist = pMgr.getItem(num);
	
	String question = plBean.getQuestion();
	int type = plBean.getType();
	int active = plBean.getActive();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3>투표프로그램</h3>
<hr>
<b>설문폼</b>
<form method="post" action="pollFormProc.jsp">
<table>
<tr>
	<td>Q :  <%=question %></td>
</tr>
<tr>
	<%
	for(int i=0; i<vlist.size(); i++){
		String itemList = vlist.get(i);
		if(type ==1) {
			out.print("<input type=checkbox name='itemnum' value='"+i+"'>");
		} else {
			out.print("<input type=radio name='itemnum' value='"+i+"'>");
		}
		out.print(itemList + "<br>");
	}
	%>
</tr>
<tr>
	<td>
		<%
			if(active ==1 ) {
				out.print("<input type='submit' value='투표'>");
			} else {
				out.print("투표");
			}
		%>
		<input type="button" value="결과" onClick="javascript:window.open('pollView.jsp?num=<%=num %>', 'PollView', 'width=500, heigt=350')">
	</td>
</tr>
</table>
<input type="hidden" name="num" value="<%=num %>">
</form>
</body>
</html>