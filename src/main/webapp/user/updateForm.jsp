<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<div class="container">
	<form action="/project4/user?cmd=update" method="post">	<!-- http://localhost:8080/project4/user?cmd=update&id=${user.id} -->
		<input type="hidden" name="id" value="${user.id }">
		<div class="form-group">
			<div class="d-flex justify-content-between">
				<label>Username :</label> 
			</div>				
			<input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" value="${user.username }" readOnly required/>
			<!-- 사용 가능 유저네임일 경우, 수정 못하게 readOnly로 바꾸기 -->
			<!-- ajax -->
			<font id="checkId" size = "2"></font>
		</div>
		
		<div class="form-group">
			<label>Password :</label> 
			<input type="password" name="password" class="form-control" placeholder="Enter Password"  required/>
		</div>
		
		<div class="form-group">
			<label>Email :</label> 
			<input type="email"  name="email" class="form-control" value="${user.email }" placeholder="Enter Email" >
		</div>
		<div class="form-group">
			<div class="d-flex justify-content-between">
				<label>Address :</label> 
				<button type="button" class="btn btn-info" onclick="goPopup();">주소검색</button> <!-- type="button"을 설정하지 않으면 submit이 실행된다 -->
			</div>
			<input type="text"  name="address" id="address"class="form-control" placeholder="Enter Address" value="${user.address }" required readOnly/>
		</div>

<!-- 아이디 기억하기   -->
<!-- 		<div class="form-group form-check">
			<label class="form-check-label"> 
				<input class="form-check-input" type="checkbox"> Remember me
			</label>
		</div> -->
		<br>
		<button type="button" class="btn btn-primary" onclick="history.back()">이전</button>
		<button type="submit" class="btn btn-primary" >회원정보 수정</button>
		<!-- <button type="button" class="btn btn-primary" oncilck="userUpdate()">회원정보 수정</button> -->
	</form>
</div>
 
<script src="/project4/js/userInfo.js"></script>

</body>
</html>