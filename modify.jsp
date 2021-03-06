<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	.box {
		background-color:#f5d682;
		border: 1px solid black;
		vertical-align:top;
	}
</style>
</head>
<body>
	<form action="modify-db.jsp" method="post">
	
	<%
		request.setCharacterEncoding("UTF-8");
		
		int num= (int) session.getAttribute("num");
		String id = (String) session.getAttribute("id");
		String content = null;
		String title = null;
		String date = null;
		String name = (String) session.getAttribute("name");
		
		//연결 설정
		String driver = "com.mysql.jdbc.Driver";
		String jdbcurl = "jdbc:mysql://localhost:3306/project?serverTimezone=UTC";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//db 접속
				try {
					//드라이버 설정
					Class.forName(driver);
					
					//연결 설정
					conn = DriverManager.getConnection(jdbcurl, "root", "0000");
					
					//db에서 선택한 일기 가져오기
					String sql = "select * from diary where id=? and num=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, id);
					pstmt.setInt(2, num);
					rs = pstmt.executeQuery();
					
					//db에서 가져온 일기에 대한 정보를 기본값으로 출력하고 수정
					if(rs.next()) {
						content = rs.getString(2);
						title = rs.getString(3);
						date = rs.getString(5);
						
						
						%>
						<table>
							<tr>
							<td>번호 : <%= num %></td>
							</tr>
							<tr>
							<td>작성자 : <%= name %></td>
							</tr>
							<tr>
							<td>최근 작성 날짜 : <%= date %></td>
							</tr>
							<tr>
								<td>제목 : </td><td><input type="text" id="ipt_title" name="title" value="<%=title %>" class="box" /></td>
							</tr>
							<tr>
								<td>내용 : </td><td><textarea name="content" id="ipt_content" class="box" style="height:200px;width:300px;"><%=content %></textarea></td>
							</tr>
						</table>
						<%
					}
				} catch(Exception e) {
					e.printStackTrace();
					out.println("DB 오류");
				}
	%>
	<input type="submit" value="저장"/>
	<input type="button" onclick="location.href='diary.jsp?num=<%=num %>'" value="취소"/>
	<input type="button" id="btn_initialize" value="초기화" />
	</form>
	
	<script>
	btn_initialize.addEventListener("click", function() {
		ipt_title.value = "";
		ipt_content.value = "";
	});
	</script>
</body>
</html>