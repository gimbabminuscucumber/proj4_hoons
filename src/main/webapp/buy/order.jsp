<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/clap.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">주문완료</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="width: 500px">

	<!-- 주문번호 -->
	<c:if test="${!empty orders}">
		<div class="form-group">
			<strong>주문번호</strong> 
			<a href="/project4/buy?cmd=detail&orderNum=${orders[0].orderNum }">${orders[0].orderNum }</a>
			<hr style="border-color: lightgrey;">
		</div>
	</c:if>
	
	<!-- 상품 정보 -->
    <c:forEach var="order" items="${orders}" varStatus="loop">
		<div class="form-group" style="margin-top: 20px; margin-bottom: 20px;">
	        <div style="display: flex; align-items: center;">
	            <div>
	            	<a href="/project4/product?cmd=detail&id=${order.productId }">
	            		<img src="/project4/images/productImg/${order.img }" alt="Product Image" style="width: 100%; max-width: 100px; height: auto;">
	            	</a>
	            </div>
	            <div style="margin-left: 20px;">
	                <div><a href="#">${order.brand }</a></div>
	                <div>
	                	<strong><a href="/project4/product?cmd=detail&id=${order.productId }">${order.content }</a></strong>
	                </div>
					<div>주문 수량 : ${order.totalCount }개</div>
					<div>
						<span>주문 금액 : </span>
						<fmt:formatNumber type="number" pattern="#,##0"  value="${order.totalPrice}"/>원
					</div>
	            </div>
	        </div>
			<hr style="border-color: lightgrey;">
		</div>
	</c:forEach>
	<br>
	<div class="d-flex">
		<button type="button"  class="btn btn-danger" style="width: 50%">주문 취소</button> &nbsp;
		<button type="button"  class="btn btn-primary" style="width: 50%" onclick="location.href='/project4/buy?cmd=list&page=0&userId=${userId}'">주문 내역 바로가기</button>
	</div>
</div>

<%@ include file = "../layout/footer.jsp" %>
