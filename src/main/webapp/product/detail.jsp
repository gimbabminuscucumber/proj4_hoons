<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<div class="container">
	<form action="/project4/buy?cmd=buyForm" method="POST" name="buy"  enctype="multipart/form-data">
		<input type="hidden" name="userId" id="userId" value="${principal.id}">
		<input type="hidden" name="nickName" id="nickName" value="${principal.nickName}">
		<input type="hidden" name="address" id="address" value="${principal.address}">
		<input type="hidden" name="phone" id="phone" value="${principal.phone}">
		<input type="hidden" name="productId" id="productId" value="${products.id}">
		<input type="hidden" name="content" id="content" value="${products.content}">
		<input type="hidden" name="weight" id="weight" value="${products.weight}">
		<input type="hidden" name="img" id="img" value="${products.img}">
		<input type="hidden" name="brand" id="brand" value="${products.brand}">
		
        
	    <br> 
	    <br>
	    <p style="font-size: 15px; color: grey; padding-left:18px">
		    카테고리 >  
		    <c:if test="${products.categoryId == 0}">육류</c:if>
		    <c:if test="${products.categoryId == 1}">과일</c:if>
		    <c:if test="${products.categoryId == 2}">채소</c:if>
		    <c:if test="${products.categoryId == 3}">과자/간식</c:if>
		    <c:if test="${products.categoryId == 4}">밀키트</c:if>
	    </p>
	    <div class="container">
	        <div class="row">
	            <div class="col-md-6">
	                <div class="form-group">
	                   	<img src="/project4/images/productImg/${products.img }" alt="Product Image" style="width: 100%; max-width: 400px; height: auto;">
	                </div>
	            </div>
	            <div class="col-md-6">
	                <h2 id="brand">${products.brand}</h2>
	                <div>
	                	<c:if test="${products.content != null}"><h4>${products.content}</h4></c:if>
	                	<c:if test="${products.content == null}"><h4>하단 상세설명 참조</h4></c:if>
	                </div>
	                <p><span id="purchase">리뷰 개수 : </span></p>
	                <h3 class="price" id="price"><fmt:formatNumber type="number" pattern="#,##0"  value="${products.price}"/>원</h3>
	                <p>(weight : ${products.weight }원)</p>
	               
	                <div class="form-group d-flex" >
	                    <button type="button" class="btn btn-light" onclick="minus()" >-</button>
	                    <input type="text" class="btn btn" id="quantity" value="1" min="1" style="width:50px">
	                    <button type="button" class="btn btn-light" onclick="plus()">+</button>
	                </div>
		                <div class="form-group" >
		               		합계 : <span id="totalPrice" style="color: #CB444A; font-size:25px"><span>
		                </div>
	               <div>
		                <button type="button" class="btn btn-outline-info" onclick="basket()">장바구니에 추가</button>
		                <button type="button" class="btn btn-primary" onclick="purchase()">구매하기</button>
	               </div>
	            </div>
	        </div>
	    </div>
	</form>	    
</div>
<div class="container">
<hr>
<br>
<br>

<h5 class="bold-text">다른 고객들이 많이 본 상품</h5>
	<br>
        <div class="row">
            <c:forEach var="suggest" items="${suggests}" varStatus="status">
            	<input type="hidden" name="suggestId" id="suggestId" value="${suggest.id }">
                <div class="col-md-3">
                    <div class="card m-2">
                        <a href="/project4/product?cmd=detail&id=${suggest.id }">
                        	<img src="${pageContext.request.contextPath}/images/productImg/${suggest.img}" alt="Product Image" style="width: 100%; height: 152px;">
                        </a>
                        <div class="card-body">
                           	<div><a href="/project4/product?cmd=detail&id=${suggest.id }"><strong>${suggest.brand}</strong></a></div>
                           	<p style="font-size: 13px; color: grey">${suggest.content }</p>
                       		<h5><strong><fmt:formatNumber type="number" pattern="#,##0"  value="${suggest.price}"/></strong>원</h5>
                        </div>
                    </div>
                </div>
            </c:forEach>
		</div>

<!-- 추가 Info -->
<br>
<br>

<ul class="nav nav-tabs nav-justified">
	<li class="nav-item">
		<a class="nav-link" href="#" onclick="scrollToDetail(event)">상품상세정보</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" href="#">고객리뷰</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" href="#">배송/반품/교환 안내</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" href="#">추천상품</a>
	</li>
</ul>

<br>
<br>
<br>

<!-- 상품상세정보 -->
<c:if test="${empty  products.explanation}"></c:if>
<c:if test="${!empty  products.explanation}">
	<img src="/project4/images/productImg/${products.explanation }" id="productDetail" alt="Product Detail" >
</c:if>

<!-- 고객리뷰 -->
<!-- 
<h5 class="bold-text">포토 & 동영상 리뷰 ${reviews.img }</h5>
<c:if test="${empty  reviews.img}"></c:if>
	<img src="/project4/images/reviewImg/${reviews.img }" id="reviewImg" alt="Review Images" >
<c:if test="${!empty  reviews.img}">
 -->
</c:if>
<br>
<br>


<!-- 배송/반품/교환 안내 -->
<!-- 추천상품 -->

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

    // 초기 총 금액 설정
    window.onload = function() {
        updateTotalPrice();
    };
	
	// 총 구매 금액
    function updateTotalPrice() {
        var totalCount = parseInt(document.getElementById("quantity").value);		// quantity.value를 int로 파싱
        var price = parseInt(${products.price});															// products.price를 int로 파싱
        var totalPrice = price * totalCount;
        var formattedPrice = new Intl.NumberFormat('ko-KR').format(totalPrice);	// 숫자를 1천 단위로 포맷팅

        document.getElementById("totalPrice").innerText = formattedPrice + "원";	// price * quantity 연산값을 totaPrice의 innerText에 담기
	}
	
    // 상세 정보로 스크롤
    function scrollToDetail(event) {
        event.preventDefault(); // 기본 동작 막기
        document.getElementById('productDetail').scrollIntoView({behavior: 'smooth'});
    }
	
	// 주문서 작성
    function purchase() {
		console.log('주문서 작성');
       	var userId = document.getElementById("userId").value;
        var nickName = document.getElementById("nickName").value;
        var address = document.getElementById("address").value;
        var phone = document.getElementById("phone").value;

        var productId = document.getElementById("productId").value;
        var brand = document.getElementById("brand").value;
        var content = document.getElementById("content").value;
        var weight = document.getElementById("weight").value;
       	var quantity = parseInt($("#quantity").val());
        var price = parseInt(${products.price});
        var totalPrice = price * quantity;
        var img = document.getElementById("img").value;
        
        
        var data = {			// json 타입
            userId: userId,
            nickName: nickName,
            address: address,
            phone: phone,
            productId: productId,
            brand: brand,
            content: content,
            weight: weight,
            totalPrice: totalPrice,
            totalCount: quantity,
            img: img
        };

        $.ajax({
        	type: "post",
        	url: "/project4/buy?cmd=buyForm",	// 데이터 보낼 경로
        	data: JSON.stringify(data),
        	contentType: "application/json; charset=utf-8",
        	dataType: "json"
        }).done(function(data){	
        	//window.location.href = "/project4/buy?cmd=buyForm"
        });
	}
	
	// 장바구니에 담기
    function basket() {
		
        var userId = document.getElementById("userId").value;
        var productId = document.getElementById("productId").value;
        var img = document.getElementById("img").value;
        var brand = document.getElementById("brand").value;
        var quantity = parseInt($("#quantity").val());
        var price = parseInt(${products.price});
        var totalPrice = price * quantity;
        var content = document.getElementById("content").value;

        var data = {
            userId: userId,
            productId: productId,
            img: img,					// DB에 저장된 데이터를 el문으로 불러온 데이터를 가져와야하기에 input type="hidden" 사용
            brand: brand,			// DB에 저장된 데이터를 el문으로 불러온 데이터를 가져와야하기에 input type="hidden" 사용
            price: price,
            content: content,
            totalCount: quantity,
            totalPrice: totalPrice
        };

        
		$.ajax({
			type: "post",
			url: "/project4/buy?cmd=basket",
			data: JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			dataType: "json"
		}).done(function(data){
			console.log('ajax 호출 성공');
			if(data.statusCode == 1){
				alert('장바구니에 담았습니다.');
			}else{
				alert('장바구니 담기에 실패했습니다.');
			}
		})
    }
	
</script>

<style>
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