<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../layout/header.jsp"%>

<div class="container">
	<form action="/project4/board?cmd=update" method="POST">
		<input type="hidden" name="id" value="${dto.id }">
	
		<div class="form-group">
		    <label for="category">Category:</label> 
		    <br>
		    <select name="category" class="form-control">
		        <option value="0">카테고리 없음</option>
		        <option value="1">IT 개발</option>
		        <option value="2">퍼포먼스 마케팅</option>
		    </select>
		</div>
	
		<div class="form-group">
			<label for="title">Title:</label> 
			<input type="text" class="form-control" placeholder="제목을 입력하세요" id="title" name="title" value="${dto.title }">
		</div>

		<div class="form-group">
			<label for="content">Content:</label>
			<textarea id="summernote" class="form-control" rows="5" id="content" name="content" >${dto.content }</textarea>
		</div>
		
		<div class="d-flex justify-content-end">
			<button type="button" onclick="history.back()" class="btn btn-outline-secondary" >이전</button>&nbsp;
			<button type="submit" class="btn btn-primary">수정 완료</button>
		</div>	
	</form>
</div>

<script>
	$('#summernote').summernote({ // summernote id를 찾아서 summersnote() 를 실행해라
		placeholder : '내용을 작성하세요',
		tabsize : 2,
		height : 200
	});
	
	// 저장된 카테고리 값 가져오기
	// 1. HTML 코드에서 select 요소를 가져옴
	var selectElement = document.querySelector('select[name="category"]');

	// 2. 사용자가 선택한 옵션의 값(value)을 가져옴
	var selectedValue = selectElement.value;

	// 3. 선택한 값 출력
	console.log(selectedValue);
</script>
 
 </body>
</html>
