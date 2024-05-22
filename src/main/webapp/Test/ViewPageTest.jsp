<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>


<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/star.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">회원가입</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">
	<!-- UserController의 cmd.equals("join") 으로 전달 onsubmit : submit 되면 무조건 실행되는 함수-->
	<form action="/project4/user?cmd=join" method="post" name="join">
		

		<div class="form-group">
			<div class= "d-flex insert-input-container">
				<div class="material-icons-input" style="width: 338px">
					<span class="material-icons">local_phone</span> 
					<input type="text" name="phone" id="phone" class="form-control" placeholder="Enter phone with (-)" required />
				</div>
				<div>
					<button type="button" class="btn btn-info" onclick="phoneCheck()">중복확인</button>
				</div>
			</div>
			<!-- ajax -->
			<div><font id="checkPhone" size="2"></font></div>
		</div>

		<br>

		<button type="button" class="btn btn-outline-secondary" onclick="history.back()">이전</button>
		<button type="button" class="btn btn-primary" style="width: 128px" onclick="joinSuccess()">회원가입 완료</button>
	</form>

</div>

<script>
	var isChecking = false;	
	var phoneChecking = false;

	// ====================================================	
	// 							중복확인 체크 및 미입력 데이터 체크
	// ====================================================	
	function joinSuccess() {				
		var phone = document.getElementById("phone").value;

		if(phoneChecking == false){
			alert('연락처 중복확인을 하세요');
		} else {
			finalCheck();
		}
	}	

	// ====================================================	
	// 												submit
	// ====================================================	
	function finalCheck(){
		var phone = document.getElementById("phone").value;
		
		$.ajax({
			type: "post",
			url: "/project4/user?cmd=join",
			data: {
				phone: phone
			}, success: function(resp){
				console.log("데이터 전송 완료", resp);
				alert('회원가입 완료');
				// 로그인 화면으로 페이지 이동
				window.location.href = "/project4/user/loginForm.jsp";
			}, error: function(xhr, status, error){
				console.log("데이터 전송 에러", error);
			}
		});
	}
	
	// ====================================================	
	// 											연락처 중복확인
	// ====================================================	
	function phoneCheck(){
		
		var phone = document.getElementById("phone").value;
		console.log('phone : ' + phone);
		
		$.ajax({
			type: "post",
			url : "/project4/user?cmd=phoneCheck",
			data : phone,
			contentType : "text/plain; charset=utf-8",
			dataType : "text" 
		}).done(function(data){
			console.log('phoneCheck/data : ' + data);
			if(phone === "" ){
				phoneChecking = false;
				$("#checkPhone").html('(-)를 제외하여 연락처를 입력해주세요.');
				$("#checkPhone").attr('color', 'red');
			}else if(isNaN(phone)){
				phoneChecking = false;
				$("#checkPhone").html('연락처는 숫자로만 입력해주세요.');
				$("#checkPhone").attr('color', 'red');				
		    } else if(phone.length < 11){
		        phoneChecking = false;
		        $("#checkPhone").html('연락처는 11자리 이상 입력해주세요.');
		        $("#checkPhone").attr('color', 'red');		
			}else if(data === 'ok'){
				phoneChecking = false;
				$("#checkPhone").html('해당 연락처는 사용 중입니다.');
				$("#checkPhone").attr('color', 'red');
			}else{
				phoneChecking = true;
				$("#checkPhone").html('해당 연락처는 사용가능합니다.');
				$("#checkPhone").attr('color', 'blue');
			}
		});
	}
	
	// ====================================================	
	// 											주소 API 실행 함수
	// ====================================================			
	function goPopup() {
		console.log("goPopup()");
		var pop = window.open("/project4/user/jusoPopup.jsp", "pop", "width=570,height=420, scrollbars=yes, resizable=yes");
	}

	function jusoCallBack(roadFullAddr) {
		var addressElement = document.querySelector("#address");
		addressElement.value = roadFullAddr;
	}
</script>

</body>

<style>
.material-icons-input {
	display: inline-block;
	position: relative;
}

.material-icons-input input {
	width: 100%;
	padding-left: 40px; 
}

.material-icons-input .material-icons { 
	position: absolute;
	left: 5px; 
	top: 50%;
	transform: translateY(-50%);
}

.insert-input-container {
	display: flex;
	align-items: center;
	justify-content: center; 
}

.insert-input-container .form-control {
	flex: 1; 
	margin-right: 5px; 
}

.insert-input-container .btn {
	flex-shrink: 0;
}
</style>


