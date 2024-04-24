<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ include file="../layout/header.jsp"%>

<div class="container">
	<br> 
	<br>
	<h6 class="m-2 d-flex justify-content-between">
		<div>작성자 : <a href="#"><i>${dto.username }</i></div></a>
		<div>조회수 : <i>${dto.readCount }</i></div>
	</h6>
	<br>
	
	<div class="form-group">
		<b><label>Title : </label></b>
		<h3>${dto.title }</h3>
	</div>
	<hr>
	<div class="form-group">
		<b><label>Content : </label></b>
		<div>${dto.content }</div>
	</div>
	<hr>
	
	<c:if test="${sessionScope.principal.id == dto.userId }">
		<div class="d-flex justify-content-end">
			<button onclick="updateById()" class="btn btn-primary">수정</button>
			<button onclick="deleteById(${dto.id})" class="btn btn-danger">삭제</button>
		</div>
	</c:if>
	<br>
	
	<script>
		function deleteById(boardId){
			var data ={
					boardId: boardId
			}
			
			$.ajax({
				type: "post",
				url: "/project4/board?cmd=delete",
				data: JSON.stringify(data),
				contentType: "application/json; charset=utf-8",
				dataType: "json"
			}).done(function(result){
				if(result.status == "ok"){
					location.href="index.jsp";
				}else{
					alert("삭제에 실패하였습니다.");
				}
			});
		}
	</script>
	
	<!-- 댓글 박스 -->
	<div class="row bootstrap snippets">
		<div class="col-md-12">
			<div class="comment-wrapper">
				<div class="panel panel-info">
					<div class="panel-heading m-2">
						<b>Comment </b><i>(댓글 개수)</i>
					</div>
					<div class="panel-body">
						<textarea id="reply__write__form" class="form-control"
							placeholder="write a comment..." rows="2"></textarea>
						<br>
						<button onclick="#" class="btn btn-primary pull-right">댓글쓰기</button>
						<div class="clearfix"></div>
						<hr />

						<!-- 댓글 리스트-->
						<ul id="reply__list" class="media-list">

							<!-- 댓글 -->
							<li id="reply-1" class="media">
								<img onerror="#" src="/project4/images/user.png" style="height: 45px " alt="" class="img-circle">
								<div class="media-body">
									<strong class="text-primary">홍길동</strong>
									<p>댓글입니다.</p>
									작성시간(크기 작게 / 회색)
									<fmt:formatDate pattern="yyyy-MM-dd" value="${board.createDate}"></fmt:formatDate>
								</div>
								<div class="m-2">
						
										<i onclick="#" class="material-icons">delete</i>
								</div>
							</li>

						</ul>
						<!-- 댓글 리스트 끝-->
					</div>
				</div>
			</div>

		</div>
	</div>
	<!-- 댓글 박스 끝 -->
</div>


</body>
</html>
