<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/text.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">게시글 수정</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="width: 60%">
	<form action="/project4/board?cmd=update" method="POST" name="update">
		<input type="hidden" name="userId" value="${sessionScope.principal.id }">
		<input type="hidden" name="id" value="${dto.id }">
		<div class="form-group">
		    <select name="category" id="category" class="custom-select">
		        <option selected disabled>카테고리</option>
		        <option value="0">🔥Hot 레시피</option>
		        <option value="1">⏰무물 타임</option>
		        <c:if test="${sessionScope.principal.userRole == 'ADMIN' }">
			        <option value="2">🏆이달의 이벤트</option><!-- 관리자만 사용 가능 -->
		        </c:if>
		    </select>
		</div>


		<div class="form-group">
			<input type="text" class="form-control" placeholder="제목을 입력하세요" id="title" name="title"  value="${dto.title }">
		</div>

		<div class="form-group">
			<textarea id="summernote" class="form-control" rows="5" name="content" >${dto.content }</textarea>
		</div>

		<div class="d-flex justify-content-end">
			<button type="button" onclick="history.back()" class="btn btn-outline-secondary" >이전</button>&nbsp;
			<button type="button" class="btn btn-primary" onclick="nullCheck()">수정 완료</button>
		</div>
	</form>
</div>

<script>

	$('#summernote').summernote({ // summernote id를 찾아서 summersnote() 를 실행해라
		placeholder : '내용을 작성하세요',
		tabsize : 2,
		height : 400
	});
	
	// 저장된 카테고리 값 가져오기
	// 1. HTML 코드에서 select 요소를 가져옴
	var selectElement = document.querySelector('select[name="category"]');
	// 2. 사용자가 선택한 옵션의 값(value)을 가져옴
	var selectedValue = selectElement.value;
	// 3. 선택한 값 출력
	console.log(selectedValue);
	
	window.onload = function(){
		var categoryValue = document.getElementById('category').value;
		console.log('categroy 값 : ' + categoryValue);
	}

	// 수정 완료 버튼 클릭시 실행
	function nullCheck(){		
		if(document.update.category.value =="카테고리" ){
			alert("카테고리를 선택해주세요.");
		}else if(document.update.name.value == ""){
			alert("제목을 작성해주세요.");
		}else if(document.update.content.value == ""){
			alert("내용을 작성해주세요.");
		}else{
			document.update.submit();
		}
	}
	
</script>
<%@ include file = "../layout/footer.jsp" %>