<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
 	// filter를 안타게 하기
	RequestDispatcher dis =
		request.getRequestDispatcher("board?cmd=list&page=0");
	dis.forward(request, response);		// 톰켓이 생성하는 request와 response를 재사용한다 (= 다시 접근하는게 아니라 내부적으로 움직인다)
	
	/*
		sendRedirect() : 톰켓이 request와 response를 외부로 빠져나가서 다시 들어간다 (= 파일 경로를 외부에서 찾는다 = request와 response를 재생성한다)
		dispatcher() : 톰켓이 request와 response를 내부적으로 생성한다 (= 파일 경로를 내부에서 찾는다 = request와 response를 재생성하지 않고 덮어씌운다) 
	*/
	// filter로 인해 접근이 제한 됨 (sendRedirect는 불가, .jsp 요청 자체가 불가)
	// response.sendRedirect("index.jsp"); 
%> 