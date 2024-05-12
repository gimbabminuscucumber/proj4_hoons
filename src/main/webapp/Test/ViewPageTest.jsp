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
			
		</div>
		<!-- ajax -->
		<p><font id="checkLog" size = "2"></font></p>
		
		<div class="custom-control custom-switch">
			<input type="checkbox" class="custom-control-input" id="remember" name="remember" onclick="rememberUser()">
			<label class="custom-control-label" for="remember">유저네임 기억하기</label>
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
/*
	// 유저네임 기억하기
	function rememberUser(){
		var checkbox = document.getElementById("remember");
		var username = document.getElementById("username").value;
		
		// 체크박스가 체크되어 있으면, username을 로컬 스토리지에 저장
		if(checkbox.checked){
			localStorage.setItem("rememberUser", username);
			console.log("username : " + username);
		}else{
			// 체크박스가 체크되어 있지 않으면, username으로 받은 데이터를 삭제
			localStorage.removeItem("rememberUser");
		}
	}
	*/
	console.log("userInfo.js에서 받아온 username : " + username);
	// 페이지가 로드될 때 실행되는 함수
	window.onload = function(){
		var checkbox = document.getElementById("remember");
		var username = document.getElementById("username").value;
		var rememberUser = localStorage.getItem("rememberUser");		// "rememberUser"에 저장 돼 있는 username을 var rememberUser에 저장
		
		if(!checkbox.checked){
			localStorage.removeItem("rememberUser");
		}
		
		// 로컬 스토리지에 유저네임이 있는지 확인
		if(rememberUser){
			username.value = rememberUser;												// 웹에서 입력받은 username.value와 localStorage에 저장된 username이 같은지 확인
			// 체크박스 체크 상태로
			document.getElementById("remember").checked = true;	
		}

		/*
		if(document.getElementById("remember").checked){							// 유저네임 기억하기를 클릭했으면 
			if(rememberUser = username.value){												// 웹에서 입력받은 username.value와 localStorage에 저장된 username 비교
				document.getElementById("username").value(rememberUser);	// true면, id="username"에  localStorage에 저장된 rememberUser을 값으로 입력
			}else{																										// false면, 
				localStorage.removeItem("rememberUser");									// localStorage에 저장된 rememberUser 삭제
			}
		}
		*/
		
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

</html>