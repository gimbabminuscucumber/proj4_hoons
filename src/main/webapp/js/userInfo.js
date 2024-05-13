
// ====================================================	
// 												유저네임 찾기
// ====================================================		
function searchUsername(){
	console.log("searchUsername()");
	var pop = window.open("/project4/user/searchUsername.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

// ====================================================	
// 												비밀번호 찾기
// ====================================================		
function searchPassword(){
	console.log("searchPassword()");
	var pop = window.open("/project4/user/searchPassword.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
	// 비밀번호를 이메일로 보내기
}

// ====================================================	
// 				로그인시 아이디&비번 틀리면 로그인 실패 메세지 띄우기
// ====================================================		
function logCheck() {
	console.log("logCheck");
	
	var username = document.getElementById("username").value;
	var password = document.getElementById("password").value;
	
	var data ={
		username: username,
		password: password
	}

	// 유저네임 기억하기 로직
	var checkbox = document.getElementById("remember");				// 체크박스 id 가져오기
	if(checkbox.checked){																		// 체크박스 true 면,
		localStorage.setItem("rememberUsername", username);			// localStorage에 데이터 저장 (로그인 페이지가 onload 될 때 username 데이터 사용 가능)
	}else if(!checkbox.checked){															// 체크박스 false 면,														
		localStorage.removeItem("rememberUsername");						// localStorage 데이터 삭제
	}

	$.ajax({
		type: "post",
		url: "/project4/user?cmd=logCheck",
		data: JSON.stringify(data),
		contentType: "application/json; charset=utf-8",
		dataType: "json"
	}).done(function(data){
		if(data.statusCode == -1){
			$("#checkLog").html('아이디 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.');
			$("#checkLog").attr('color', 'red');
		}else if(data.statusCode == 1){
			document.getElementsByName("loginSuccess")[0].submit();
		}else if(data.statusCode == 0){
			$("#checkLog").html('아이디 또는 비밀번호를 입력해주세요.');
			$("#checkLog").attr('color', 'red');
		}
	});
}