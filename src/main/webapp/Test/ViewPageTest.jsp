<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>


<br>
<br>
<a href="<%=request.getContextPath()%>/index.jsp">
	<h1 style="text-align: center">User Infomation</h1>
</a>
<br>
<br>


<div class="container" style="text-align: center">
	<form action="/project4/user?cmd=join" method="post" onsubmit="return valid()">	<!-- UserController의 cmd.equals("join") 으로 전달
																																								onsubmit : submit 되면 무조건 실행되는 함수-->
		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input" style="width: 255px">
			 	<span class="material-icons">person_outline</span>
				<input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required/>
			</div>				
			<div>
				<button type="button" class="btn btn-info"  onclick="usernameCheck()">중복확인</button>
			</div>	
		</div>
		<!-- ajax -->
		<div><font id="checkId" size = "2"></font></div>
		
		<div class="form-group insert-input-container">
			<div class="material-icons-input" style="width: 335px">
			    <span class="material-icons">lock_outline</span>
				<input type="password" name="password" class="form-control" placeholder="Enter Password" >
			</div>
		</div>
		
		<div class="form-group insert-input-container">
		    <div class="material-icons-input" style="width: 183px">
		        <span class="material-icons">personal_video</span>
		        <input type="email" name="email" class="form-control" placeholder="Enter Email">
		    </div>
		    <div class="input-group-prepend">
		        <button class="btn btn-outline-secondary dropdown-toggle" data-toggle="dropdown">@example.com</button>
		        <div class="dropdown-menu">
		            <div class="dropdown-item">@naver.com</div>
		            <a class="dropdown-item">@google.com</a>
		            <a class="dropdown-item">@daum.net</a>
		        </div>
		    </div>
		</div>
		
		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input">
				<span class="material-icons">home</span>
				<input type="text"  name="address" id="address"class="form-control" placeholder="Enter Address" required readOnly/>
			</div>
			<div>
				<button type="button" class="btn btn-info" onclick="goPopup();">주소검색</button> <!-- type="button"을 설정하지 않으면 submit이 실행된다 -->
			</div>				
		</div>

<!-- 아이디 기억하기   -->
<!-- 		<div class="form-group form-check">
			<label class="form-check-label"> 
				<input class="form-check-input" type="checkbox"> Remember me
			</label>
		</div> -->
		<br>
		<button type="submit" class="btn btn-primary" style="width: 360px">회원가입 완료</button>
	</form>

</div>
 
<script>
var isChecking = false;

function valid(){
	if(isChecking == false){
		alert("아이디 중복체크를 하세요");
	}
	return isChecking;
}

// 아이디 중복 체크 ajax 실행 함수
function usernameCheck(){
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
		type: "POST",
		url: "/project4/user?cmd=usernameCheck",
		data: username,
		contentType: "text/plain; charset=utf-8",
		dataType: "text"				// 응답받을 데이터 타입 ("json"은 Java object로 파싱해줌)
	}).done(function(data){		// .done() : 통신이 끝나면 실행할 기능
		if(username === ''){			// 유저네임이 공란
			console.log('공란 : data : ' + data);
			console.log('공란 : username : ' + username);

			isChecking = false;			// 신규 아이디로 중복허용 후, 다시 중복된 아이디로 회원가입할 수 있으니 잘못된 경우는 다 isChecking="false"로
			//alert('유저네임을 입력해주세요.')
			$("#checkId").html('유저네임을 입력해주세요.');
			$("#checkId").attr('color', 'red');
		}else if(data === 'ok'){		// 유저네임이 중복 됨
			console.log('중복 : data : ' + data);
			console.log('중복 : username : ' + username);
			
			isChecking = false;
			//alert('유저네임이 중복되었습니다.')
			$("#checkId").html('유저네임이 중복되었습니다.');
			$("#checkId").attr('color', 'red');
		}else{									// 유저네임이 중복 안 됨
			console.log('신규 : data : ' + data);
			console.log('신규 : username : ' + username);

			isChecking = true;
			//alert('해당 유저네임은 사용가능합니다.')
			$("#checkId").html('해당 유저네임은 사용가능합니다.');
			$("#checkId").attr('color', 'blue');
		}
	});
}

// 주소 API 실행 함수
function goPopup(){
	console.log("goPopup()");
	var pop = window.open("/project4/user/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

function jusoCallBack(roadFullAddr){
	var addressElement = document.querySelector("#address");	
	addressElement.value = roadFullAddr;
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