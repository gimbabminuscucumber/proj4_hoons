<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>


<form action="/project4/user?cmd=login" method="post" >
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
        <font id="checkLog" size = "2"></font>
    </div>

    <div>
        <button type="button" onclick="logCheck();"class="mr-auto btn btn-primary" style="width: 25%">로그인 하기</button>
    </div>
</form>

<script>
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
    		console.log("ajax 접근");
    		console.log("data : " + data);
    		console.log("data.statusCode : " + data.statusCode);
    		
			if(data.statusCode == -1){
				$("#checkLog").html('아이디 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.');
				$("#checkLog").attr('color', 'red');
			}
    		
    	});
    }
</script>


</body>
</html>