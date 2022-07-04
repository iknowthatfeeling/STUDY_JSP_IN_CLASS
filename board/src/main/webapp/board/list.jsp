<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "board.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="bMgr" class ="board.BoardMgr"/>
<%
	request.setCharacterEncoding("UTF-8");
	int totalRecord = 0;     // 전체 레코드 수 : 68개
	int numPerPage = 10;	// 1페이지당 보여주는 레코드 수
	int pagePerBlock = 5;	// 블록당 페이지 수 [1][2][3][4][5]
	
	int totalPage = 0;		// 전체 페이지 수  [1][2][3][4][5][6][7]
	int totalBlock = 0;		// 전체 블록 수  : 2
	
	int nowPage = 1;		// 현재 레코드가 해당하는 페이지 
	int nowBlock = 1;		// 현재 레코드가 해당하는 블록
	
	int start = 0;			// DB테이블의 select시작번호()
	int end = 0;			// DB테이블에서 페이지에 맞는 10개 가져오기
	int listSize = 0;		// 읽어온 게시물의 수
	
	String keyWord = "", keyField ="";
	Vector<BoardBean> vlist = null;
	if (request.getParameter("keyWord") != null) {
		keyWord = request.getParameter("keyWord");
		keyField = request.getParameter("keyField");
	}
	if (request.getParameter("reload") != null){
		if(request.getParameter("reload").equals("true")) {
			keyWord = "";
			keyField = "";
		}
	}
	if (request.getParameter("nowPage") != null) {
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}
	start = ((nowPage * numPerPage)-numPerPage)+1;
	end = nowPage*numPerPage;
	
	totalRecord = bMgr.getTotalCount(keyField, keyWord);
	totalPage = (int)Math.ceil((double)totalRecord/numPerPage);	// 전체 페이지수
	nowBlock = (int)Math.ceil((double)nowPage/pagePerBlock);	// 현재 블럭 계산
	totalBlock = (int)Math.ceil((double)totalPage/pagePerBlock);	// 전체 블럭 계산
			
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	a:link {text-decoration:none;color:black;}
	a:hover{text-decoration:yes;color:#66CCFF;}
	a:visited {text-decoration:none;}
</style>
<script type="text/javascript">
	function check() {
		if(document.searchFrm.keyWord.value == "") {
			alert("검색어를 입력하세요");
			document.searchFrm.keyWord.focus();
			return;
		}
		document.searchFrm.submit();
	}
	function read(num) {
		document.readFrm.num.value = num;
		document.readFrm.action = "read.jsp";
		document.readFrm.submit();
	}
	function list() {
		document.listFrm.action = "list.jsp";
		document.listFrm.submit();
	}
	function block(value) {
		document.readFrm.nowPage.value=<%=pagePerBlock%>*(value-1)+1;
		document.readFrm.submit();
	}
	function pageing(page) {
		document.readFrm.nowPage.value = page;
		document.readFrm.submit();
	}
</script>
</head>
<body bgcolor="#E1F6FE">
	<h2 align="center">JSPBoard</h2><p/>
	<table align ="center" width="700">
		<tr>
			<td colspan="5">Total : <%=totalRecord %>Articles(<font color="red"><%=nowPage %>/<%=totalPage %></font>page)</td>
		</tr>		
<tr bgcolor="#9465E6" align="center">
			<td width="10%">번호</td>
			<td width="40%">제목</td>
			<td width="15%">이름</td>
			<td width="25%">날짜</td>
			<td width="10%">조회수</td>
		</tr>
		<%
			vlist = bMgr.getBoardList(keyField, keyWord, start, end);
			listSize = vlist.size();
			SimpleDateFormat strFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd");
			if(vlist.isEmpty()) {
				out.print("<tr><td cospan='5'>등록된 게시물이 없습니다</td></tr>");
			} else {
				for (int i=0; i<end; i++) {
					if (i == listSize) 
						break;
					BoardBean bean = vlist.get(i);
					int num = bean.getNum();
					String name = bean.getName();
					String subject = bean.getSubject();
					
					String newdate = bean.getRegdate();
					Date formatDate = strFormat.parse(newdate);
					String regdate = newFormat.format(formatDate);
					
					int depth = bean.getDepth();
					int count = bean.getCount();
		%>
		<tr>
			<td align="center"><%=totalRecord-((nowPage-1)*numPerPage)-i %></td>
			<td>
				<%
					if(depth > 0) {
						for(int j=0; j<depth; j++) {
							out.print("&emsp;");
						}
					}
				%>
				<a href="javascript:read('<%=num %>')"><%=subject %></a>
			</td>
			<td  align="center"><%=name %></td>
			<td  align="center"><%=regdate %></td>
			<td  align="center"><%=count %></td>
		</tr>
		<%
				}
			}
		%>
		<tr>
			<td colspan="5"><br/><br/></td>
		</tr>    
		<tr>
			<!-- 페이징 시작 -->
			<td colspan="3">
			<%			      
				int pageStart = (nowBlock-1) * pagePerBlock +1;  
				int pageEnd = (pageStart + pagePerBlock <= totalPage) ? (pageStart + pagePerBlock) : totalPage+1;
				if(totalPage != 0) {
					if(nowBlock > 1) { %>
						<a href = "javascript:block('<%=nowBlock-1 %>')">prev...</a>
			<%		}
					out.print("&nbsp;");
					for( ; pageStart<pageEnd; pageStart++) { %>
						<a href="javascript:pageing('<%=pageStart%>')">[<%=pageStart %>]</a>																			
			<%
					} 
					out.print("&nbsp;");
					if(totalBlock > nowBlock) { %>	
					<a href= "javascript:block('<%=nowBlock+1 %>')">...next</a>					
			<%							
					}
					out.print("&nbsp;");
				}
			%>

			</td>
			<!-- 페이징 끝 -->
			<td colspan="2" align="right">
				<a href = "post.jsp">[글쓰기]</a>&nbsp;
				<a href = "javascript:list()">[처음으로]</a> 
			</td>
		</tr>
	</table>
	<hr width="700">
	<form name="searchFrm" method="get" action="list.jsp">
		<table align="center" width="800">
			<tr>
				<td align="center">
					<select name="keyField">
						<option value="name">이름</option>
						<option value="subject">제목</option>
						<option value="content">내용</option>
					</select>
					<input name="keyWord">
					<input type="button" value="찾기" onClick="javascript:check()">
					<input type="hidden" name="nowPage" value="1">
				</td>
			</tr>
		</table>
	</form>
	<form name="listFrm" method="post">
		<input type="hidden" name="reload" value="true">
		<input type="hidden" name="nowPage" value="1">
	</form>
	<form name="readFrm" method="get">
		<input type="hidden" name="num">
		<input type="hidden" name="nowPage" value="<%=nowPage %>">
		<input type="hidden" name="keyField" value="<%=keyField %>">
		<input type="hidden" name="keyWord" value="<%=keyWord %>">	
	</form>
</body>
</html>