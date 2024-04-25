<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ include file="../layout/header.jsp"%>

<div class="container">
	<br> 
	<br>
	<h6 class="m-2 d-flex justify-content-between">
		<div>작성자 : <a href="#"><i>${boards.username }</i></div></a>
		<div>조회수 : <i>${boards.readCount }</i></div>
	</h6>
	<br>
	
	<div class="form-group">
		<b><label>Title : </label></b>
		<h3>${boards.title }</h3>
	</div>
	<hr>
	<div class="form-group">
		<b><label>Content : </label></b>
		<div>${boards.content }</div>
	</div>
	<hr>
	
	<c:if test="${sessionScope.principal.id == boards.userId }">
		<div class="d-flex justify-content-end">
			<a href="/project4/board?cmd=list&page=0" class="btn btn-primary">목록</a>&nbsp;
			<a href="/project4/board?cmd=updateForm&id=${boards.id}" class="btn btn-primary">수정</a>&nbsp;
			<button onclick="deleteById(${boards.id})" class="btn btn-danger">삭제</button>
		</div>
	</c:if>
	<br>
	
	<!-- 댓글 박스 -->
	<div class="row bootstrap snippets">
		<div class="col-md-12">
			<div class="comment-wrapper">
				<div class="panel panel-info">
					<div class="panel-heading m-2"><b>Comment </b><i>(댓글 개수)</i></div>
					<div class="panel-body">
						<input type="hidden" name="userId" value="${sessionScope.principal.id }">
						<input type="hidden" name="boardId" value="${boards.id }">
						<textarea id="content" id="reply__write__form" class="form-control" placeholder="write a comment..." rows="2"></textarea>
						<br>
						<button onclick="replySave(${sessionScope.principal.id}, ${boards.id })" class="btn btn-primary pull-right">댓글쓰기</button>
						
						<div class="clearfix"></div>
						<hr />

						<!-- 댓글 리스트-->
						<ul id="reply__list" class="media-list">
							<!-- 댓글 -->
							<c:forEach var="reply" items="${replys }">
								<li id="reply-${reply.id }" class="media ">
									<!-- <img onerror="#" src="/project4/images/user.png" style="height: 45px " alt="" class="img-circle"></img> -->
									<div class="media-body">
										<strong class="text-primary">${reply.userId }</strong>
										<p>${reply.content }</p>
									</div>
									<div class="m-2">
										<c:if test="${sessonScope.principal.id == reply.userId }">
											<!-- delete에 마우스 갖다댔을 때, css로 마우스 포인터가 손가락으로 바뀌게하기 -->
											<i onclick="deleteReply(${reply.id})" class="material-icons">delete</i>
										</c:if>
									</div>
								</li>
							</c:forEach>
						</ul>
						<!-- 댓글 리스트 끝-->
					</div>
				</div>
			</div>

		</div>
	</div>
	<!-- 댓글 박스 끝 -->
</div>

<script src="/project4/js/boardDetail.js"></script>

</body>
</html>
