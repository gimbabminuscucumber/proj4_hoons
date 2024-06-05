<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/bag.png" alt="Logo" style="width: 50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">주문내역 조회</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<!-- 상단 버튼 -->
	<div class="d-flex justify-content-between align-items-center mb-3">
		<ul class="nav nav-pills" role="tablist">
			<c:choose>
				<c:when test=""></c:when>
			</c:choose>
			<li class="nav-item"><a class="nav-link active" data-toggle="pill" href="#home">입금/결제</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="pill" href="#menu1">배송중</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="pill" href="#menu2">배송완료</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="pill" href="#menu3">교환</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="pill" href="#menu4">환불</a></li>
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
					<th style="width: 450px">상품 정보</th>
					<th style="width: 170px">주문 일자</th>
					<th style="width: 170px">주문 번호</th>
					<th style="width: 170px">주문 금액(수량)</th>
					<th style="width: 150px">주문 상태</th>
					<th style="width: 150px">주문 관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="order" items="${orders}" varStatus="loop">
					<input type="hidden" id="userId" value="${sessionScope.principal.id }">
					<c:if test="${loop.first}">
						<tr>
							<td colspan="6" style="padding-top: 10px;"></td>
						</tr>
					</c:if>

					<tr>
						<td style="padding-left: 20px; text-align: left;">
							<div style="display: flex; align-items: center;">
								<a href="/project4/product?cmd=detail&id=${order.productId }">
									<img src="/project4/images/productImg/${order.img}" alt="Product Image" style="width: 70px; height: auto; margin-right: 10px;">
								</a>
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
							<fmt:formatNumber type="number" pattern="#,##0" value="${order.totalPrice}" />원 <br> 
							<span style="color: grey">${order.totalCount}개</span>
						</td>
						<td>
							<span style="display: inline-block;">
								<c:if test="${order.state == 0 }">주문 완료</c:if>
								<c:if test="${order.state == 1 }">배송중</c:if>
								<c:if test="${order.state == 2}">배송 완료</c:if>
								
								<c:if test="${order.state == 3 }">교환 신청</c:if>
								<c:if test="${order.state == 4 }">교환 완료</c:if>
								<c:if test="${order.state == 5 }">교환 불가</c:if>
								
								<c:if test="${order.state == 6 }">환불 신청</c:if>
								<c:if test="${order.state == 7 }">환불 완료</c:if>
								<c:if test="${order.state == 8 }">환불 불가</c:if>
							</span>
						</td>
						<td>
							<span style="display: inline-block; ">
								<c:choose>
									<c:when test="${order.status != 1 }">
										<button type="button" class="btn btn-outline-info btn-sm">교환</button>
										<button type="button" class="btn btn-outline-danger btn-sm">환불</button><br>
									</c:when>
									<c:when test="${order.state == 5 || order.state == 8 }">
										<button type="button" class="btn btn-outline-info btn-sm" disabled>교환</button>
										<button type="button" class="btn btn-outline-danger btn-sm" disabled>환불</button><br>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-outline-info btn-sm" disabled>교환</button>
										<button type="button" class="btn btn-outline-danger btn-sm" disabled>환불</button><br>
									</c:otherwise>
								</c:choose>
								<!-- 리뷰 작성 -->
								<c:choose>
									<c:when test="${order.status == 1}">
										<button type="button" style="margin-top:5px" class="btn btn-secondary btn-sm" disabled>작성 완료</button>
									</c:when>
									<c:when test="${order.state == 0 || order.state == 1}">
										<button type="button" style="margin-top:5px" class="btn btn-outline-primary btn-sm" disabled>리뷰 작성</button>
									</c:when>
									<c:otherwise>
										<button type="button" style="margin-top:5px" class="btn btn-outline-primary btn-sm" onclick="review(${order.id})">리뷰 작성</button>
									</c:otherwise>
								</c:choose>
							</span>	
						</td>
					</tr>
					<!-- 각 주문 항목 아래에 선 추가 -->
					<c:if test="${loop.last || !loop.last}">
						<tr>
							<td colspan="6">
								<hr style="border-color: lightgrey;">
							</td>
						</tr>
					</c:if>
				</c:forEach>
				<c:if test="${empty orders}">
					<tr>
						<td colspan="6">주문 내역이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>

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
