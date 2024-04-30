<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ include file="../layout/header.jsp"%>

<div class="container">
	<br> 
	<br>
	<h6 class="d-flex justify-content-end">
		<div style="color:orange" class="mr-auto">
			<c:if test="${boards.category == 0 }"><i>카테고리 없음</i></c:if>
			<c:if test="${boards.category == 1 }"><i>IT 개발</i></c:if>
			<c:if test="${boards.category == 2 }"><i>퍼포먼스 마케팅</i></c:if>
		</div>
		<div>작성자 : <i><a href="#">${boards.username }</a></i></div>&nbsp;
		<div>작성일 : <i><fmt:formatDate pattern="yyyy-MM-dd" value="${boards.createDate}"></fmt:formatDate></i></div>&nbsp;
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
	
	<div class="d-flex justify-content-end">
		<a href="/project4/board?cmd=list&page=0" class="btn btn-primary">목록</a>&nbsp;
		<c:if test="${sessionScope.principal.id == boards.userId }">
			<a href="/project4/board?cmd=updateForm&id=${boards.id}" class="btn btn-primary">수정</a>&nbsp;
			<button onclick="deleteById(${boards.id})" class="btn btn-danger">삭제</button>
		</c:if>
	</div>
	<br>
	
	<!-- 댓글 박스 -->
	<div class="row bootstrap snippets">
		<div class="col-md-12">
			<div class="comment-wrapper">
				<div class="panel panel-info">
					<div class="panel-heading m-2"><b>Comment </b><i>(${replyCount })</i></div>
					<div class="panel-body">
						<input type="hidden" name="userId" value="${sessionScope.principal.id }">
						<input type="hidden" name="boardId" value="${boards.id }">
 					
 						<textarea id="content" id="reply__write__form" class="form-control" placeholder="내용을 입력하세요." rows="2"></textarea>
						<br>
						<div class="d-flex justify-content-end"><button onclick="replySave(${sessionScope.principal.id}, ${boards.id })" class="btn btn-primary">댓글쓰기</button></div>
						'sessionScope == null' = ${sessionScope.principal == null }
						'param' = ${param }
						<div class="clearfix"></div>
						<hr />

						<c:choose>
							<c:when test=""></c:when>
							<c:otherwise></c:otherwise>
						</c:choose>


						<!-- 댓글 리스트-->
						<ul id="reply__list" class="media-list">
							<!-- 댓글 -->
							<c:forEach var="reply" items="${replys }">
								<li id="reply-${reply.id }" class="media ">
									<!-- <img onerror="#" src="/project4/images/user.png" style="height: 45px " alt="" class="img-circle"></img> -->
									<div class="media-body">
										<strong class="text-primary">${reply.username }</strong>
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
