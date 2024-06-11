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
			<div class="d-flex insert-input-container">
				<div class="material-icons-input" style="width: 338px">
					<span class="material-icons">person_outline</span> 
					<input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required />
				</div>
				<div>
					<button type="button" class="btn btn-info" onclick="usernameCheck()">중복확인</button>
				</div>
			</div>
			<!-- ajax -->
			<div><font id="checkId" size="2"></font></div>
		</div>
			

		<div class="form-group">
			<div class= "d-flex insert-input-container">
				<div class="material-icons-input" style="width: 338px">
					<span class="material-icons">face</span> 
					<input type="text" name="nickName" id="nickName" class="form-control" placeholder="Enter NickName" required />
				</div>
				<div>
					<button type="button" class="btn btn-info" onclick="nickNameCheck()">중복확인</button>
				</div>
			</div>
			<!-- ajax -->
			<div><font id="checkNickName" size="2"></font></div>
		</div>
		

		<div class="form-group insert-input-container">
			<div class="material-icons-input" style="width: 419px">
				<span class="material-icons">lock_outline</span> 
				<input type="password" id="password" name="password" class="form-control" placeholder="Enter Password"  oninput="inputPwd()">
			</div>
		</div>


		<div class="form-group">
			<div class= "d-flex insert-input-container">
				<div class="material-icons-input" style="width: 338px">
					<span class="material-icons">local_phone</span> 
					<input type="text" name="phone" id="phone" class="form-control" placeholder="Enter phone without (-)" required />
				</div>
				<div>
					<button type="button" class="btn btn-info" onclick="phoneCheck()">중복확인</button>
				</div>
			</div>
			<!-- ajax -->
			<div><font id="checkPhone" size="2"></font></div>
		</div>



		<div class="form-group">
			<div class= "d-flex insert-input-container">
				<div class="material-icons-input" style="width: 338px">
					<span class="material-icons">personal_video</span> 
					<input type="text" name="email" id="email" class="form-control" placeholder="Enter Email" required />
				</div>
				<div>
					<button type="button" class="btn btn-info" onclick="emailCheck()">중복확인</button>
				</div>
			</div>
			<!-- ajax -->
			<div><font id="checkEmail" size="2"></font></div>
		</div>
		

		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input" style="width: 338px">
				<span class="material-icons">home</span> 
				<input type="text" name="address" id="address" class="form-control" placeholder="Enter Address"  readOnly required />
			</div>
			<div>
				<button type="button" class="btn btn-info" onclick="goPopup();">주소검색</button>
				<!-- type="button"을 설정하지 않으면 submit이 실행된다 -->
			</div>
		</div>

		<br>

		<button type="button" class="btn btn-outline-secondary" onclick="history.back()">이전</button>
		<button type="button" class="btn btn-primary" style="width: 128px" onclick="joinSuccess()">회원가입 완료</button>
	</form>

</div>

<script>
	var userChecking = false;
	var emailChecking = false;
	var isChecking = false;	
	var nickNameChecking = false;
	var phoneChecking = false;

	// ====================================================	
	// 							중복확인 체크 및 미입력 데이터 체크
	// ====================================================	
	function joinSuccess() {				
		var username = document.getElementById("username").value;
		var nickName = document.getElementById("nickName").value;
		var password = document.getElementById("password").value;
		var phone = document.getElementById("phone").value;
		var email = document.getElementById("email").value;
		var address = document.getElementById("address").value;

		if (userChecking == false) {
			alert('아이디 중복확인을 하세요');
			isChecking = false;
		} else if(nickNameChecking == false){
			console.log('nickName : ' + nickName);
			alert('닉네임 중복확인을 하세요');
			isChecking = false;
		} else if(password === ''){
			console.log('password : ' + password);
			alert('비밀번호를 입력하세요');
			isChecking = false;
		} else if(phoneChecking == false){
			alert('연락처 중복확인을 하세요');
			isChecking = false;
		} else if (emailChecking == false) {
			alert('이메일 중복확인을 하세요');
			isChecking = false;
		} else if(userChecking == true && emailChecking == true && nickNameChecking == true) {
			isChecking = true;
			finalCheck();
		}
	}	

	// ====================================================	
	// 												submit
	// ====================================================	
	function finalCheck(){
		var username = document.getElementById("username").value;
		var nickName = document.getElementById("nickName").value;
		var password = document.getElementById("password").value;
		var phone = document.getElementById("phone").value;
		var email = document.getElementById("email").value /*+ document.getElementById("domain").value*/;
		var address = document.getElementById("address").value;
		
		$.ajax({
			type: "post",
			url: "/project4/user?cmd=join",
			data: {
				username: username,
				nickName: nickName,
				password: password,
				phone: phone,
				email: email,
				address: address
			}, success: function(resp){
				console.log("데이터 전송 완료", resp);
				alert('회원가입 완료');
				// 로그인 화면으로 페이지 이동
				window.location.href = "/project4/user?cmd=loginForm";
			}, error: function(xhr, status, error){
				console.log("데이터 전송 에러", error);
			}
		});
	}
	
	// ====================================================	
	// 										username 중복확인
	// ====================================================	
	function usernameCheck() {
		// DB에서 확인 후 아이디가 중복이 아니면 isChecking = true로 변경
		var username = $("#username").val();

		/*
		// type test (json과 text)
		var a = "{\"result\" : \"a\"}";
		var b = {result: "b"}
		
		console.log(a);				// text (결과값의 외형은 json 같지만 text type 이다)
		console.log(b);				// json (데이터를 Java object로 다 바꿔줌 / key:value 로 엮인 json type이다)
		console.log(b.result);		// json일 경우, Java object로 바꾸기 때문에 .result 같은 기능을 사용할 수 있음
		 */

		$.ajax({
			type : "POST",
			url : "/project4/user?cmd=usernameCheck",
			data : username,
			contentType : "text/plain; charset=utf-8",
			dataType : "text" // 응답받을 데이터 타입 ("json"은 Java object로 파싱해줌)
		}).done(function(data) { // .done() : 통신이 끝나면 실행할 기능
			if (username === '') { // 유저네임이 공란
				console.log('공란 : data : ' + data);
				console.log('공란 : username : ' + username);

				userChecking = false; // 신규 아이디로 중복허용 후, 다시 중복된 아이디로 회원가입할 수 있으니 잘못된 경우는 다 isChecking="false"로
				//alert('유저네임을 입력해주세요.')
				$("#checkId").html('유저네임을 입력해주세요.');
				$("#checkId").attr('color', 'red');
			} else if (data === 'ok') { // 유저네임이 중복 됨
				console.log('중복 : data : ' + data);
				console.log('중복 : username : ' + username);

				userChecking = false;
				//alert('유저네임이 중복되었습니다.')
				$("#checkId").html('유저네임이 중복되었습니다.');
				$("#checkId").attr('color', 'red');
			} else { // 유저네임이 중복 안 됨
				console.log('신규 : data : ' + data);
				console.log('신규 : username : ' + username);

				userChecking = true;
				//alert('해당 유저네임은 사용가능합니다.')
				$("#checkId").html('해당 유저네임은 사용가능합니다.');
				$("#checkId").attr('color', 'blue');
			}
		});
	}

	// 비밀번호 입력데이터 받아오기 > 회원가입 완료 버튼 클릭시, 미입력 상태면 alert 주려고
	function inputPwd(){
		password = document.getElementById("password").value;
	}
	
	// ====================================================	
	// 											email 중복확인
	// ====================================================	
	function emailCheck() {
		var email = document.getElementById("email").value;
		//var email = $("#email").val();
		
		$.ajax({
			type : "post",
			url : "/project4/user?cmd=emailCheck",
			data : email, 												// email 데이터를 객체 형태로 전달
			contentType : "text/plain; charset=utf-8",
			dataType : "text"										// 서버에서 받을 데이터 타입
		}).done(function(data) {
			if (email == undefined || data === "" || email == "") {
				console.log('공란 : data : ' + data);
				console.log('공란 : email : ' + email);
				emailChecking = false;					// 신규 아이디로 중복허용 후, 다시 중복된 아이디로 회원가입할 수 있으니 잘못된 경우는 다 isChecking="false"로
				$("#checkEmail").html('이메일을 입력해주세요.');
				$("#checkEmail").attr('color', 'red');
			} else if (data === 'ok') {
				console.log('중복 : data : ' + data);
				console.log('중복 : email : ' + email);
				emailChecking = false;
				$("#checkEmail").html('동일한 이메일로 가입한 내역이 있습니다.');
				$("#checkEmail").attr('color', 'red');
			} else if (email.indexOf('@') === -1) {		// 해당 문자열이 없으면
				console.log('오류 : data : ' + data);
				console.log('오류 : email : ' + email);
				emailChecking = false;
				$("#checkEmail").html('도메인을 입력해주세요.');
				$("#checkEmail").attr('color', 'red');
			} else {
				console.log('신규 : data : ' + data);
				console.log('신규 : email : ' + email);
				emailChecking = true;
				$("#checkEmail").html('해당 이메일은 사용가능합니다.');
				$("#checkEmail").attr('color', 'blue');
			}
		})
	}

	// ====================================================	
	// 											닉네임 중복확인
	// ====================================================	
	function nickNameCheck(){
		
		var nickName = document.getElementById("nickName").value;
		console.log('nickName : ' + nickName);
		
		$.ajax({
			type: "post",
			url : "/project4/user?cmd=nickNameCheck",
			data : nickName,
			contentType : "text/plain; charset=utf-8",
			dataType : "text" 
		}).done(function(data){
			if(nickName === "" ){
				nickNameChecking = false;
				$("#checkNickName").html('닉네임을 입력해주세요.');
				$("#checkNickName").attr('color', 'red');
			}else if(data === 'ok'){
				nickNameChecking = false;
				$("#checkNickName").html('해당 닉네임은 사용 중입니다.');
				$("#checkNickName").attr('color', 'red');
			}else{
				nickNameChecking = true;
				$("#checkNickName").html('해당 닉네임은 사용가능합니다.');
				$("#checkNickName").attr('color', 'blue');
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
		        $("#checkPhone").html('연락처는 11자리까지 입력해주세요.');
		        $("#checkPhone").attr('color', 'red');		
		    } else if(phone.length > 11){
		        phoneChecking = false;
		        $("#checkPhone").html('연락처는 12자리 미만으로 입력해주세요.');
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


