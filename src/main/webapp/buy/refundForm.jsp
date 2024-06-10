<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/error.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">환불 신청</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="width: 60%">
	<form action="/project4/buy?cmd=refund" method="POST" name="refund">
		<!-- hidden에 name값을 넣지 않으면, 하단 submit을 했을 때 form으로 해당 데이터를 가져갈 수 없다 -->
		<input type="hidden" id="buyId" name="buyId"  value="${refund.id }">
		<input type="hidden" id="userId" name="userId"  value="${sessionScope.principal.id }">
	
		<h4>환불 상품</h4><br>
		<div class="container">
			<div class="form-group" style="display: flex; align-items: center;">
				<img src="/project4/images/productImg/${refund.img }" alt="Product Image" style="width: 100%; max-width: 100px; height: auto;">
				<div style="padding-left: 20px">
					<strong><a href="#">${refund.brand }</a></strong><br>
					<a href="#">${refund.content }</a><br>
					<span style="color: grey"><fmt:formatNumber type="number" pattern="#,##0" value="${refund.totalPrice}"/>원</span>
					<span style="color: grey">(${refund.totalCount}개)</span>
				</div>
			</div>
			<hr style="border-color: lightgrey;">
		</div>
		<br>

		<div class="form-group">
			<h4>환불 사유</h4><br>
			<div class="container">
			    <label>구매자 책임 사유</label>
			    <div class="user" >
					<select name="user" id="user" class="custom-select" onchange="rsnCheck()">
						<option selected value=0 disabled>환불 사유를 선택하세요</option>
						<option value=1>단순 변심</option>
						<option value=2>기타</option>
					</select>
				</div>
				<br>
			    <label>판매자 책임 사유</label>
			    <div class="manager" >
					<select name="manager" id="manager" class="custom-select"  onchange="rsnCheck()">
						<option selected value=0 disabled>환불 사유를 선택하세요</option>
						<option value=1>상품 불량</option>
						<option value=2>유통기한이 지남</option>
						<option value=3>주문과 다른 상품이 배송됨</option>
						<option value=4>기타</option>
					</select>
				</div>
				<br>
				<div class="form-group" id="text" style="display:none">
					<label>상세 내용</label>
					<textarea class="form-control" rows="5" name="detail" id="detail"  placeholder="상세 내용을 입력하세요"></textarea>
				</div>
				<div class="d-flex justify-content-end">
					<button type="button" onclick="history.back()" class="btn btn-outline-secondary" >이전</button>&nbsp;
					<button type="button" class="btn btn-primary" onclick="nullCheck()">환불 신청</button>
				</div>
			</div>
		</div>
	</form>
</div>

<script>

function rsnCheck() {
   	const user = document.getElementById("user");
    const manager = document.getElementById("manager");
    const text = document.getElementById("text");

    if (user.value !== "환불 사유를 선택하세요") {
    	manager.disabled = true;
        text.style.display = "block";
    } else {
    	manager.disabled = false;
    }

    if (manager.value !== "환불 사유를 선택하세요") {
    	user.disabled = true;
        text.style.display = "block";
    } else {
    	user.disabled = false;
    }
}


// 환불 신청
function nullCheck() {

	const userReason = document.getElementById("user").value;
    const managerReason = document.getElementById("manager").value;
    const text = document.getElementById("detail").value.trim();
 
    console.log('userReason : ' + userReason);
    console.log('managerReason : ' + managerReason);
    console.log('text : ' + text);

    if (userReason != 0 && managerReason != 0) { 	
        alert("환불 사유를 선택해주세요");
    } else if (text === "") { 							// 리뷰 내용이 입력되지 않은 경우
        alert("상세 내용을 입력해주세요.");
    } else {
        //document.refund.submit();
        const data = {			// form 으로 전달 받은 데이터
			buyId: document.getElementById("buyId").value,
			userReason: userReason,
			managerReason: managerReason,
			text: text
        };
        
        console.log('data.buyId : ' + data.buyId);
        console.log('data.userReason : ' + data.userReason);
        console.log('data.managerReason : ' + data.managerReason);
        console.log('userId : ' + document.getElementById("userId").value);
        
        $.ajax({
        	type: "post",
        	url: "/project4/buy?cmd=refund",
        	data: JSON.stringify(data),
        	contentType: "application/json; charset=utf-8",
        	dataType: "json"
        }).done(function(data){
        	if(data.statusCode === 1){
        		console.log('환불 신청 성공/data.data : ' + data.data);
        		alert("환불 신청을 완료했습니다.");
        		location.href="buy?cmd=list&page=0&userId=" + document.getElementById("userId").value;
        	}else{
        		console.log('환불 신청 실패/data.data : ' + data.data);
        		alert("환불 신청에 실패했습니다.");
        	}
        }).fail(function(error){
        	console.error('환불 신청 에러/', error);
        	alert("환불 신청 중 오류가 발생했습니다.");
        });
    }
      
}
</script>
<%@ include file = "../layout/footer.jsp" %>