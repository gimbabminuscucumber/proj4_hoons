<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>


<br>
<br>
<h1 style="text-align: center">
	<a href="<%=request.getContextPath()%>/index.jsp">User Infomation</a>
</h1>
<br>
<br>


<div class="container" style="text-align: center">
	<form action="/project4/user?cmd=update" method="post">	<!-- http://localhost:8080/project4/user?cmd=update&id=${user.id} -->
		<input type="hidden" name="id" value="${user.id }">
		
		<div class="form-group" >
			<div class="material-icons-input" style="width: 335px">
			    <span class="material-icons">person_outline</span>
			    <input type="text" name="username" id="username" class="form-control" placeholder="Enter Username" value="${user.username }" readOnly required/>
			</div>	
		</div>
		
		<div class="form-group">
			<div class="material-icons-input" style="width: 335px">
			    <span class="material-icons">lock_outline</span>
				<input type="password" name="password" class="form-control" placeholder="Enter Password"  required/>
			</div>	
		</div>
		
		<div class="form-group insert-input-container">
		    <div class="material-icons-input" style="width: 183px">
		        <span class="material-icons">personal_video</span>
		        <input type="email"  name="email" class="form-control" value="${user.email}" placeholder="Enter Email"/>
		    </div>
		    <button class="btn btn-outline-secondary dropdown-toggle" data-toggle="dropdown">@example.com</button>
		    <div class="dropdown-menu">
		        <div class="dropdown-item">@naver.com</div>
		        <a class="dropdown-item">@google.com</a>
		        <a class="dropdown-item">@daum.net</a>
		    </div>
		</div>

		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input">
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
		<button type="submit" class="btn btn-primary" style="width: 300px">수정 완료</button>&nbsp;
		<button type="button" class="btn btn-primary" onclick="history.back()">이전</button>
	</form>
</div>
 
<script>
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