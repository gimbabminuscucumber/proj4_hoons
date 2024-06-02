<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/sound.png" alt="Logo" style="width: 50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">커뮤니티</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<!-- 상단 버튼 -->
	<div class="d-flex justify-content-between align-items-center mb-1">
		<ul class="nav nav-pills" role="tablist">
			<c:choose>
				<c:when test="${empty param.category }">
					<li class="nav-item" ><a style="background-color: #007bff; color:white" class="nav-link" href="/project4/board?cmd=list&page=0" >📑전체 게시글</a></li>
				    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=0&page=0" >🔥Hot 레시피</a></li>
				    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=1&page=0" >⏰무물 타임</a></li>
				    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=2&page=0" >🏆이달의 이벤트</a></li>
				    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=3&page=0" >💌 고객의 소리</a></li>
				</c:when>
				<c:when test="${!empty param.category }">
					<c:choose>
						<c:when test="${param.category == 0 }">
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=list&page=0" >📑전체 게시글</a></li>
						    <li class="nav-item" ><a style="background-color: #007bff; color:white" class="nav-link" href="/project4/board?cmd=ctgr&category=0&page=0" >🔥Hot 레시피</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=1&page=0" >⏰무물 타임</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=2&page=0" >🏆이달의 이벤트</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=3&page=0" >💌 고객의 소리</a></li>
						</c:when>
						<c:when test="${param.category == 1 }">
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=list&page=0" >📑전체 게시글</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=0&page=0" >🔥Hot 레시피</a></li>
						    <li class="nav-item" ><a style="background-color: #007bff; color:white" class="nav-link" href="/project4/board?cmd=ctgr&category=1&page=0" >⏰무물 타임</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=2&page=0" >🏆이달의 이벤트</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=3&page=0" >💌 고객의 소리</a></li>
						</c:when>
						<c:when test="${param.category == 2 }">
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=list&page=0" >📑전체 게시글</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=0&page=0" >🔥Hot 레시피</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=1&page=0" >⏰무물 타임</a></li>
						    <li class="nav-item" ><a style="background-color: #007bff; color:white" class="nav-link" href="/project4/board?cmd=ctgr&category=2&page=0" >🏆이달의 이벤트</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=3&page=0" >💌 고객의 소리</a></li>
						</c:when>
						<c:when test="${param.category == 3 }">
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=list&page=0" >📑전체 게시글</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=0&page=0" >🔥Hot 레시피</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=1&page=0" >⏰무물 타임</a></li>
						    <li class="nav-item" ><a class="nav-link" href="/project4/board?cmd=ctgr&category=2&page=0" >🏆이달의 이벤트</a></li>
						    <li class="nav-item" ><a style="background-color: #007bff; color:white" class="nav-link" href="/project4/board?cmd=ctgr&category=3&page=0" >💌 고객의 소리</a></li>
						</c:when>
					</c:choose>
				</c:when>
			</c:choose>
		</ul>
		
		<!-- 검색창 -->
		<!-- - 검색 버튼 누르면 파라미터 3개가 controller로 감 (cmd, page, keyword) -->
		<div>
			<form class="form-inline d-flex justify-content-end" action="/project4/board">
				<input type="hidden" name="cmd" value="search" /> <!-- <form>태그가 /project4/board?cmd=search 로 감 -->
				<input type="hidden" name="page" value="0" /> 
				<input type="text" name="keyword" class="form-control mr-sm-2" placeholder="Search" style="width: 60%">
				<button class="btn btn-primary m-1">검색</button>
			</form>
		</div>
	</div>
	<br>

	<div class="card">
		<div class="card-header">
			<c:choose>
				<c:when test="${empty param.category }">
					<div style="text-align:left">🔔 모든 게시글을 확인 할 수 있습니다.</div>
				</c:when>
				<c:when test='${!empty param.category}'>
					<c:choose>
						<c:when test="${param.category == 0 }"><div style="text-align:left">🔔 최근 Hot한 레시피 또는 나만의 레시피를 공유해주세요!</div></c:when>
						<c:when test="${param.category == 1 }"><div style="text-align:left">🔔 재료 손질 방법이나 관리 방법 등 궁금한 걸 물어보세요!</div></c:when>
						<c:when test="${param.category == 2 }"><div style="text-align:left">🔔 놓치면 아쉬운 이 달의 혜택을 확인하세요!</div></c:when>
						<c:when test="${param.category == 3 }"><div style="text-align:left">🔔 'hoons' 사용에 궁금한 점을 물어보세요!</div></c:when>
					</c:choose>
				</c:when>
			
			</c:choose>
		</div>
	</div>
	<br>

	<div class="form-group" style="height: 360px">
		<table>
			<thead>
				<tr>
					<th style="width: 200px">카테고리</th>
					<th style="width: 500px">제목</th>
					<th style="width: 200px">작성자</th>
					<th style="width: 200px">작성일</th>
					<th style="width: 150px">조회수</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="board" items="${boards}" varStatus="loop">
					<c:if test="${loop.first}">
						<tr>
							<td colspan="5" style="padding-top: 15px;"></td>
						</tr>
					</c:if>

					<tr>
						<td>
							<span>
								<c:if test="${board.category == 0}">🔥Hot 레시피</c:if>
								<c:if test="${board.category == 1}">⏰무물 타임</c:if>
								<c:if test="${board.category == 2}">🏆이달의 이벤트</c:if>
							</span>
						</td>
						<td style="padding-left: 20px; text-align: left;"><strong><a href="/project4/board?cmd=detail&id=${board.id }">${board.title} </a></strong>(${replyCounts[board.id]})</td>
						<td><span>${board.nickName }</span></td>
						<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.createDate}"></fmt:formatDate></td>
						<td><span>${board.readCount}</span></td>
					</tr>
					<!-- 각 주문 항목 아래에 선 추가 -->
					<c:if test="${loop.last || !loop.last}">
						<tr>
							<td colspan="5">
								<hr style="border-color: lightgrey;">
							</td>
						</tr>
					</c:if>
				</c:forEach>
				<c:if test="${empty boards}">
					<tr>
						<td colspan="5"><p>작성된 게시글이 없습니다.</p></td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
		<c:if test="${!empty sessionScope.principal.id }">
			<div class="d-flex justify-content-end">
				<a href="/project4/board?cmd=saveForm" class="btn btn-primary">게시글 작성</a>
			</div>
		</c:if>
		<c:if test="${empty sessionScope.principal.id }">
			<div class="d-flex justify-content-end">
				<button type="button" class="btn btn-secondary" disabled>게시글 작성</button>
			</div>
		</c:if>
		<br>

		<!-- 페이지 진척도 -->
		<div class="progress col-md-12">
			<div class="progress-bar" style="width: ${currentPercent}%"></div>
		</div>
		<br />
		<!-- 검색을 통해 나온 페이지 처리 -->
		<ul class="pagination justify-content-center">
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

		<!-- 카테고리 선택을 통해 나온 페이지 처리 -->
			<c:choose>
				<c:when test="${empty param.category }">
					<%-- <c:set> : 변수 사용 --%>
					<c:set var="pagePrev" value="/project4/board?cmd=list&page=${param.page-1 }"></c:set>
					<c:set var="pageNext" value="/project4/board?cmd=list&page=${param.page+1 }"></c:set>
				</c:when>

				<c:otherwise>
					<c:set var="pagePrev" value="/project4/board?cmd=ctgr&category=${param.category }&page=${param.page-1 }"></c:set>
					<c:set var="pageNext" value="/project4/board?cmd=ctgr&category=${param.category }&page=${param.page+1 }"></c:set>
				</c:otherwise>
			</c:choose>

			<!-- 단순 페이지 처리 -->
			<c:choose>
				<c:when test="${param.page == 0 }">
					<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
				</c:when>
				<c:otherwise>
					<li class="page-item"><a class="page-link" href="${pageScope.pagePrev }">Previous</a></li>
					<%-- <li class="page-item"><a class="page-link" href="/project4/board?cmd=list&page=${param.page-1 }">Previous</a></li> --%>
				</c:otherwise>
			</c:choose>

			<c:choose>
				<c:when test="${lastPage == param.page}">
					<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
				</c:when>
				<c:otherwise>
					<li class="page-item"><a class="page-link" href="${pageScope.pageNext }">Next</a></li>
					<%-- <li class="page-item"><a class="page-link" href="/project4/board?cmd=list&page=${param.page+1 }">Next</a></li> --%>
				</c:otherwise>
			</c:choose>
		</ul>
		<!-- 페이지 처리 종료 -->
</div>

<style>

thead th {
	border-top: 1px solid;
	border-bottom: 1px solid;
	padding-top: 10px;
	padding-bottom: 10px;
}

.nav-pills .nav-link {
    padding: 5px 10px; 
}
.nav-pills .nav-item {
    margin-right: 5px;
}
.nav-pills .nav-link:not(.active) {
	color: grey;
    background-color: #f2f2f2; 
}

a {
    color: black;
    text-decoration: none; 
}

a:hover {
    color: #CB444A;
    text-decoration: underline; 
}


</style>

<%@ include file = "../layout/footer.jsp" %>
