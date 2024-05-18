<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<div class="container">
    <br> 
    <br>
    <h6 class="d-flex justify-content-end"> </h6>
    
    <c:if test="${products.categoryId == 0}">육류</c:if>
    <c:if test="${products.categoryId == 1}">과일</c:if>
    <c:if test="${products.categoryId == 2}">야채</c:if>
    
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                	<input type="hidden" name="userId" value="${sessionScope.principal.id }">
                	<input type="hidden" name="productId" value="${products.id }">
                   	<img src="/project4/images/productImg/${products.img }" alt="Product Image" style="width: 100%; max-width: 400px; height: auto;">
                </div>
            </div>
            <div class="col-md-6">
                <h2>${products.name}</h2>
                <p><span id="purchase">${products.count }</span></p>
                <p class="price"><fmt:formatNumber type="number" pattern="#,##0" value="${products.price}"/>원</p>
                <c:if test="${products.content == null}"></c:if>
                <c:if test="${products.content != null}"> <p>${products.content}</p></c:if>
               
                <div class="form-group">
                    <button type="button" class="btn btn-light" onclick="minus()">-</button>
                    <input type="text" class="btn btn" id="quantity" value="1" min="1" style="width:50px">
                    <button type="button" class="btn btn-light" onclick="plus()">+</button>
                </div>
                <div class="form-group"><p>총 금액: <span id="totalPrice"></span>원</p></div>
               
                <button type="button" class="btn btn-outline-danger">♡</button>
                <button type="button" class="btn btn-outline-info">장바구니에 추가</button>
                <button type="button" class="btn btn-primary" onclick="buyProduct()">구매하기</button>
            </div>
        </div>
    </div>
</div>

<script>
	// 수량 +
    function plus(){
        var digit = document.getElementById("quantity");
        var digitUp = parseInt(digit.value);
        digit.value = digitUp + 1;
        updateTotalPrice();
    }

	// 수량 -
    function minus(){
        var digit = document.getElementById("quantity");
        var digitDown = parseInt(digit.value);
        if(digitDown > 1) { // 최소값은 1로 제한
            digit.value = digitDown - 1;
        }
        updateTotalPrice();
    }

	// 총 구매 금액
    function updateTotalPrice() {
        var quantity = parseInt(document.getElementById("quantity").value);
        var price = parseInt(${product.price});
        document.getElementById("totalPrice").innerText = price * quantity;
    }
	
	// 제품 구매 
    function buyProduct() {
        var quantity = $("#quantity").val();
        var userId = $("input[name='userId']").val();
        var productId = $("input[name='productId']").val();
        
        var data = {
            userId: userId,
            productId: productId,
            quantity: quantity
        };

        $.ajax({
            type: "POST",
            url: "/project4/product?cmd=buyProduct",
            data: JSON.stringify(data),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        }).done(function(result) {
            if (result) {
                $("#purchase").text(result.data.count);
                alert("구매가 완료되었습니다!");
            } else {
                alert("구매 실패");
            }
        }).fail(function(error) {
            console.log("Error: ", error);
            alert("구매 중 오류가 발생했습니다.");
        });
    }

</script>
