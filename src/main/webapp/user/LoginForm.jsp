<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/check.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">로그인</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<form action="/project4/user?cmd=login" method="post"  name="loginSuccess">
	<!-- <form> 태그에 데이터를 담아서 POST 로 보내면 Key=Value 형태로 간다 (x-www-form-urlencoded) -->
		<div class="form-group">
			<div class="material-icons-input">
			    <span class="material-icons">person_outline</span>
			    <input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required />
			</div>	
		</div>
		
		<div class="form-group">
			<div class="material-icons-input">
			    <span class="material-icons">lock_outline</span>
				<input type="password" name="password" id="password" class="form-control" placeholder="Enter Password" required/>
			</div>	
			<!-- ajax -->
			<div><font id="checkLog" size = "2"></font></div>
		</div>
		
		<div class="custom-control custom-switch" >
			<input type="checkbox" class="custom-control-input" id="remember" name="remember" style="cursor: pointer" onchange="rememberUsername()">
			<label class="custom-control-label" for="remember" style="cursor: pointer">유저네임 기억하기</label>
		</div>
		
		<br>
		<div>
   			 <button type="button" onclick="logCheck();" id="login" class="mr-auto btn btn-primary" style="width: 280px">로그인 하기</button>
		</div>
		<br>
	</form>
</div>

<div class="container d-flex justify-content-center" style="width: 35%; color: grey;">
	<div onclick="searchUsername()" style="cursor: pointer;">아이디 찾기</div> ㅣ 
	<div onclick="searchPassword()" style="cursor: pointer;">비밀번호 찾기</div>
</div>
		 
<script src="/project4/js/userInfo.js"></script>

<script>
	
	function rememberUsername(){
		var checkbox = document.getElementById("remember");			// .value가 없으니까 checkbox는 boolean 타입으로 사용 가능(true, false)
		
		if(!checkbox.checked){																	// 체크박스 체크되어 있지 않으면 localStorage에 저장된 unsername 삭제
			localStorage.removeItem("rememberUsername");
			console.log('removeItem/저장 삭제 : ' + localStorage.removeItem("rememberUsername"));
		}
	}

	 // 페이지가 로드될 때 실행되는 함수
	 // - 페이지 로드될 때, checkbox가 true이면 locaStorage에 저장된 데이터를 가져오기
	 // - localStorage는 로그인 성공했을 때만 데이터 저장 (logCheck() 함수에서 처리)
	window.onload = function(){
		var checkbox = document.getElementById("remember");
	 	var rememberUsername = localStorage.getItem("rememberUsername");
	 	var username = document.getElementById("username");		 // 왜 .value를 안쓰지?

	 	if(checkbox.checked){	
	 		 document.getElementById("username").value(localStorage.getItem("rememberUsername"));
	 	}		
	 	
	 	if(rememberUsername){																// localStorage에 username이 있으면
	 		username.value = rememberUsername;									// 웹에서 입력받은 username과 localStorage의 username을 비교
	 		document.getElementById("remember").checked = true;		// '유저네임 기억하기' 를 체크로 표시
	 	}
	 	
	}
		 
</script>

</body>
<style>
    .material-icons-input {								/* input 될 아이콘 칸 */
        display: inline-block;
        position: relative;
    }
    .material-icons-input input {						/* 아이콘이 포함된 input 태그 */
	    width: 100%;
	    padding-left: 40px; /* 예시: 좀 더 넓은 여백을 주기 위해 padding-left 값 조정 */
    }
    .material-icons-input .material-icons {		/* 아이콘 위치 */
        position: absolute;
        left: 5px; /* 아이콘을 왼쪽에 위치 */
        top: 50%;
        transform: translateY(-50%);
    }
</style>

