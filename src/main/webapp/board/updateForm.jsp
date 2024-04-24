<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../layout/header.jsp"%>

<div class="container">
	<form action="/project4/board?cmd=update" method="POST">
		<input type="hidden" name="id" value="${dto.id }">
		<div class="form-group">
			<label for="title">Title:</label> 
			<input type="text" class="form-control" placeholder="제목을 입력하세요" id="title" name="title" value="${dto.title }">
		</div>

		<div class="form-group">
			<label for="content">Content:</label>
			<textarea id="summernote" class="form-control" rows="5" id="content" name="content" >${dto.content }</textarea>
		</div>

		<button type="submit" class="btn btn-primary">수정 완료</button>
	</form>
</div>

<script>
	$('#summernote').summernote({ // summernote id를 찾아서 summersnote() 를 실행해라
		placeholder : '내용을 작성하세요',
		tabsize : 2,
		height : 200
	});
</script>
</body>
</html>
