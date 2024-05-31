<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/text.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">리뷰 작성</div>
	</div>
</h1>
<br>
<br>

<div class="container" style="width: 60%">
	<form action="/project4/buy?cmd=review" method="POST" name="review">
		<!-- hidden에 name값을 넣지 않으면, 하단 submit을 했을 때 form으로 해당 데이터를 가져갈 수 없다 -->
		<input type="hidden" id="userId" name="userId" value="${sessionScope.principal.id }">
		<input type="hidden" id="buyId" name="buyId"  value="${reviews.id }">
		<input type="hidden" id="productId" name="productId"  value="${reviews.productId }">
		<input type="hidden" id="score" name="score"  value="0">
		userId = ${sessionScope.principal.id }
		buyId = ${reviews.id }
		productId = ${reviews.productId }
		<div class="form-group" style="display: flex; align-items: center;">
			<img src="/project4/images/productImg/${reviews.img }" alt="Product Image" style="width: 100%; max-width: 100px; height: auto;">
			<div style="padding-left: 20px">
				<strong><a href="#">${reviews.brand }</a></strong><br>
				<a href="#">${reviews.content }</a><br>
				<span style="color: grey"><fmt:formatNumber type="number" pattern="#,##0" value="${reviews.totalPrice}"/>원</span>
				<span style="color: grey">(${reviews.totalCount}개)</span>
			</div>
		</div>
		<hr style="border-color: lightgrey;">
		<br>

<div class="form-group">
    <strong><label>별점</label></strong>
    <div class="rating" >
        <span class="star" onclick="setRating(1)"> ☆ </span>
        <span class="star" onclick="setRating(2)"> ☆ </span>
        <span class="star" onclick="setRating(3)"> ☆ </span>
        <span class="star" onclick="setRating(4)"> ☆ </span>
        <span class="star" onclick="setRating(5)"> ☆ </span>
    </div>
</div>
		<br>
		
		<div class="form-group">
			<strong><label>내용</label></strong>
			<textarea class="form-control" rows="5" name="text" id="text"></textarea>
		</div>

		<div class="d-flex justify-content-end">
			<button type="button" onclick="history.back()" class="btn btn-outline-secondary" >이전</button>&nbsp;
			<button type="button" class="btn btn-primary" onclick="nullCheck()">리뷰 등록</button>
		</div>
	</form>
</div>

<script>

// 별 체크시 별 개수만큼 score에 정수값을 입력
let rating = 0;

function setRating(value) {
    rating = value;
    startCheck(value);
    document.getElementById("score").value = value;	// 별점 체크에 따른 정수를 <input type="hidden" id="score">에 저장
   	console.log('score : ' + document.getElementById("score").value);	
}

// 별 체크 변경
function startCheck(value) {
	const stars = document.querySelectorAll('.star');
    stars.forEach((star, index) => {
        if (index < value) {
            star.innerHTML = "⭐️";
        } else {
            star.innerHTML = "☆";
        }
    });
    
}

// 리뷰 저장
function nullCheck() {
    const text = document.getElementById("text").value.trim();	// 내용 칸에 아무것도 없을 때
    if (rating === 0) { 								// 평점이 선택되지 않은 경우
        alert("별점을 선택해주세요.");
    } else if (text === "") { 							// 리뷰 내용이 입력되지 않은 경우
        alert("리뷰 내용을 입력해주세요.");
    } else {
        //document.review.submit();
        const formData = {		// form 으로 전달 받은 데이터
			buyId: document.getElementById("buyId").value,
			userId: document.getElementById("userId").value,
			productId: document.getElementById("productId").value,
			text: text,
			score: rating 		// score 값을 rating 변수에서 가져옴
        };
        
        $.ajax({
        	type: "post",
        	url: "/project4/buy?cmd=review",
        	data: JSON.stringify(formData),
        	contentType: "application/json; charset=utf-8",
        	dataType: "json"
        }).done(function(data){
        	if(data.statusCode === 1){
        		console.log('리뷰 작성 성공/data.data : ' + data.data);
        		alert("리뷰 작성을 완료했습니다.");
        		location.href="buy?cmd=list&id=" + document.getElementById("userId").value;
        	}else{
        		console.log('리뷰 작성 실패/data.data : ' + data.data);
        		alert("리뷰 작성에 실패했습니다.");
        	}
        }).fail(function(error){
        	console.error('리뷰 작성 에러/', error);
        	alert("리뷰 작성 중 오류가 발생했습니다.");
        });
        
    }
}
</script>
<%@ include file = "../layout/footer.jsp" %>