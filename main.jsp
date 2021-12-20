<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>일기장</h2>
	<%
		request.setCharacterEncoding("UTF-8");
		String id = (String) session.getAttribute("id");
		String name = (String) session.getAttribute("name");
		String content = null;
		String title = null;
		String date = null;
		int num = 0;
		int length = 0;
	%>
	
	<table border="1">
		<tr>
			<th>num</th>
			<th>title</th>
			<th>content</th>
			<th>date</th>
			<th>name</th>
		</tr>
	<%
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
			
			String sql = "select * from diary where id=? order by num desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				content = rs.getString(2);
				title = rs.getString(3);
				date = rs.getString(5);
				num = rs.getInt(6);
				
				//내용의 길이가 너무 길면 앞부분만 보이기
				length = content.length();
				if(length>10)
					content = content.substring(0, 10)+"..";
				
				%>
					
				<tr>
					<td><%= num %></td>
					<td><a href="diary.jsp?num=<%= num %>"><%= title %></a></td>
					<td><%= content %></td>
					<td><%= date %></td>
					<td><%= name %></td>
				</tr>
				
				<%
			}
		} catch(Exception e) {
			e.printStackTrace();
			out.println("DB 오류");
		}
		
	%>
	</table>
	<br>
	<input type="button" onclick="location.href='write.html'" value="일기 쓰기"/>
	<input type="button" onclick="location.href='logout.jsp'" value="로그아웃"/>
	
</body>
</html>