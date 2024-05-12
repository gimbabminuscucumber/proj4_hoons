
// 아이디 찾기
function searchUsername(){
	console.log("searchUsername()");
	var pop = window.open("/project4/user/searchUsername.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

// 비밀번호 찾기
function searchPassword(){
	console.log("searchPassword()");
	var pop = window.open("/project4/user/searchPassword.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

// 로그인시 아이디&비번 틀리면 로그인 실패 메세지 띄우기
function logCheck() {
	console.log("logCheck");
	
	var username = document.getElementById("username").value;
	var password = document.getElementById("password").value;
	
	console.log("username : " + username);
	console.log("password : " + password);
	
	var data ={
		username: username,
		password: password
	}
	
	$.ajax({
		type: "post",
		url: "/project4/user?cmd=logCheck",
		data: JSON.stringify(data),
		contentType: "application/json; charset=utf-8",
		dataType: "json"
	}).done(function(data){
		console.log("data : " + data);
		console.log("data.statusCode : " + data.statusCode);
		
		if(data.statusCode == -1){
			$("#checkLog").html('아이디 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.');
			$("#checkLog").attr('color', 'red');
		}else if(data.statusCode == 1){
			document.getElementsByName("loginSuccess")[0].submit();
			
			// 유저네임 기억하기 로직
			username = data.username;
			localStorage.setItem("rememberUser", username);
			console.log("userInfo.js/로그인성공/username : " + username);
		}else if(data.statusCode == 0){
			$("#checkLog").html('아이디 또는 비밀번호를 입력해주세요.');
			$("#checkLog").attr('color', 'red');
		}
	});
}