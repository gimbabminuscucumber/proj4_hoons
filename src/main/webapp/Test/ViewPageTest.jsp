<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/cart.png" alt="Logo" style="width: 50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">장바구니</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">
 	<form action="/project4/buy?cmd=buyForm" method="post" id="buyForm"> 
 		<input type="hidden" id="userId" value="${sessionScope.principal.id }">
		<div class="form-group">
			<table>
				<thead>
					<tr>
						<th style="width: 100px">전체 <span id="totalItems"></span>개</th>
						<th style="width: 100px"><input type="checkbox" id="selectAll"></th>
						<th style="width: 450px">상품정보</th>
						<th style="width: 200px">판매가</th>
						<th style="width: 200px">수량</th>
						<th style="width: 200px">주문금액</th>
						<th style="width: 200px">주문관리</th>
					</tr>
				</thead>
	
				<tbody>
					<c:set var="totalCount" value="0" />
					<c:forEach var="basket" items="${baskets}" varStatus="loop">
						<input type="hidden" name="basketId" id="basketId" value="${basket.id }">
						<c:set var="totalCount" value="${totalCount + 1}" />
						<c:if test="${loop.first}">
							<tr>
								<td colspan="7" style="padding-top: 16px;"></td>
							</tr>
						</c:if>
	
						<tr>
							<td>
								${loop.index + 1}
							</td>
							<td>
								<!-- <input type="checkbox" class="productCheck" name="productCheck" id="productCheck" value="${basket.productId}"> --> 
								<input type="checkbox" class="productCheck" name="productCheck" id="productCheck_${basket.id}" value="${basket.id}"> 
							</td>
							<td style="padding-left: 20px; text-align: left;">
								<div style="display: flex; align-items: center;">
									<a href="/project4/product?cmd=detail&id=${basket.productId }">
										<img src="/project4/images/productImg/${basket.img}" alt="Product Image" style="width: 70px; height: auto; margin-right: 10px;">
									</a>
									<div>
										<strong>${basket.brand}</strong><br> ${basket.content}
									</div>
								</div>
							</td>
							<td>
								<fmt:formatNumber type="number" pattern="#,##0" value="${basket.price}" />원 <br> 
							</td>
							<td>
								<span>${basket.totalCount}개</span>
							</td>
							<td>
								<fmt:formatNumber type="number" pattern="#,##0" value="${basket.totalPrice}" />원 <br> 
							</td>
							<td>
							basket.id = ${basket.id}
								<div class="d-flex justify-content-center">
									<button type="button"	 class="btn btn-outline-info btn-sm" >변경</button>&nbsp;
									<button type="button" class="btn btn-outline-danger btn-sm"  onclick="productDelete(${basket.id})">삭제</button>
								</div>
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
					
					<c:if test="${empty baskets}">
						<tr>
							<td colspan="7"><br><p>장바구니에 상품이 없습니다.</p></td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
		
		<c:if test="${!empty baskets}">
			<div class="form-group">
				<button type="button"	 class="btn btn-outline-danger btn-sm d-flex justify-content-start">선택삭제</button>
			</div>
		</c:if>
		
		<div class="container" style="text-align: left; color:grey; font-size:12px">
			<li>주문완료 후 출고 전 배송지 변경은 동일 권역(일반, 제주, 제주 외 도서산간 지역) 내에서만 가능합니다.</li>
			<li>장바구니에는 최대 100개의 상품을 보관할 수 있으며, 주문당 한번에 주문 가능한 상품수는 100개로 제한됩니다.</li>
		</div>
		<br>
	
		<br>
		
		<c:if test="${empty baskets}">
			<div class="form-group container"><button type="button"	 class="btn btn-primary btn-lg" id="buy" style="width:200px" disabled>주문하기</button></div>
		</c:if>
		<c:if test="${!empty baskets}">
			<div class="form-group container"><button type="button"	 class="btn btn-primary btn-lg" id="buy" style="width:200px" >주문하기</button></div>
		</c:if>
	</form>	
	
</div>


<script>
            /*
    document.addEventListener("DOMContentLoaded", function() {		// 해당 페이지 내의 모든 DOM 요소를 이벤트 리스너로 활성화
	    // 1. 첫 번째 <th>에 총 항목 개수 표시
	    document.getElementById("totalItems").textContent = "${totalCount}";
	    
	    // 2. checkbox 모두 체크하기
        document.getElementById("selectAll").addEventListener("change", function() {		// ID가 "selectAll"인 요소에서 변경 이벤트가 발생했을 때 이벤트 리스너가 활성화됩니다.
            let checkboxes = document.querySelectorAll(".productCheck");								// 모든 클래스가 "productCheck"인 체크박스 요소들을 선택하여 checkboxes 변수에 할당
            checkboxes.forEach(function(checkbox) {																	// checkboxes 배열의 각 요소에 대해 반복문을 실행
                checkbox.checked = document.getElementById("selectAll").checked;					// 각 체크박스의 체크 상태를 "selectAll" 체크박스의 체크 상태와 동일하게 설정
            });
        });

	    // 3. checkbox에 check된 상품 '주문서 작성' 페이지로 데이터 넘기기 
        document.getElementById("buy").addEventListener("click", function() {					// id가 buy인 요소 클릭시 이벤트 리스터 활성
            let form = document.getElementById("buyForm");
            let checkboxes = document.querySelectorAll(".productCheck:checked");				// class가 productCheck인 요소 중 체크 된 모든 요소들을 checkboxes에 할당
           	console.log('checkboxes[0].value : ' + checkboxes[0].value);		// value : ${basket.id}
            console.log('checkboxes[1].value : ' + checkboxes[1].value);
            console.log('checkboxes[2].value : ' + checkboxes[2].value);
            if (checkboxes.length > 0) {
                checkboxes.forEach(function(checkbox) {
                	
                    let hiddenInput = document.createElement("input");
                    hiddenInput.type = "hidden";
                    //hiddenInput.name = "productId";
                    hiddenInput.name = "basketId";
                    hiddenInput.value = checkbox.value;
                    form.appendChild(hiddenInput);
                });
                form.submit();
            } else {
                alert("주문할 상품을 선택하세요.");
            }
        });
    });
       */
    // 총 항목 개수 표시 함수
    document.addEventListener("DOMContentLoaded", function() {		// 해당 페이지 내의 모든 DOM 요소를 이벤트 리스너로 활성화
	    // 1. 첫 번째 <th>에 총 항목 개수 표시
		function displayTotalItemCount() {
			document.getElementById("totalItems").textContent = "${totalCount}";
		}
       
       // selectAll 체크박스 이벤트 리스너 함수
       function checkAllCheckboxes() {
           let checkboxes = document.querySelectorAll(".productCheck");
           checkboxes.forEach(function(checkbox) {
               checkbox.checked = document.getElementById("selectAll").checked;
           });
       }

       // 주문 버튼 클릭 이벤트 리스너 함수
       function submitCheckedProducts() {
           let form = document.getElementById("buyForm");
           let checkboxes = document.querySelectorAll(".productCheck:checked");
           if (checkboxes.length > 0) {
               checkboxes.forEach(function(checkbox) {
                   let hiddenInput = document.createElement("input");
                   hiddenInput.type = "hidden";
                   hiddenInput.name = "basketId";
                   hiddenInput.value = checkbox.value;
                   form.appendChild(hiddenInput);
               });
               form.submit();
           } else {
               alert("주문할 상품을 선택하세요.");
           }
       }

       
       
    function productDelete(basketId){
    	console.log('삭제 버튼 클릭/id : ' + basketId);
    	
    	$.ajax().done(function(data){
    		if(data.statusCode == 1){
    			console.log('장바구니 상품 삭제');
    			alert("상품을 삭제했습니다.");
    		}
    	})
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