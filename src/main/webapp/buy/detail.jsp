<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/chart.png" alt="Logo" style="width: 50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">주문 상세</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="text-align: center">

	<div class="form-group">
		<table>
			<thead>
				<tr>
					<th style="width: 450px">상품정보</th>
					<th style="width: 200px">주문일자</th>
					<th style="width: 200px">주문번호</th>
					<th style="width: 200px">주문금액(수량)</th>
					<th style="width: 200px">주문상태</th>
				</tr>
			</thead>

			<tbody>
				<c:forEach var="detail" items="${details}" varStatus="loop">

					<c:if test="${loop.first}">
						<tr>
							<td colspan="5" style="padding-top: 10px;"></td>
						</tr>
					</c:if>

					<tr>
						<td style="padding-left: 20px; text-align: left;">
							<div style="display: flex; align-items: center;">
								<a href="/project4/product?cmd=detail&id=${detail.productId }">
									<img src="/project4/images/productImg/${detail.img}" alt="Product Image" style="width: 70px; height: auto; margin-right: 10px;">
								</a>	
								<div>
									<strong>${detail.brand}</strong><br> ${detail.content}
								</div>
							</div>
						</td>
						<td>
							<fmt:formatDate pattern="yyyy-MM-dd" value="${detail.createDate}"></fmt:formatDate>
						</td>
						<td>
							<span>${detail.orderNum}</span>
						</td>
						<td>
							<fmt:formatNumber type="number" pattern="#,##0" value="${detail.totalPrice}" />원 <br> 
							<span style="color: grey">${detail.totalCount}개</span>
						</td>
						<td>
							<span>${detail.state}</span><br>
							<button type="button" class="btn btn-outline-info btn-sm">교환</button>
							<button type="button" class="btn btn-outline-danger btn-sm">환불</button>
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
</div>

<div class="container" style="text-align: left; color:grey; font-size:12px">
		<li>동일한 주문번호라도 2개 이상의 브랜드에서 주문하신 경우 출고지 주소가 달라 각각 출고됩니다. (택배 박스를 2개 이상 수령 가능)</li>
		<li>출고 완료 직후 교환 / 환불 요청을 하더라도 상품을 수령하신 후 택배 업체를 통해 보내주셔야 처리 가능합니다.</li>
		<li>별도의 구매 결정이 없더라도 상품 배송 완료 후 7일이 지난 경우에는 자동 구매확정, 적립금이 자동 지급됩니다.</li>
		<li>자세한 내용은 FAQ를 확인하여 주시기 바랍니다.</li>
</div>

<!-- 하단 / 배송지 정보 -->
<div class="container">
<br><br><br>

<p><strong>배송지 정보</strong></p>
	<hr style="border-color: black;">
	
	<div class="d-flex">
		<div class="info" style="width:150px">닉네임</div>
		<div class="info" >${buyer.nickName }</div>
	</div>
	<hr>
	<div class="d-flex">
		<div class="info" style="width:150px">연락처</div>
		
		<%-- <div class="info" >${buyer.phone }</div> --%>
		<!-- 전화번호를 하이픈(-)으로 나누기 -->
		<div class="info">
			<c:set var="phone" value="${buyer.phone}" />
			<c:set var="part1" value="${fn:substring(phone, 0, 3)}" />
			<c:set var="part2" value="${fn:substring(phone, 3, 7)}" />
			<c:set var="part3" value="${fn:substring(phone, 7, 11)}" />
			${part1}-${part2}-${part3}
		</div>
		
	</div>
	<hr>
	<div class="d-flex">
		<div class="info" style="width:150px">배송지</div>
		<div class="info" >${buyer.address }</div>
	</div>
	<hr>

	<li style="color:grey; font-size:12px">발송전 일때만 배송지 주소를 변경하실 수 있습니다.(미입금/입금확인/출고요청 단계까지만가능)</li>
</div>


<!-- 하단 / 최종 결제 정보 -->
<div class="container">
<br><br><br>

<p><strong>최종 결제 정보</strong></p>
	<hr style="border-color: black;">
	
	<div class="d-flex">
		<div class="info" style="width:150px">상품 합계</div>
		<div class="info" ><fmt:formatNumber type="number" pattern="#,##0" value="${buyer.totalPrice}" />원</div>
	</div>
	<hr>
	<div class="d-flex">
		<div class="info" style="width:150px">배송비 합계</div>
		<div class="info" >원</div>
	</div>
	<hr>
	<div class="d-flex">
		<div class="info" style="width:150px">최종 결제 금액</div>
		<div class="info" >원</div>
	</div>
	<hr>
	
	<li style="color:grey; font-size:12px">카드결제시 현금영수증/세금계산서 발급이 불가능하며 카드전표로 대체하실 수 있습니다.</li>
	<li style="color:grey; font-size:12px">즉시할인가는 즉시할인 및 PG사별 자체 할인이 적용된 실제 결제금액입니다. (ex. 토스페이 즉시할인)</li>
	<li style="color:grey; font-size:12px">바로접속 OFF 상태일 때에는 각종 할인 혜택이 제한될 수 있습니다.</li>
</div>

<style>
thead th {
	border-top: 1px solid;
	border-bottom: 1px solid;
	padding-top: 10px;
	padding-bottom: 10px;
}

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

.info{
	font-size: 13px;
}


</style>
<%@ include file = "../layout/footer.jsp" %>