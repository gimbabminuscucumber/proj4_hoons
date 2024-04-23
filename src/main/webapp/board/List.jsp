<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../layout/header.jsp"%>

<div class="container">

	<div class="m-2">
		<form class="form-inline d-flex justify-content-end" action="/blog/board">
			<input type="hidden" name="cmd" value="search" /> 
			<input type="hidden" name="page" value="0" /> 
			<input type="text" name="keyword" class="form-control mr-sm-2" placeholder="Search">
			<button class="btn btn-primary m-1">검색</button>
		</form>
	</div>


	<!-- 게시글 보기 -->
	<!-- JSTL forEach문을 써서 el 표식으로 뿌리기 -->
	
	<c:forEach var="board" items="${boards }">
		<div class="card col-md-12 m-2">
			<div class="card-body">
				<h4 class="card-title">${board.title }</h4>
				<a href="/project4/board?cmd=detail&id=${board.id }" class="btn btn-primary">상세보기</a>
			</div>
		</div>
	</c:forEach>

	<!-- 페이지 진척도 -->
	<div class="progress col-md-12 m-2">
		<div class="progress-bar" style="width: ${currentPercent}%"></div>
	</div>

	<!-- 페이징 처리 -->
<%-- 	페이지 확인 = ${param.page}
	마지막 페이지 = ${lastPage } --%>

	<br />
	<ul class="pagination justify-content-center">
	<c:choose>
		<c:when test="${param.page == 0 }">
			<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
		</c:when>
		<c:otherwise>
			<li class="page-item"><a class="page-link" href="/project4/board?cmd=list&page=${param.page-1 }">Previous</a></li>
		</c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test="${lastPage == param.page}">
			<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
		</c:when>
		<c:otherwise>
			<li class="page-item"><a class="page-link" href="/project4/board?cmd=list&page=${param.page+1 }">Next</a></li>
		</c:otherwise>
	</c:choose>
	
	</ul>
</div>

</body>
</html>
