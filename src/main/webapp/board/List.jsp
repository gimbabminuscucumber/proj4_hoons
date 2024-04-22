<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../layout/header.jsp"%>

<h1>세션 테스트</h1>
로그인 유저 네임 : ${sessionScope.principal.username }	<!-- Request가 아니면 sessionScope -->
</body>
</html>
