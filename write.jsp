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
	<%
		request.setCharacterEncoding("UTF-8");
	
		int result = -1;
		int num = 1;	//내용 번호
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String id = (String) session.getAttribute("id");
		String name = (String) session.getAttribute("name");
		String date = null;
		String color = request.getParameter("color");
		

		if(title == null  || title.equals("")) {
			%>
			<script>
			alert("제목이 입력되지 않았습니다.");
			location.href='write.html';
			</script>
			<%
			return;
		}
		if(content == null || content.equals("")) {
			%>
			<script>
			alert("내용이 입력되지 않았습니다.");
			location.href='write.html';
			</script>
			<%
			return;
		}
		
		String driver = "com.mysql.jdbc.Driver";
		String jdbcurl = "jdbc:mysql://localhost:3306/project?serverTimezone=UTC";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			//드라이버 로드
	        Class.forName(driver);
			
			//연결
			conn = DriverManager.getConnection(jdbcurl, "root", "0000");
	        
			//가장 최근 일기의 번호 가져와서 그 다음 번호로 저장
			String sql = "select num from diary where id=? order by num desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {	//최근 글이 존재하는 경우
				num = rs.getInt(1) + 1;
			}
			
			//날짜 정보 가져오기
			sql = "select now()";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				date = rs.getString(1);
			}
			
			//diary db에 정보 입력하기
			sql = "insert into diary values(?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, content);
			pstmt.setString(3, title);
			pstmt.setString(4, name);
			pstmt.setString(5, date);
			pstmt.setInt(6, num);
			pstmt.setString(7, color);
			
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			out.println("DB오류<br>");
		}
		
		if(result == -1) {	//오류 발생
			%>
				<script>
				alert("오류 발생.");
				location.href='main.jsp';
				</script>
			<%
		} else {	//오류 없이 저장
			%>
				<script>
				alert("저장되었습니다.");
				location.href='main.jsp';
				</script>
			<%
		}
	%>
</body>
</html>