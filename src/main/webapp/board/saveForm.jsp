<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../layout/header.jsp"%>

<!-- 
해당 페이지로 직접 URL(자원에 직접 접근 '파일.확장자') 접근을 하게 되면 Controller 외에 추가적으로 View 파일 내부에서 세션을 또 체크해야 함
- 단점 : 모듈 분리가 안됨, 모든 파일에서 세션 체크를 해야 함
- 해결 방법 : 필터에 .jsp로 접근하는 모든 접근을 막으면 됨
-->
<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/text.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">글쓰기</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="width: 60%">
	<form action="/project4/board?cmd=save" method="POST" name="saveForm">
		<input type="hidden" name="userId" value="${sessionScope.principal.id }">
		
		<div class="form-group">
		    <select name="category" class="custom-select">
		        <option selected disabled>Category</option>
		        <option value="0">카테고리 없음</option>
		        <option value="1">IT 개발</option>
		        <option value="2">퍼포먼스 마케팅</option>
		    </select>
		</div>


		<div class="form-group">
			<input type="text" class="form-control" placeholder="제목을 입력하세요" id="title" name="title" >
		</div>

		<div class="form-group">
			<textarea id="summernote" class="form-control" rows="5" name="content" ></textarea>
		</div>

		<div class="d-flex justify-content-end">
			<button type="button" onclick="history.back()" class="btn btn-outline-secondary" >이전</button>&nbsp;
			<button type="button" class="btn btn-primary" onclick="nullCheck()">글쓰기 등록</button>
		</div>
	</form>
</div>

<script>
$('#summernote').summernote({ // summernote id를 찾아서 summersnote() 를 실행해라
	placeholder : '내용을 작성하세요',
	tabsize : 2,
	height : 200
});

function nullCheck(){			// 글쓰기 등록 클릭시, content가 null 이면 작성 안되게
	if(document.saveForm.name.value == ""){
		alert("제목을 작성해주세요.");
	}else if(document.saveForm.content.value == ""){
		alert("내용을 작성해주세요.");
	}else{
		document.saveForm.submit();
	}
}
</script>
</body>
</html>
