<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/trophy.png" alt="Logo" style="width: 50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">유저 관리</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<!-- 상단 버튼 -->
	<div class="d-flex justify-content-between align-items-center mb-1">
		<div>
        	<span>총 회원 : <fmt:formatNumber type="number" pattern="#,##0" value="${userCount}" />명</span>
		</div>
		
		<!-- 검색창 -->
		<!-- - 검색 버튼 누르면 파라미터 3개가 controller로 감 (cmd, page, keyword) -->
		<div>
			<form class="form-inline d-flex justify-content-end" action="/project4/user">
				<input type="hidden" name="cmd" value="search" /> <!-- <form>태그가 /project4/board?cmd=search 로 감 -->
				<input type="hidden" name="page" value="0" /> 
				<input type="text" name="keyword" class="form-control mr-sm-2" placeholder="Search" style="width: 60%">
				<button class="btn btn-primary m-1">검색</button>
			</form>
		</div>
	</div>
	<br>

	<div class="form-group" >
		<table>
			<thead>
				<tr>
					<th style="width: 50px">No</th>
					<th style="width: 200px">닉네임</th>
					<th style="width: 250px">이메일</th>
					<th style="width: 400px">주소</th>
					<th style="width: 200px">연락처</th>
					<th style="width: 150px">가입일자</th>
					<th style="width: 150px">관리</th>
				</tr>
			</thead>
			<tbody style="font-size:14px">
				<c:forEach var="user" items="${users}" varStatus="loop">
					<c:if test="${loop.first}">
						<tr>
							<td colspan="7" style="padding-top: 15px;"></td>
						</tr>
					</c:if>

					<tr>
						<td>
							<span>${user.id }</span>
						</td>
						<td>
							<span style="color:grey">${user.username } / ${user.userRole }</span><br>
							<span>${user.nickName }</span>
						</td>
						<td><span>${user.email }</span></td>
						<td><span>${user.address }</span></td>
						<td>
							<c:set var="phone" value="${user.phone}" />
							<c:set var="part1" value="${fn:substring(phone, 0, 3)}" />
							<c:set var="part2" value="${fn:substring(phone, 3, 7)}" />
							<c:set var="part3" value="${fn:substring(phone, 7, 11)}" />
							${part1}-${part2}-${part3}
    					</td>
						<td><fmt:formatDate pattern="yyyy-MM-dd" value="${user.createDate}"></fmt:formatDate></td>
						<td>
							<button type="button" class="btn btn-outline-danger btn-sm" >탈퇴</button>
						</td>
					</tr>
					<!-- 각 주문 항목 아래에 선 추가 -->
					<c:if test="${loop.last || !loop.last}">
						<tr>
							<td colspan="7">
								<hr style="border-color: lightgrey;">
							</td>
						</tr>
					</c:if>
				</c:forEach>
				<c:if test="${empty users}">
					<tr>
						<td colspan="7"><p>가입된 회원이 없습니다.</p></td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
	<br>
		<!-- 검색을 통해 나온 페이지 처리 -->
		<ul class="pagination justify-content-center">
			<c:choose>
				<c:when test="${empty param.keyword }">
					<c:set var="pagePrev" value="/project4/user?cmd=manageUser&page=${param.page-1 }"></c:set>
					<c:set var="pageNext" value="/project4/user?cmd=manageUser&page=${param.page+1 }"></c:set>
				</c:when>

				<c:otherwise>
					<c:set var="pagePrev" value="/project4/user?cmd=search&page=${param.page-1 }&keyword=${param.keyword }"></c:set>
					<c:set var="pageNext" value="/project4/user?cmd=search&page=${param.page+1 }&keyword=${param.keyword }"></c:set>
				</c:otherwise>
			</c:choose>

				<c:choose>
				<c:when test="${param.page == 0}">
					<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
				</c:when>
				<c:otherwise>
					<li class="page-item"><a class="page-link" href="${pagePrev}">Previous</a></li>
				</c:otherwise>
			</c:choose>
		
			<!-- 페이지 번호 생성 -->
			<c:forEach var="i" begin="0" end="${lastPage}">
				<c:choose>
					<c:when test="${i == param.page}">
						<li class="page-item active"><a class="page-link" href="#">${i + 1}</a></li>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${!empty param.keyword}">
								<c:set var="pageLink" value="/project4/user?cmd=search&page=${i}&keyword=${param.keyword }"/>
							</c:when>
							<c:otherwise>
								<c:set var="pageLink" value="/project4/user?cmd=manageUser&page=${i}"/>
							</c:otherwise>
						</c:choose>
						<li class="page-item"><a class="page-link" href="${pageLink}">${i + 1}</a></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		
			<c:choose>
				<c:when test="${param.page == lastPage}">
					<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
				</c:when>
				<c:otherwise>
					<li class="page-item"><a class="page-link" href="${pageNext}">Next</a></li>
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
