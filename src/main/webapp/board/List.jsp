<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ include file="../layout/header.jsp"%>

<div class="container">

	<!-- 검색창 -->
	<!-- - 검색 버튼 누르면 파라미터 3개가 controller로 감 (cmd, page, keyword) -->
	<div class="m-2">
		<form class="form-inline d-flex justify-content-end" action="/project4/board">
			<input type="hidden" name="cmd" value="search" /> 		<!-- <form>태그가 /project4/board?cmd=search 로 감 -->
			<input type="hidden" name="page" value="0" /> 
			<input type="text" name="keyword" class="form-control mr-sm-2" placeholder="Search">
			<button class="btn btn-primary m-1">검색</button>
		</form>
	</div>

	<!-- 게시글 보기 -->
	<!-- JSTL forEach문을 써서 el 표식으로 뿌리기 -->
	<div class="card m-2">
		<div class="card-header">
			<i class="mtrl-select">모든 게시글</i>
		</div>
	</div>
	
	<c:if test="${empty boards }">
		<div>&nbsp; 작성된 게시글이 없습니다.</div>
	</c:if>
	<c:forEach var="board" items="${boards }">
		<div class="card m-2">
			<div class="card-body">
				<div class="d-flex justify-content-between">
					<h4 class="card-title"><a href="/project4/board?cmd=detail&id=${board.id }">${board.title }</a></h4>
					<div>작성자 : <a href="#">${board.username}</a></div>
				</div>
				<div style="color: grey" class=d-flex>
					<div>
						<c:if test="${board.category == 0 }"><a href="#"><i>카테고리 없음 ·&nbsp;</i></a></c:if>
						<c:if test="${board.category == 1 }"><a href="#"><i>IT 개발 ·&nbsp;</i></a></c:if>
						<c:if test="${board.category == 2 }"><a href="#"><i>퍼포먼스 마케팅 ·&nbsp;</i></a></c:if>
					</div>
					<i><fmt:formatDate pattern="yyyy-MM-dd" value="${board.createDate}"></fmt:formatDate></i>
				</div>
				<%-- <div>
					<a href="/project4/board?cmd=detail&id=${board.id }" class="btn btn-primary">상세보기</a>
				</div> --%>					
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

		<!-- 검색을 통해 나온 페이지 처리 -->
		<c:choose>
			<c:when test="${empty param.keyword }">
				<%-- <c:set> : 변수 사용 --%>
				<c:set var="pagePrev" value="/project4/board?cmd=list&page=${param.page-1 }"></c:set>
				<c:set var="pageNext" value="/project4/board?cmd=list&page=${param.page+1 }"></c:set>
			</c:when>
			
			<c:otherwise>
				<c:set var="pagePrev" value="/project4/board?cmd=search&page=${param.page-1 }&keyword=${param.keyword }"></c:set>
				<c:set var="pageNext" value="/project4/board?cmd=search&page=${param.page+1 }&keyword=${param.keyword }"></c:set>
			</c:otherwise>
		</c:choose>
	
		<!-- 단순 페이지 처리 -->
		<c:choose> 
			<c:when test="${param.page == 0 }">
				<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
			</c:when> 
			<c:otherwise>
				<li class="page-item"><a class="page-link" href="${pageScope.pagePrev }">Previous</a></li>
<%-- 				<li class="page-item"><a class="page-link" href="/project4/board?cmd=list&page=${param.page-1 }">Previous</a></li> --%>
			</c:otherwise>
		</c:choose>
	
		<c:choose>
			<c:when test="${lastPage == param.page}">
				<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
			</c:when>
			<c:otherwise>
				<li class="page-item"><a class="page-link" href="${pageScope.pageNext }">Next</a></li>
<%-- 				<li class="page-item"><a class="page-link" href="/project4/board?cmd=list&page=${param.page+1 }">Next</a></li> --%>
			</c:otherwise>
		</c:choose>
	
	</ul>
</div>

</body>
</html>
