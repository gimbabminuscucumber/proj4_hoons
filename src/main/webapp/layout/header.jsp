<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>hoons' grocery store</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
 <!-- marterial css 
 https://materializecss.com/icons.html-->
 <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>

	<!-- 최상단 바 -->
	<nav class="navbar navbar-expand-md bg-dark navbar-dark">
	
		<!-- 로고 -->
		<a class="navbar-brand" href="<%=request.getContextPath()%>/index.jsp">
			<img src="images/hoons2.png" alt="Logo" style="width:90px;">
		</a>
		<!-- 사이트 좌우간격 줄이면 나오는 세 줄 버튼 -->
		<button class="navbar-toggler" type="button" data-toggle="collapse"data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<c:choose>
			<c:when test="${sessionScope.principal != null }">
				<div class="collapse navbar-collapse" id="collapsibleNavbar">
					<!-- 
					<ul class="navbar-nav">
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/board?cmd=saveForm">글쓰기</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=updateForm&id=${sessionScope.principal.id}">회원정보</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=logout">로그아웃</a></li>
					</ul>
					 -->
					 	
					<ul class="navbar-nav">
						<li class="nav-item"><a class="nav-link" href="#">로그인 된 상태</a></li>
						<li class="nav-item"><a class="nav-link" href="#">1111</a></li>
						<li class="nav-item"><a class="nav-link" href="#">2222</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=logout">로그아웃</a></li>
					</ul>
	
					<!-- 
						1. 드롭다운 칸이 짤림
						2. 드롭다운 링크 클릭 안됨 
					-->
	                <ul class="navbar-nav ml-auto" style="cursor:pointer">
	                    <li class="d-flex dropdown" data-toggle="dropdown">
	                    	<img src="images/user.png" alt="Logo" style="width:40px; heigh:1px">
							<a class="nav-link" href="#">${sessionScope.principal.username}</a>
							<div class="dropdown-menu ">
								<a class="dropdown-item" href="<%=request.getContextPath()%>/board?cmd=saveForm">글쓰기</a>
								<a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=updateForm&id=${sessionScope.principal.id}">회원정보</a>
								<a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=logout">로그아웃</a>
								<a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=logout">1234567890</a>
							</div>
						</li>
					</ul>
					<!-- 드롭다운 -->
					<!-- 
						<div class="dropdown">
							<div data-toggle="dropdown"  style="cursor:pointer">
								<img src="images/user.png" alt="Logo" style="width:25px;">&nbsp;
								<a style="color: white">${sessionScope.principal.username}</a>    
								<div class="dropdown-menu">
									<a class="dropdown-item" href="<%=request.getContextPath()%>/board?cmd=saveForm">글쓰기</a>
									<a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=updateForm&id=${sessionScope.principal.id}">회원정보</a>
									<a class="dropdown-item" href="<%=request.getContextPath()%>/user?cmd=logout">로그아웃</a>
								</div>
							</div>
						</div>
					 -->	
						
				</div>
			</c:when>
			<c:otherwise>
				<div class="collapse navbar-collapse" id="collapsibleNavbar">
					<ul class="navbar-nav">
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=joinForm">회원가입</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=loginForm">로그인</a></li>
						<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/user?cmd=test">페이지 테스트</a></li>
					</ul>
				</div>
			</c:otherwise>
		</c:choose>

	</nav>
	<br>