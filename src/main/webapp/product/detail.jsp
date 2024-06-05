<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<!-- 메인 -->
<div class="container">
	<form action="/project4/buy?cmd=buyForm" method="POST" name="buy" id="buyForm" enctype="multipart/form-data">
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
	                <br>
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

<!-- 다른 고객들이 많이 본 상품 -->
<div class="container">
	<hr>
	<br>
	<br>
	<h5><strong>다른 고객들이 많이 본 상품</strong></h5>
	<br>
	<div class="row">
		<c:forEach var="mostView" items="${mostViews}" varStatus="status">
			<div class="col-md-3">
				<div class="card m-2">
					<a href="/project4/product?cmd=detail&id=${mostView.id }">
						<img src="${pageContext.request.contextPath}/images/productImg/${mostView.img}" alt="Product Image" style="width: 100%; height: 152px;">
					</a>
					<div class="card-body">
						<div><a href="/project4/product?cmd=detail&id=${mostView.id }"><strong>${mostView.brand}</strong></a></div>
						<p style="font-size: 13px; color: grey">${mostView.content }</p>
						<h5><strong><fmt:formatNumber type="number" pattern="#,##0"  value="${mostView.price}"/></strong>원</h5>
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
	        <a class="nav-link" href="#" onclick="scrollToDetail(event, 'productDetail')">상품상세정보</a>
	    </li>
	    <li class="nav-item">
	        <a class="nav-link" href="#" onclick="scrollToDetail(event, 'customerReviews')">고객리뷰</a>
	    </li>
	    <li class="nav-item">
	        <a class="nav-link" href="#" onclick="scrollToDetail(event, 'suggestProducts')">추천상품</a>
	    </li>
	    <li class="nav-item">
	        <a class="nav-link" href="#" onclick="scrollToDetail(event, 'deliveryNreturn')">배송/반품/교환 안내</a>
	    </li>
	</ul>
	<br>
	<br>
	<br>
		
	<!-- 상품상세정보 -->
	<div id="productDetail" style="text-align:center">
		<c:if test="${empty  products.explanation}"></c:if>
		<c:if test="${!empty  products.explanation}">
			<img src="/project4/images/productImg/${products.explanation }" id="productDetail" alt="Product Detail" >
		</c:if>
		<br>
		<br>
		<hr style="border-color: lightgrey;">
		<br>
		<br>
	</div>
	
	<!-- 고객리뷰 -->
	<h5 id="customerReviews"><strong>고객리뷰</strong></h5>
	<br>
	<c:if test="${not empty reviews}">
		<c:forEach var="review" items="${reviews}" varStatus="status">
		    <div class="container" style="<c:if test='${!status.last}'>border-bottom: 1px solid lightgrey; padding-bottom: 10px; margin-bottom: 10px;</c:if>">
		        <div id="${review.id }">
		            <div class="d-flex">
		                <strong>${review.nickName }</strong>
		                <p style="color:grey; margin-left: 5px; margin-right: 5px">l</p>
		                <fmt:formatDate pattern="yyyy.MM.dd" value="${review.createDate}"></fmt:formatDate>
		                <!-- 삭제버튼 -->
		                <div class="ml-auto">
		                    <c:if test="${sessionScope.principal.id == review.userId }">
		                        <i onclick="deleteReply(${review.id})" class="material-icons" style="cursor:pointer">delete</i>
		                    </c:if>
		                </div>
		            </div>
		            <div>
		                <p style="font-size: 13px"><c:forEach var="i" begin="1" end="${review.score }">⭐️</c:forEach></p>
		                <p>${review.text }</p>
		            </div>
		        </div>
		    </div>
		</c:forEach>
	</c:if>
	
	<c:if test="${empty reviews}">
	    <p>작성된 리뷰가 없습니다.</p>
	</c:if>
	<br>
	<br>
	<hr style="border-color: lightgrey;">
	<br>
	<br>
	
	<!-- 추천상품 -->
	<h5 id="suggestProducts"><strong>고객님께 추천하는 상품</strong></h5>
	<br>
	<div class="row">
		<c:forEach var="suggest" items="${suggests}" varStatus="status">
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
		
	<br>
	<br>
	<hr style="border-color: lightgrey;">
	<br>
	<br>
	
	<!-- 배송/반품/교환 안내 -->
	<h5 id="deliveryNreturn"><strong>배송/반품/교환 안내</strong></h5>
	<br>
	<br>
	<div style="font-size:12px">
		<div class="d-flex" >
			<div style="font-weight: bold; width: 170px">교환/반품 신청기간</div>
			<div>
				<span>단순변심 및 사이즈/색상 불만에 관련된 교환/반품 신청은 배송완료 후 7일 이내에 가능합니다.</span><br>
				<span>상품이 표기/광고내용과 다르거나 계약내용과 다른 경우 상품을 받으신 날부터 3개월 이내, 또는 사실을 알게된 날(알 수 있었던 날)부터 30일 이내에 신청 가능합니다.</span>
			</div>
		</div>
		<hr style="color: grey">
		<div class="d-flex" >
			<div style="font-weight: bold; width: 170px">교환/반품 회수(배송)비용</div>
			<div>
				<span>상품의 불량/하자 또는 표시광고 및 계약 내용과 다른 경우 해당 상품의 회수(배송)비용은 무료이나, 고객님의 단순변심 및 사이즈/색상 불만에 관련된 교환/반품의 경우 택배비는 고객님 부담입니다.</span><br>
				<span>※ 구매 시 선택한 옵션과 수량 또는 프로모션 적용 여부에 따라 반품/교환 배송비가 변경될 수 있습니다.</span><br> 
				<span>자세한 반품/교환 배송비는 '주문 내역'에서 반품/교환 시 확인 가능합니다.</span><br>
				<span><strong>반품 배송비: 3,000원 (최초 배송비가 무료인 경우, 6,000원 부과)</strong></span><br>
				<span><strong>교환 배송비: 6,000원</strong></span><br>
				<span>제주/도서산간 지역은 추가 운임이 발생할 수 있습니다. 단, 반품/교환 비용은 상품 및 반품/교환 사유에 따라 변경될 수 있으므로 반품/교환 신청 화면에서 확인 부탁드립니다.</span>
			</div>
		</div>
		<hr style="color: grey">
		<div class="d-flex" >
			<div style="font-weight: bold; width: 170px">교환/반품 불가 안내</div>
			<div>
				<span><strong>전자상거래 등에서 소비자보호에 관한 법률에 따라 다음의 경우 청약철회가 제한될 수 있습니다.</strong></span><br>
				<span>고객님이 상품 포장을 개봉하여 사용 또는 설치 완료되어 상품의 가치가 훼손된 경우</span><br>
				<span>(단, 내용 확인을 위한 포장 개봉의 경우는 예외)</span><br>
				<span>고객님의 단순변심으로 인한 교환/반품 신청이 상품 수령한 날로부터 7일이 경과한 경우</span><br>
				<span>신선식품(냉장/냉동 포함)을 단순변심/주문착오로 교환/반품 신청하는 경우</span><br>
				<span>고객님의 사용 또는 일부 소비에 의해 상품의 가치가 훼손된 경우</span><br>
				<span>시간 경과에 따라 상품 등의 가치가 현저히 감소하여 재판매가 불가능한 경우</span><br>
				<span>기타, 상품의 교환, 환불 및 상품 결함 등의 보상은 소비자분쟁해결기준(공정거래위원회 고시)에 의함</span>
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
    function scrollToDetail(event, elementId) {
        event.preventDefault(); // 기본 동작 막기
        var element = document.getElementById(elementId);
        if (element) {
            element.scrollIntoView({behavior: 'smooth', block: 'start'});
        }
    }

     // 구매하기 버튼 클릭 (주문서 작성)
        function purchase() {
            console.log('구매하기 버튼 클릭');
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
                img: img,
                brand: brand,
                price: price,
                content: content,
                totalCount: quantity,
                totalPrice: totalPrice
            };
            
            $.ajax({
                type: "post",
                url: "/project4/buy?cmd=orderSheet",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            }).done(function(resp){
                if(resp.statusCode == 1){
                    // 생성된 id 값 가져오기
                    var id = resp.data;
                    // detail.jsp로 새로운 URL 생성
                    location.href = "/project4/buy?cmd=buyForm2&userId=" + userId + "&productId=" + productId;
                } else {
                    alert('주문서 작성에 실패했습니다.');
                }
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
	
	// 리뷰 삭제
	function deleteReply(reviewId	){
		console.log('리뷰 삭제/reviewId : ' + reviewId);
		
		$.ajax({
			type:"post",
			url: "/project4/buy?cmd=reviewDelete&id="+reviewId,
			dataType: "json"
		}).done(function(data){
			if(data.statusCode == 1){
				console.log('댓글 삭제');
				alert("댓글을 삭제했습니다.");
				location.reload();
			}else{
				alert("댓글 삭제에 실패했습니다.");
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