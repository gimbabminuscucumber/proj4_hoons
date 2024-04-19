<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<div class="container">

	<form action="/project4/user?cmd=join" method="post">	<!-- UserController의 cmd.equals("join") 으로 전달 -->
		
		<div class="form-group">
			<label>Username :</label> 
			<input type="text" name="username" class="form-control" placeholder="Enter Username" required/>
		</div>
		
		<div class="form-group">
			<label>Password :</label> 
			<input type="password" name="password" class="form-control" placeholder="Enter Password" >
		</div>
		
		<div class="form-group">
			<label>Email :</label> 
			<input type="email"  name="email" class="form-control" placeholder="Enter Email" >
		</div>
		<div class="form-group">
			<div class="d-flex justify-content-between">
				<label>Address :</label> 
				<button type="button" class="btn btn-info" onclick="goPopup();">주소검색</button> <!-- type="button"을 설정하지 않으면 submit이 실행된다 -->
			</div>
			<input type="text"  name="address" id="address"class="form-control" placeholder="Enter Address" required readOnly>
		</div>

<!-- 아이디 기억하기   -->
<!-- 		<div class="form-group form-check">
			<label class="form-check-label"> 
				<input class="form-check-input" type="checkbox"> Remember me
			</label>
		</div> -->
		<br>
		<button type="submit" class="btn btn-primary">회원가입 완료</button>
	</form>

</div>
 
<script>
function goPopup(){
	var pop = window.open("/project4/user/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

function jusoCallBack(roadFullAddr){
	var addressElement = document.querySelector("#address");	
	addressElement.value = roadFullAddr;
}

</script>

</body>
</html>