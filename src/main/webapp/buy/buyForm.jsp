<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
    <div class="d-flex justify-content-center">
        <img src="images/icons/coin.png" alt="Logo" style="width: 50px;">&nbsp;
        <div style="color: #353A3F; font-weight: bold">주문서 작성</div>
    </div>
</h1>
<br>
<br>
<div class="container" style="text-align: center">
    <form action="/project4/buy?cmd=buy" method="post" id="buyProduct">
    	<input type="hidden" id="userId" value="${sessionScope.principal.id }">
    	<input type="hidden" id="address" value="${sessionScope.principal.address }">
        <div class="form-group">
            <!-- 유저 정보 -->
            <p style="text-align:left"><strong>배송지 정보</strong></p>
			<hr style="border-color:black">
			<c:forEach var="order" items="${orders}" varStatus="loop">
				<input type="hidden" id="productId" value="${order.productId }">
				<input type="hidden" id="totalPrice" value="${order.totalPrice }">
				<input type="hidden" id="totalCount" value="${order.totalCount }">
				
			    <c:if test="${loop.first}">
			        <div class="d-flex">
			            <div style="width:150px; font-size:13px; text-align:left">닉네임</div>
			            <div style="font-size:13px; text-align:left">${order.nickName}</div>
			        </div>
			        <hr style="border-color: lightgrey;">
			        <div class="d-flex">
			            <div style="width:150px; font-size:13px; text-align:left">연락처</div>
			            <!-- 전화번호를 하이픈(-)으로 나누기 -->
			            <div style="font-size:13px; text-align:left">
			                <c:set var="phone" value="${order.phone}" />
			                <c:set var="part1" value="${fn:substring(phone, 0, 3)}" />
			                <c:set var="part2" value="${fn:substring(phone, 3, 7)}" />
			                <c:set var="part3" value="${fn:substring(phone, 7, 11)}" />
			                ${part1}-${part2}-${part3}
			            </div>
			        </div>
			        <hr style="border-color: lightgrey;">
			        <div class="d-flex">
			            <div style="width:150px; font-size:13px; text-align:left">배송지</div>
			            <div style="font-size:13px; text-align:left">${order.address}</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<button type="button" onclick="updateAddress()" class="btn btn-outline-info btn-sm" style="padding: 2px 7px; margin-top:-5px; margin-bottom:-1px">주소 수정</button>
			        </div>
			        <hr style="border-color: lightgrey; margin-top: 10px">
			    </c:if>
			</c:forEach>
		<div>
			<li style="color:grey; font-size:12px; text-align:left">결제 전 배송지 주소를 한 번 더 확인해주세요.</li>
			<li style="color:grey; font-size:12px; text-align:left">발송전 일때만 배송지 주소를 변경하실 수 있습니다.(미입금/입금확인/출고요청 단계까지만가능)</li>
		</div>	
		</div>
            
        <br>
        <br>
        <br>
		<div class="form-group">
           <!-- 상품 정보 -->
            <p style="text-align:left"><strong>상품 정보</strong></p>
            <table>
                <thead>
                    <tr>
                        <th style="width: 100px">전체 <span id="totalItems"></span>개</th>
                        <th style="width: 450px">상품정보</th>
                        <th style="width: 200px">판매가</th>
                        <th style="width: 200px">수량</th>
                        <th style="width: 200px">주문금액</th>
                    </tr>
                </thead>
    
                <tbody>
                    <c:set var="totalCount" value="0" />
                    <c:set var="totalSum" value="0" />
                    <c:forEach var="order" items="${orders}" varStatus="loop">
                        <c:set var="totalCount" value="${totalCount + 1}" />
                        <c:set var="totalSum" value="${totalSum + order.totalPrice}" />
                        <c:if test="${loop.first}">
                            <tr>
                                <td colspan="5" style="padding-top: 10px;"></td>
                            </tr>
                        </c:if>
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td style="padding-left: 20px; text-align: left;">
                                <div style="display: flex; align-items: center;">
                                    <a href="/project4/product?cmd=detail&id=${order.productId}">
                                        <img src="/project4/images/productImg/${order.img}" alt="Product Image" style="width: 70px; height: auto; margin-right: 10px;">
                                    </a>
                                    <div>
                                        <strong>${order.brand}</strong><br> ${order.content}
                                    </div>
                                </div>
                            </td>
                            <td>
                                <fmt:formatNumber type="number" pattern="#,##0" value="${order.price}" />원 <br> 
                            </td>
                            <td>
                                <span>${order.totalCount}개</span>
                            </td>
                            <td>
                                <fmt:formatNumber type="number" pattern="#,##0" value="${order.totalPrice}" />원 <br> 
                            </td>
                        </tr>
                        <!-- 각 주문 항목 아래에 선 추가 -->
                        <c:if test="${loop.last || !loop.last}">
                            <tr>
                                <td colspan="5">
                                    <hr style="border-color: lightgrey;">
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <div>
            <c:if test="${empty orders}">
                <p>선택된 상품이 없습니다.</p>
            </c:if>
        </div>
        
        <div style="text-align: left; color:grey; font-size:12px">
            <li>주문완료 후 출고 전 배송지 변경은 동일 권역(일반, 제주, 제주 외 도서산간 지역) 내에서만 가능합니다.</li>
            <li>장바구니에는 최대 100개의 상품을 보관할 수 있으며, 주문당 한번에 주문 가능한 상품수는 100개로 제한됩니다.</li>
        </div>
        <br>
    
        <br>
        <div class="form-group container">
            <button type="button" class="btn btn-primary btn-lg" onclick="buy()" style="width:230px; height:50px">
            	<fmt:formatNumber type="number" pattern="#,##0" value="${totalSum}" />원 결제하기
            </button>
        </div>
    
    </form>    
</div>

<script>
    // 첫 번째 <th>에 총 항목 개수 표시
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("totalItems").textContent = "${totalCount}";
    });
    
    // 구매하기
    function buy(){
        console.log('구매하기 버튼 클릭');
        var userId = document.getElementById("userId").value;
        var data = []; 						// 상품 정보를 저장할 배열
        
        // 각 상품에 대한 정보를 배열에 추가
        <c:forEach var="order" items="${orders}">
            var product = {
                userId: userId,
                productId: ${order.productId},
                totalPrice: ${order.totalPrice},
                totalCount: ${order.totalCount}
            };
            data.push(product);
        </c:forEach>
		
        console.log('JSON.stringify(data) : ' + JSON.stringify(data));
        console.log('userId : ' + userId);
        console.log('data.productId : ' + data.productId);
        console.log('product.productId : ' + product.productId);
        console.log('productId : ' + productId);
	    
        
		$.ajax({
		    type: "post",
		    url: "/project4/buy?cmd=buy",
		    data: JSON.stringify(data),
		    contentType: "application/json",
		    success: function(resp){
		        alert("구매를 완료했습니다.")
		        window.location.href = "/project4/buy?cmd=order&userId="+userId + "&productId=" + product.productId;
		    },error: function(error){
		        alert("구매에 실패했습니다.")
		    }
		});
    }
    
    // 배송지 수정
    function updateAddress(){
    	console.log('배송지 수정 버튼 클릭');
    	var userId = document.getElementById("userId").value;
    	var address = document.getElementById("address").value;
        console.log('userId: ' + userId + ', address: ' + address);
        var pop = window.open("/project4/user/updateAddress.jsp?userId=" + userId + "&address=" + encodeURIComponent(address), "pop", "width=570,height=720,scrollbars=yes,resizable=yes");	
    }
    
    
</script>
<style>
thead th {
	border-top: 1px solid;
	border-bottom: 1px solid;
	padding-top: 10px;
	padding-bottom: 10px;
}
</style>
<%@ include file = "../layout/footer.jsp" %>