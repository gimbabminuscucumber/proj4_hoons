<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>


<br>
<br>
<h1 style="text-align: center">
	<div style="color: #077BFF;">User Infomation</div>
</h1>
<br>
<br>


<div class="container" style="text-align: center">
	<form action="/project4/user?cmd=update" method="post" name="update">	<!-- http://localhost:8080/project4/user?cmd=update&id=${user.id} -->
		<input type="hidden" name="id" value="${user.id }">
		
		<div class="form-group" >
			<div class="material-icons-input" style="width: 421px">
			    <span class="material-icons">person_outline</span>
			    <input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" value="${user.username }" readOnly required/>
			</div>	
		</div>
		
		<div class="form-group">
			<div class="material-icons-input" style="width: 421px">
			    <span class="material-icons">lock_outline</span>
				<input type="password" name="password" class="form-control" placeholder="Enter Password"  required/>
			</div>	
		</div>
		
		<div class="form-group insert-input-container">
		    <div class="material-icons-input" style="width: 183px">
		        <span class="material-icons">personal_video</span>
		        <input type="email"  name="email"  id="inputEmail" class="form-control" value="${user.email}" placeholder="Enter Email" oninput="emailCombine()"  required />
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
		회원가입시, 이메일이 도메인은 없이 저장됨

		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input" style="width: 338px">
				<span class="material-icons">home</span>
				<input type="text"  name="address" id="address"class="form-control" placeholder="Enter Address" value="${user.address }"  required readOnly/>
			</div>
			<div>
				<button type="button" class="btn btn-info" onclick="goPopup();">주소검색</button> <!-- type="button"을 설정하지 않으면 submit이 실행된다 -->
			</div>				
		</div>
		
		
		<div class="form-group">
			<div class="d-flex justify-content-between">
			</div>
		</div>

		<br>
		<button type="button" class="btn btn-primary" style="width: 128px" onclick="updateSuccess()">수정 완료</button>
		<button type="button" class="btn btn-outline-secondary" onclick="history.back()">이전</button>
	</form>
</div>
 
<script>
// 이메일 중복 확인
	var emailChecking = false;
	var isChecking = false;
	var email;
	
	function updateSuccess() {				
		if (emailChecking == false) {
			alert("이메일 중복확인을 하세요");
			 isChecking = false;
		} else  {
			alert("회원가입 완료");			
			isChecking = true;
			document.update.submit();
		}
	}
	
	function emailCombine() {
		var inputEmail = document.getElementById("inputEmail").value;
		var domain = document.getElementById("domain").value;
		//var email = inputEmail + domain;			// var로 email에 데이터를 전달하면 전역변수로 설정한 var email과 다른 메모릴에 저장돼서 다른 함수에서 사용 불가
		email = inputEmail + domain; // 다른 함수에서 email 값을 사용하기 위해선 var, const 같은 키워드를 사용하면 안됨
	}

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
	
	
	//주소 API 실행 함수
	function goPopup(){
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