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
				//비밀번호가 일치할 떄
				if(rs.getString(2).equals(pw)){
					out.println("로그인 성공<br>");
					//세션에 아이디, 이름 정보 저장
					session.setAttribute("id", id);
					name = rs.getString(3);
					session.setAttribute("name", name);
					%>
						<button onclick="location.href='main.jsp'">일기장으로 이동</button><br>
					<%
				}
				else {		//비밀번호가 틀렸을 때
					out.println("비밀번호가 틀립니다.<br>");
					out.println("<a href='login.html'>다시 로그인하기</a>");
				}
			} else {	//아이디가 없을 때
				out.println("아이디가 존재하지 않습니다.<br>");
				out.println("<a href='login.html'>다시 로그인하기</a>");
				out.println("<a href='join.html'>회원가입 하기</a>");
			}
		} catch(Exception e) {
			e.printStackTrace();
			out.println("DB 오류 발생<br>");
			out.println("<a href='login.html'>다시 로그인하기</a>");
		}
	%>
</body>
</html>