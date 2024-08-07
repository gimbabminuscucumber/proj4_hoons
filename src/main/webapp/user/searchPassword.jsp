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
				<label>Username :</label> 
				<input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" required/>
		</div>

		<div class="form-group">
				<label>Email :</label> 
				<input type="text" name="email" id="email" class="form-control" placeholder="Enter Email" required/>
				<!-- ajax -->
				<font id="checkPassword" size = "2"></font>
		</div>
	
		<br>
	
		<button type="button" class="btn btn-danger" onclick="window.close()">닫기</button>
		<button type="button" class="btn btn-primary" onclick="passwordCheck()">비밀번호 찾기</button>
</div>	
<script>

	// 이메일로 유저네임 찾기
	function passwordCheck(){

		var data ={
			username: $("#username").val(),
			email: $("#email").val()
		}
		
		$.ajax({
			type: "post",
			url: "/project4/user?cmd=passwordCheck",
			data: JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			dataType: "json"
		}).done(function(user){
			console.log("user : " + user);
			console.log(user.statusCode);
			console.log(user.data);
			
			if(user.data === undefined){
				$("#checkPassword").html('가입 당시 작성한 Username과 Email을 써주세요');
				$("#checkPassword").attr('color', 'red');
			}else if(user.statusCode == 1){
				$("#checkPassword").html('Password는 "' +user.data.password+ '" 입니다');
				$("#checkPassword").attr('color', 'blue');
			}else if(user.statusCode == -1){
				$("#checkPassword").html('해당 Username과 Email로 가입한 이력이 없습니다.');
				$("#checkPassword").attr('color', 'red');
			}
		});
		
	}
</script>	
	
</body>
</html>