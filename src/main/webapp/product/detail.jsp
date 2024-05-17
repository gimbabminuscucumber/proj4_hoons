<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<div class="container">
    <br> 
    <br>
    <h6 class="d-flex justify-content-end"> </h6>
    
    <c:if test="${empty product}">
        <div>&nbsp; 해당 상품을 찾을 수 없습니다.</div>
    </c:if>
        
    <div class="row">
        <div class="col-md-6">
            <div class="form-group">
                <img src="${pageContext.request.contextPath}/images/productImg/${product.img}" alt="Product Image" style="width: 100%; max-width: 400px; height: auto;">
            </div>
        </div>
        <div class="col-md-6">
            <h2>${product.name}</h2>
            <p class="price"><fmt:formatNumber type="number" pattern="#,##0" value="${product.price}"/>원</p>
            <p>${product.content}</p>
            
	            <div class="form-group">
		            <button type="button" class="btn btn-light" onclick="minus()">-</button>
		            <input type="text" class="btn btn" id="quantity" value="1" min="1" style="width:50px">
		            <button type="button" class="btn btn-light" onclick="plus()">+</button>
	            </div>
	            <div class="form-group"><p>총 금액: <span id="totalPrice">${product.price}</span>원</p></div>
            
            <button type="button" class="btn btn-outline-danger">♡</button>
            <button type="button" class="btn btn-outline-info">장바구니에 추가</button>
            <button type="button" class="btn btn-primary">구매하기</button>
        </div>
    </div>
</div>

<script>
	function plus(){
		var digit = document.getElementById("quantity");
		var digitUp = parseInt(digit.value);
		digit.value = digitUp + 1;
	}

	function minus(){
		var digit = document.getElementById("quantity");
		var digitDown = parseInt(digit.value);
		if(digitDown > 1) { // 최소값은 1로 제한
			digit.value = digitDown - 1;
		}
	}
</script>
