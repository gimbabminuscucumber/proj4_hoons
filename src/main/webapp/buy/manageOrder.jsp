<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/trophy.png" alt="Logo" style="width: 50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">주문 관리</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<!-- 상단 버튼 -->
	<div class="d-flex justify-content-between align-items-center mb-3">
		<ul class="nav nav-pills" role="tablist">
			<c:if test="${empty param.state }">
				<li class="nav-item" ><a style="background-color: #007bff; color:white" class="nav-link" href="/project4/buy?cmd=manageOrder&page=0" >전체</a></li>
			</c:if>
			<c:if test="${not empty param.state }">
				<li class="nav-item" ><a class="nav-link" href="/project4/buy?cmd=manageOrder&page=0" >전체</a></li>
			</c:if>
			<div class="dropdown">
				<button type="button" class="btn btn-outline-success dropdown-toggle" data-toggle="dropdown" style="height: 33px; padding-top:4px; ">주문</button>
				<div class="dropdown-menu">
					<a class="dropdown-item" href="/project4/buy?cmd=manageState&page=0&state=0">주문완료</a>
					<a class="dropdown-item" href="/project4/buy?cmd=manageState&page=0&state=9">구매완료</a>
				</div>
			</div>
			&nbsp;
			<div class="dropdown">
				<button type="button" class="btn btn-outline-info dropdown-toggle" data-toggle="dropdown" style="height: 33px; padding-top:4px; ">배송</button>
				<div class="dropdown-menu">
					<a class="dropdown-item" href="/project4/buy?cmd=manageState&page=0&state=1">배송중</a>
					<a class="dropdown-item" href="/project4/buy?cmd=manageState&page=0&state=2">배송완료</a>
				</div>
			</div>
			&nbsp;
			<div class="dropdown">
				<button type="button" class="btn btn-outline-danger dropdown-toggle" data-toggle="dropdown" style="height: 33px; padding-top:4px; ">환불</button>
				<div class="dropdown-menu">
					<a class="dropdown-item" href="/project4/buy?cmd=manageState&page=0&state=6">환불 신청</a>
					<a class="dropdown-item" href="/project4/buy?cmd=manageState&page=0&state=7">환불 완료</a>
					<a class="dropdown-item" href="/project4/buy?cmd=manageState&page=0&state=8">환불 불가</a>
				</div>
			</div>
		</ul>
		
		<!-- 날짜 선택란 -->
		<form action="orderList" method="get" class="form-inline">
			<div class="form-group" >
				<input type="date" id="startDate" name="startDate" >&nbsp;
				<input type="date" id="endDate" name="endDate" >&nbsp;
				<button type="button" class="btn btn-primary btn-sm" onclick="">조회하기</button>
			</div>
		</form>
	</div>
	
	<br>

	<div class="form-group">
		<table>
			<thead>
				<tr>
					<th style="width: 380px">상품 정보</th>
					<th style="width: 150px">주문 일자</th>
					<th style="width: 150px">주문 번호</th>
					<th style="width: 150px">주문 금액(수량)</th>
					<th style="width: 150px">구매자</th>
					<th style="width: 120px">주문 상태</th>
					<th style="width: 120px">주문 처리</th>
				</tr>
			</thead>
			<tbody style="font-size:14px">
				<c:forEach var="order" items="${orders}" varStatus="loop">
					<input type="hidden" id="userId" value="${sessionScope.principal.id }">
					<c:if test="${loop.first}">
						<tr>
							<td colspan="7" style="padding-top: 10px;"></td>
						</tr>
					</c:if>

					<tr>
						<td style="padding-left: 20px; text-align: left;">
							<div style="display: flex; align-items: center;">
								<div>
									<strong>${order.brand}</strong><br>
									<a href="/project4/product?cmd=detail&id=${order.productId }">${order.content}</a>
								</div>
							</div>
						</td>
						<td>
							<fmt:formatDate pattern="yyyy-MM-dd" value="${order.createDate}"></fmt:formatDate>
						</td>
						<td>
							<span><a href="/project4/buy?cmd=detail&orderNum=${order.orderNum }">${order.orderNum}</a></span>
						</td>
						<td>
							<fmt:formatNumber type="number" pattern="#,##0" value="${order.totalPrice}" />원<br>
							<span style="color: grey">${order.totalCount}개</span>
						</td>
						<td>${order.nickName }</td>
						<td>
							<span style="display: inline-block;">
								<c:if test="${order.state == 0 }">주문 완료</c:if>
								<c:if test="${order.state == 1 }">배송중</c:if>
								<c:if test="${order.state == 2 }">배송 완료</c:if>
								
								<c:if test="${order.state == 3 }">교환 신청</c:if>
								<c:if test="${order.state == 4 }">교환 완료</c:if>
								<c:if test="${order.state == 5 }">교환 불가</c:if>
								
								<c:if test="${order.state == 6 }">환불 신청</c:if>
								<c:if test="${order.state == 7 }">환불 완료</c:if>
								<c:if test="${order.state == 8 }">환불 불가</c:if>

								<c:if test="${order.state == 9 }">구매 완료</c:if>
							</span>
						</td>
						<td>
							<span style="display: inline-block">

								<c:choose>
									<c:when test="${order.state == 0}">
										<button type="button" class="btn btn-outline-primary btn-sm" onclick="stateChange(${order.id}, 1)" >배송 전달</button>
									</c:when>
									<c:when test="${order.state == 1}">
										<button type="button" class="btn btn-outline-info btn-sm" onclick="stateChange(${order.id}, 2)" >배송 완료</button>
									</c:when>
									<c:when test="${order.state == 2}">
										<button type="button" class="btn btn-secondary btn-sm" disabled>배송 완료</button>
									</c:when>
									<c:when test="${order.state == 9}">
										<button type="button" class="btn btn-secondary btn-sm" disabled>구매 완료</button>
									</c:when>
								</c:choose>

								<c:choose>
									<c:when test="${order.state == 6}">
										<button type="button" class="btn btn-outline-primary btn-sm" onclick="stateChange(${order.id}, 7)" >환불 승인</button>
										<button type="button" class="btn btn-outline-danger btn-sm" style="margin-top:5px" onclick="stateChange(${order.id}, 8)" >환불 불가</button>
									</c:when>
									<c:when test="${order.state == 7}">
										<button type="button" class="btn btn-secondary btn-sm" disabled>환불 승인</button>
									</c:when>
									<c:when test="${order.state == 8}">
										<button type="button" class="btn btn-secondary btn-sm" disabled>환불 불가</button>
									</c:when>
								</c:choose>

							</span>
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
				<c:if test="${empty orders}">
					<tr>
						<td colspan="7">주문 내역이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
		
		<!-- 페이지 처리 -->
		<br><br>
		<section class="container">
			<ul class="pagination justify-content-center">
				<!-- 상황별 변수 설정 -->
				<c:choose>
					<c:when test="${empty param.state}">
						<c:set var="pagePrev" value="/project4/buy?cmd=manageOrder&page=${param.page-1}"/>
						<c:set var="pageNext" value="/project4/buy?cmd=manageOrder&page=${param.page+1}"/>
					</c:when>
					
					<c:when test="${!empty param.state}">
						<c:set var="pagePrev" value="/project4/buy?cmd=manageState&page=${param.page-1}&state=${param.state }"/>
						<c:set var="pageNext" value="/project4/buy?cmd=manageState&page=${param.page+1}&state=${param.state }"/>
					</c:when>
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
								<c:when test="${!empty param.state}">
									<c:set var="pageLink" value="/project4/buy?cmd=manageState&page=${i}&state=${param.state }"/>
								</c:when>
								<c:otherwise>
									<c:set var="pageLink" value="/project4/buy?cmd=manageState&page=${i}"/>
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
		</section>


	</div>
</div>

<script>
	function stateChange(id, state){
		console.log('주문 처리 버튼 클릭');
		console.log('id : ' + id + "   state : " + state);
		
		location.href="/project4/buy?cmd=stateChange&page=0&id=" + id + "&state=" + state;
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
