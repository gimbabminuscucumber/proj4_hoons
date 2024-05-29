<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<!-- <div style="color: #077BFF;">User Infomation</div> -->
	<div class="d-flex justify-content-center">
		<img src="images/icons/schedule2.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">회원정보 수정</div>
	</div>
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
			<div class= "d-flex insert-input-container">
				<div class="material-icons-input" style="width: 338px">
					<span class="material-icons">face</span> 
					<input type="text" name="nickName" id="nickName" class="form-control" placeholder="Enter NickName" value="${user.nickName }" required />
				</div>
				<div>
					<button type="button" class="btn btn-info" onclick="nickNameCheck()">중복확인</button>
				</div>
			</div>
			<!-- ajax -->
			<div><font id="checkNickName" size="2"></font></div>
		</div>
		
		<div class="form-group">
			<div class="material-icons-input" style="width: 421px">
			    <span class="material-icons">lock_outline</span>
				<input type="password" name="password" class="form-control" placeholder="Enter Password"  required/>
			</div>	
		</div>
		
		<div class="form-group">
			<div class= "d-flex insert-input-container">
				<div class="material-icons-input" style="width: 338px">
					<span class="material-icons">local_phone</span> 
					<input type="text" name="phone" id="phone" class="form-control" value="${user.phone }" placeholder="Enter phone with (-)" required />
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
					<input type="text" name="email" id="email" class="form-control" value="${user.email}" placeholder="Enter Email" required />
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
		<button type="button" class="btn btn-outline-secondary" onclick="history.back()">이전</button>
		<button type="button" class="btn btn-primary" style="width: 128px" onclick="updateSuccess()">수정 완료</button>
	</form>
</div>
 
<script>
// 이메일 중복 확인
	var emailChecking = false;
	var phoneChecking = false;
	var nickNameChecking = false;
	var isChecking = false;
	var email;
	var password = document.getElementById('password').value;
	// ====================================================	
	// 												update
	// ====================================================	
	function updateSuccess() {				
		if(nickNameChecking == false){
			alert("닉네임 중복확인을 하세요");
			 isChecking = false;
		}else if(password === '' || password == undefined){
			alert("비밀번호를 입력 하세요");
			 isChecking = false;
		} else if(phoneChecking == false) {
			alert("연락처 중복확인을 하세요");
			isChecking = false;
		}else if (emailChecking == false) {
			alert("이메일 중복확인을 하세요");
			 isChecking = false;
		} else{	
			alert("회원정보 수정 완료");			
			isChecking = true;
			document.update.submit();
		}
	}

	// ====================================================	
	// 											email 중복확인
	// ====================================================	
	function emailCheck() {
		var email = document.getElementById("email").value;
		//var email = $("#email").val();
		var originalEmail = "${user.email}"; 	// DB에 저장된 원래 이메일 데이터
		
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
			} else if (email !== originalEmail && data === 'ok') {
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
			} else if (email === originalEmail) {
	            emailChecking = true;
	            $("#checkEmail").html('수정사항이 없습니다.');
	            $("#checkEmail").attr('color', 'blue');
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
		var originalNickName = "${user.nickName}";
		console.log('nickNameCheck/originalNickName : ' + originalNickName);
		
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
			}else if(nickName !== originalNickName && data === 'ok'){
				nickNameChecking = false;
				$("#checkNickName").html('해당 닉네임은 사용 중입니다.');
				$("#checkNickName").attr('color', 'red');
			}else if(nickName === originalNickName){
				nickNameChecking = true;
				$("#checkNickName").html('수정사항이 없습니다.');
				$("#checkNickName").attr('color', 'blue');
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
		var originalPhone = "${user.phone}"; 	// DB에 저장된 원래 phone 데이터
		console.log('phone : ' + phone);
		console.log('originalPhone : ' + originalPhone);
		
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
			}else if(phone !== originalPhone && data === 'ok'){
				phoneChecking = false;
				$("#checkPhone").html('해당 연락처는 사용 중입니다.');
				$("#checkPhone").attr('color', 'red');
			}else if(phone === originalPhone) {			// DB에 저장된 나의 데이터와 일치한 경우
				phoneChecking = true;
				$("#checkPhone").html('수정사항이 없습니다.');
				$("#checkPhone").attr('color', 'blue');
			}else{
				phoneChecking = true;
				$("#checkPhone").html('해당 연락처는 사용가능합니다.');
				$("#checkPhone").attr('color', 'blue');
			}
		});
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

