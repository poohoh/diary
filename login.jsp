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
		
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String name = null;
		
		if(id=="" || pw=="") {
			%>
			<script>
			alert("아아디 또는 비밀번호가 입력되지 않았습니다.");
			location.href='login.html';
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
			Class.forName(driver);
			
			conn=DriverManager.getConnection(jdbcurl, "root", "0000");
			
			String sql = "select * from members where id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			//아이디가 있을 때
			if(rs.next()) {
				//비밀번호가 일치할 때
				if(rs.getString(2).equals(pw)){
					//세션에 아이디, 이름 정보 저장
					session.setAttribute("id", id);
					name = rs.getString(3);
					session.setAttribute("name", name);
					%>
						<script>
							alert("로그인 성공");
							location.href="main.jsp";
						</script>
					<%
				}
				else {		//비밀번호가 틀렸을 때
					%>
						<script>
						alert("비밀번호가 틀립니다.");
						location.href='login.html';
						</script>
					<%
					return;
				}
			} else {	//아이디가 없을 때
				%>
					<script>
					alert("아이디가 존재하지 않습니다.");
					location.href="login.html";
					</script>
					
				<%
			}
		} catch(Exception e) {
			e.printStackTrace();
			out.println("DB 오류 발생<br>");
			out.println("<a href='login.html'>다시 로그인하기</a>");
		}
	%>
</body>
</html>