<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<a href="<%=request.getContextPath()%>/index.jsp">
	<h1 style="text-align: center">My SNS</h1>
</a>
<br>
<br>


<!-- <div class="container"> -->
<div class="container" style="width: 35%">

	<form action="/project4/user?cmd=login" method="post" >
	<!-- <form> 태그에 데이터를 담아서 POST 로 보내면 Key=Value 형태로 간다 (x-www-form-urlencoded) -->
		<div class="form-group">
			<div class="d-flex justify-content-between">
				<label>Username :</label>
			</div>
			<input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required />
			<!-- ajax -->
			<font id="checkId" size="2"></font>
		</div>

		<div class="form-group">
			<label>Password :</label> <input type="password" name="password" class="form-control" placeholder="Enter Password" required/>
		</div>

		<!-- 아이디 기억하기   -->
		<!-- 		<div class="form-group form-check">
			<label class="form-check-label"> 
				<input class="form-check-input" type="checkbox"> Remember me
			</label>
		</div> -->
		<br>
		<div class="d-flex">
			<button type="submit" class="mr-auto btn btn-primary" style="width: 100%">로그인 하기</button>
		</div>
		<br>
	</form>
</div>

<div class="container d-flex justify-content-center" style="width: 35%; color: grey;">
	<div onclick="searchUsername()" style="cursor: pointer;">아이디 찾기</div> ㅣ 
	<div onclick="searchPassword()" style="cursor: pointer;">비밀번호 찾기</div>
</div>
		<%--
		<div>
			<button type="button" class="btn btn-info" onclick="searchUsername()">아이디 찾기</button>&nbsp;
			<button type="button" class="btn btn-info" onclick="searchPassword()">비밀번호 찾기</button>
		</div>
	</form>
</div>
		 --%>

<script src="/project4/js/userInfo.js"></script>

</body>
</html>