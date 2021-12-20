<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<% 
		request.setCharacterEncoding("UTF-8"); 
		
		int num = (int)session.getAttribute("num");	//내용 번호
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String id = (String) session.getAttribute("id");
		String date = null;
		
		if(title.equals("") || content.equals("")) { //제목이 입력되지 않았을 때
			%>
				<script>
				alert("제목 또는 내용을 입력해주세요.");
				location.href='modify.jsp';
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
			//드라이버 설정
			Class.forName(driver);
			
			//연결 설정
			conn = DriverManager.getConnection(jdbcurl, "root", "0000");
			
			//날짜 가져오기
			String sql = "select now()";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				date = rs.getString(1);
			}
			
			//db 수정
			sql = "update diary set content=?, title=?, date=? where id=? and num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, content);
			pstmt.setString(2, title);
			pstmt.setString(3, date);
			pstmt.setString(4, id);
			pstmt.setInt(5, num);
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
			out.println("DB오류<br>");
		}
	%>
	<script>
		alert("수정이 완료되었습니다.");
		location.href="main.jsp";
	</script>
</body>
</html>