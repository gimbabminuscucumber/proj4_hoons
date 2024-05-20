<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<div class="container">
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
                	<input type="hidden" name="userId" id="userId" value="${principal.id}">
					<input type="hidden" name="productId" id="productId" value="${products.id}">
                   	<img src="/project4/images/productImg/${products.img }" alt="Product Image" style="width: 100%; max-width: 400px; height: auto;">
                </div>
            </div>
            <div class="col-md-6">
                <h2>${products.brand}</h2>
                <div>
                	<c:if test="${products.content != null}"><h4>${products.content}</h4></c:if>
                	<c:if test="${products.content == null}"><h4>하단 상세설명 참조</h4></c:if>
                </div>
                <p><span id="purchase">리뷰 개수 : </span></p>
                <h3 class="price" id="price"><fmt:formatNumber type="number" pattern="#,##0"  value="${products.price}"/>원</h3>
                <p>(weight : ${products.weight }원)</p>
                <c:if test="${products.content == null}"></c:if>
               
                <div class="form-group d-flex" >
                    <button type="button" class="btn btn-light" onclick="minus()" >-</button>
                    <input type="text" class="btn btn" id="quantity" value="1" min="1" style="width:50px">
                    <button type="button" class="btn btn-light" onclick="plus()">+</button>
                </div>
	                <div class="form-group" >
	               		합계 : <span id="totalPrice" style="color: #CB444A; font-size:25px"><span>
	                </div>
               <div>
	                <button type="button" class="btn btn-outline-info">장바구니에 추가</button>
	                <button type="button" class="btn btn-primary" onclick="buyProduct()">구매하기</button>
               </div>
            </div>
        </div>
    </div>
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

        document.getElementById("totalPrice").innerText = formattedPrice + "원";			// price * quantity 연산값을 totaPrice의 innerText에 담기
	}
	
    // 상세 정보로 스크롤
    function scrollToDetail(event) {
        event.preventDefault(); // 기본 동작 막기
        document.getElementById('productDetail').scrollIntoView({behavior: 'smooth'});
    }
	
	// 구매하기
    function buyProduct() {
		
        var userId = $("input[name='userId']").val();			// name이 userId인 input 요소의 val()를 var userId에 저장
        var productId = $("input[name='productId']").val();
        var quantity = parseInt($("#quantity").val());
        var price = parseInt(${products.price});
        var totalPrice = price * quantity;
       	
        if (!userId || !productId || !quantity || !price || totalPrice <= 0) {
            alert("유효한 값을 입력해주세요.");
            return;
        }
        
        var data = {
            userId: userId,
            productId: productId,
            totalPrice: totalPrice,
            totalCount: quantity
        };
        
        $.ajax({
            type: "POST",
            url: "/project4/product?cmd=buyProduct",
            data: JSON.stringify(data),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        }).done(function(result) {
    		if(result.statusCode == 1){
                $("#purchase").text(result.data.count);		// count 값을 id가 "purchase"인 HTML 요소의 텍스트로 설정
                alert("구매가 완료되었습니다!");
            } else {
                alert("구매에 실패했습니다");
            }
        }).fail(function(error) {
            console.log("Error: ", error);
            alert("구매 중 오류가 발생했습니다.");
        });

	}
</script>

<style>
/* a태그 스타일*/
/* a 태그 기본 색상을 검정색으로 설정 */
a {
    color: black;
    text-decoration: none; /* 밑줄 없애기 */
}

/* a 태그에 마우스를 올렸을 때 색상을 회색으로 설정 (선택 사항) */
a:hover {
    color: #CB444A;
    text-decoration: underline; /* 밑줄 추가 (선택 사항) */
}


</style>

<%@ include file = "../layout/footer.jsp" %>