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

		<div class="form-group">
		    <div>주문번호 
		    	<a href="/project4/buy?cmd=basket&id=${orders.userId }">${orders.orderNum }</a>
		    </div>
			<hr>
			<p>${orders.nickName }</p>
			<span>${orders.address }</span>
			<hr>
	        <div style="display: flex; align-items: center;">
	            <div>
	            	<a href="/project4/product?cmd=detail&id=${orders.productId }">
	            		<img src="/project4/images/productImg/${orders.img }" alt="Product Image" style="width: 100%; max-width: 100px; height: auto;">
	            	</a>
	            </div>
	            <div style="margin-left: 20px;">
	                <div><a href="#">${orders.brand }</a></div>
	                <div><strong>${orders.content }</strong></div>
					<div>주문 수량 : ${orders.totalCount }개</div>
					<div>
						<span>주문 금액 : </span>
						<fmt:formatNumber type="number" pattern="#,##0"  value="${orders.totalPrice}"/>원
					</div>
	            </div>
	        </div>
		</div>
		
		
		
</div>


