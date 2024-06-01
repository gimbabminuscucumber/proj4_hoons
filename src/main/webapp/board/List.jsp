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
		<div style="color: #353A3F; font-weight: bold">게시글 조회</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<!-- 상단 버튼 -->
	<div class="d-flex justify-content-between align-items-center mb-3">
		<ul class="nav nav-pills" role="tablist">
			<li class="nav-item"><a class="nav-link active" data-toggle="pill" href="#home">🔥Hot 레시피</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="pill" href="#menu1">⏰무물 타임</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="pill" href="#menu2">🏆이달의 이벤트</a></li>
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
					<c:if test="${empty boards}">
						<tr>
							<td colspan="5">작성된 게시글이 없습니다.</td>
						</tr>
					</c:if>
					
					<c:if test="${loop.first}">
						<tr>
							<td colspan="5" style="padding-top: 15px;"></td>
						</tr>
					</c:if>

					<tr>
						<td>
							<span>
								<c:if test="${board.category == 0}">카테고리 없음</c:if>
								<c:if test="${board.category == 1}">1</c:if>
								<c:if test="${board.category == 2}">2</c:if>
								<c:if test="${board.category == 3}">3</c:if>
							</span>
						</td>
						<td style="padding-left: 20px; text-align: left;"><strong><a href="/project4/board?cmd=detail&id=${board.id }">${board.title}</a></strong></td>
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
			</tbody>
		</table>
	</div>

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
		<!-- 페이지 처리 종료 -->

</div>

<script>
	function review(id){
		console.log('리뷰작성 버튼 클릭');
		console.log('buy테이블의 id : ' + id);
		
		location.href="/project4/buy?cmd=reviewForm&id=" + id;
		
	}
</script>

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
