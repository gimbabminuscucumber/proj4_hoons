<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
 <!-- marterial css 
 https://materializecss.com/icons.html-->
 <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>

<br>
<div class="container">

		<div class="form-group">
				<label>Email :</label> 
				<input type="text" name="email" id="email" class="form-control" placeholder="Enter Email" required/>
				<!-- ajax -->
				<font id="checkEmail" size = "2"></font>
		</div>
	
		<br>
	
		<button type="button" class="btn btn-primary" onclick="emailCheck(${email})">아이디 찾기</button>
		<button type="button" class="btn btn-danger" onclick="window.close()">닫기</button>
</div>	
<script>

	// 이메일로 유저네임 찾기
	function emailCheck(){
		var email = $("#email").val();
		
		$.ajax({
			type: "post",
			url: "/project4/user?cmd=emailCheck&email=" + email,
			data: email,
			contentType: "application/json; charset=utf-8",
			dataType: "json"
		}).done(function(user){
			
			console.log("user : " + user);
			console.log("user.statusCode : " + user.statusCode);
			
			if(email === ""){
				$("#checkEmail").html('가입 당시 작성한 Email을 써주세요');
				$("#checkEmail").attr('color', 'red');
			}else if(user.statusCode == 1){
				$("#checkEmail").html('Username은 "' +user.data.username+ '" 입니다');
				$("#checkEmail").attr('color', 'blue');
			}else if(user.statusCode == -1){
				$("#checkEmail").html('해당 Email로 가입한 이력이 없습니다.');
				$("#checkEmail").attr('color', 'red');
			}
		});
	}
</script>	
	
</body>
</html>