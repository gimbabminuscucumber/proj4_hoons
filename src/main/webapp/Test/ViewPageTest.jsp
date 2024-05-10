<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>


<br>
<br>
<h1 style="text-align: center">
	<div style="color: #077BFF;">Insert Infomation</div>
</h1>
<br>
<br>


<div class="container" style="text-align: center">
	<!-- UserController의 cmd.equals("join") 으로 전달 onsubmit : submit 되면 무조건 실행되는 함수-->
	<form action="/project4/user?cmd=join" method="post" name="join">
		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input" style="width: 338px">
				<span class="material-icons">person_outline</span> 
				<input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required />
			</div>
			<div>
				<button type="button" class="btn btn-info" onclick="usernameCheck()">중복확인</button>
			</div>
		</div>
		<!-- ajax -->
		<p>
			<font id="checkId" size="2"></font>
		</p>

		<div class="form-group insert-input-container">
			<div class="material-icons-input" style="width: 419px">
				<span class="material-icons">lock_outline</span> 
				<input type="password" id="password" name="password" class="form-control" placeholder="Enter Password"  oninput="inputPwd()">
			</div>
		</div>

		<div class="form-group insert-input-container">
			<div class="material-icons-input" style="width: 183px">
				<span class="material-icons">personal_video</span> 
				<input type="text" name="email" id="inputEmail" class="form-control" placeholder="Enter Email" oninput="emailCombine()"  required /> 
				<!-- oninput(): 입력 필드의 값이 변경될 때마다 발생. 사용자가 입력을 하면 즉시 발생 -->
			</div>

 			<div class="email domain dropdown">
				<select id="domain" class="custom-select" style="width: 155px" onchange="emailCombine()" >
				<!-- onchange(): 입력 필드의 값이 변경되고 사용자가 입력을 완료하고 필드를 떠날 때 발생 -->
					<option selected disabled>@example.com</option>
					<option value="@naver.com">@naver.com</option>
					<option value="@gmail.com">@gmail.com</option>
					<option value="@nate.com">@nate.com</option>
					<option value="@daum.net">@daum.net</option>
				</select>
			</div>
			<button type="button" id="domain" class="btn btn-info" onclick="emailCheck()">중복확인</button>
		</div>
		<!-- ajax -->
		<p><font id="checkEmail" size="2"></font></p>

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

		<!-- 아이디 기억하기   -->
		<!-- 		<div class="form-group form-check">
			<label class="form-check-label"> 
				<input class="form-check-input" type="checkbox"> Remember me
			</label>
		</div> -->
		<br>

		<button type="button" class="btn btn-primary" style="width: 128px" onclick="joinSuccess()">회원가입 완료</button>
		<button type="button" class="btn btn-outline-secondary" onclick="history.back()">이전</button>
	</form>

</div>

<script>
	var userChecking = false;
	var emailChecking = false;
	var isChecking = false;

	/*
	var username = document.getElementById("username").value;
	var password;
	var email;
	var address = document.getElementById("address").value;
	*/
	
	// 중복확인 체크 및 미입력 데이터 체크
	function joinSuccess() {				
		var username = document.getElementById("username").value;
		var password = document.getElementById("password").value;
		var email = document.getElementById("inputEmail").value + document.getElementById("domain").value;
		var address = document.getElementById("address").value;

		if (userChecking == false) {
			alert("아이디 중복확인을 하세요");
			isChecking = false;
		} else if(password === ''){
			console.log('password : ' + password);
			alert("비밀번호를 입력하세요");
		} else if (emailChecking == false) {
			console.log('password : ' + password);
			alert("이메일 중복확인을 하세요");
			isChecking = false;
		} else if(userChecking == true && emailChecking == true) {
			isChecking = true;
			//document.join.submit();
			finalCheck();
		}
	}	

	// submit
	function finalCheck(){
		var username = document.getElementById("username").value;
		var password = document.getElementById("password").value;
		var email = document.getElementById("inputEmail").value + document.getElementById("domain").value;
		var address = document.getElementById("address").value;
		
		$.ajax({
			type: "post",
			url: "/project4/user?cmd=join",
			data: {
				username: username,
				password: password,
				email: email,
				address: address
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
	
	// username 중복확인
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
	
	// input 데이터와 dropdown를 합치려고
	function emailCombine() {
		var inputEmail = document.getElementById("inputEmail").value;
		var domain = document.getElementById("domain").value;
		//var email = inputEmail + domain;			// var로 email에 데이터를 전달하면 전역변수로 설정한 var email과 다른 메모릴에 저장돼서 다른 함수에서 사용 불가
		email = inputEmail + domain; 					// 다른 함수에서 email 값을 사용하기 위해선 var, const 같은 키워드를 사용하면 안됨
	}

	// email 중복확인
	function emailCheck() {
		console.log('email : ' + email); // emailCombine() 에서 email 을 받아옴

		$.ajax({
			type : "post",
			url : "/project4/user?cmd=emailCheck",
			data : email, // email 데이터를 객체 형태로 전달
			contentType : "text/plain; charset=utf-8",
			dataType : "text" // 서버에서 받을 데이터 타입
		}).done(function(data) {
			if (email == undefined || data === "") {
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
			} else if (email.indexOf('@example.com') !== -1) {
				console.log('오류 : data : ' + data);
				console.log('오류 : email : ' + email);
				emailChecking = false;
				$("#checkEmail").html('도메인을 선택해주세요.');
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

	// 주소 API 실행 함수
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
.material-icons-input { /* input 될 아이콘 칸 */
	display: inline-block;
	position: relative;
}

.material-icons-input input { /* 아이콘이 포함된 input 태그 */
	width: 100%;
	padding-left: 40px; /* 예시: 좀 더 넓은 여백을 주기 위해 padding-left 값 조정 */
}

.material-icons-input .material-icons { /* 아이콘 위치 */
	position: absolute;
	left: 5px; /* 아이콘을 왼쪽에 위치 */
	top: 50%;
	transform: translateY(-50%);
}

/* 이메일 입력 칸과 버튼 간의 간격 조절 */
.insert-input-container {
	display: flex;
	align-items: center; /* 세로 정렬을 위해 */
	justify-content: center; /* 수평 정렬을 위해 */
}

.insert-input-container .form-control {
	flex: 1; /* 입력 칸이 버튼의 크기에 따라 유동적으로 변할 수 있도록 */
	margin-right: 5px; /* 버튼과의 간격 조절 */
}

.insert-input-container .btn {
	flex-shrink: 0; /* 버튼이 입력 칸의 크기에 영향을 받지 않도록 */
}
</style>
</html>