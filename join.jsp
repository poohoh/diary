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
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String name = request.getParameter("name");
		
		String driver = "com.mysql.jdbc.Driver";
		String jdbcurl = "jdbc:mysql://localhost:3306/project?serverTimezone=UTC";
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		if(id=="" || pw=="" || name=="") { //입력하지 않은 항목이 있을 때
			%>
			<script>
			alert("내용이 입력되지 않았습니다.");
			location.href='join.html';
			</script>
			<%
			return;
		} else{	//제대로 입력되었을 때
			try{
				//드라이버 로드
		        Class.forName(driver);
				
				//연결
				conn = DriverManager.getConnection(jdbcurl, "root", "0000");
		        
				//members에 받아온 정보를 입력하기
				String sql = "insert into members values(?, ?, ?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, pw);
				pstmt.setString(3, name);
				
				result = pstmt.executeUpdate();

			} catch (Exception e) {
				e.printStackTrace();
		    }
			
			if(result == -1){	//이미 회원인 경우
				%>
					<script>
					alert("중복된 ID입니다.");
					location.href="join.html";
					</script>
				<%
			} else {	//회원이 아니었을 경우
				%>
					<script>
					alert("가입이 완료되었습니다.");
					location.href="login.html";
					</script>
				<%
			}
			pstmt.close();
			conn.close();
		}
	%>
</body>
</html>