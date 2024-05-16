<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp"%>

<br>
<br>
<h1 style="text-align: center">
	<div class="d-flex justify-content-center">
		<img src="images/icons/paper.png" alt="Logo" style="width:50px;">&nbsp;
		<div style="color: #353A3F; font-weight: bold">상품 등록</div>
	</div>
</h1>
<br>
<br>


<div class="container" style="text-align: center">
	<form action="/project4/product?cmd=save" method="POST" name="save"  enctype="multipart/form-data">
		<input type="hidden" name="userId" id="userId" value="${sessionScope.principal.id }">
		
		<div class="form-group" >
			<div class="material-icons-input" style="width: 421px">
			    <span class="material-icons">local_grocery_store</span>
			    <input type="text" name="name" id="name" class="form-control" placeholder="상품명을 입력하세요"  required/>
			</div>
		</div>
		
		<div class="form-group">
			<div class="material-icons-input" style="width: 421px">
				<span class="material-icons">local_offer</span>
				<div>
				    <select name="category" id="category" class="custom-select" style="padding-left: 40px;">
				        <option selected disabled>카테고리</option>
				        <option value=0>육류</option>
				        <option value=1>과일</option>
				        <option value=2>야채</option>
				    </select>
				</div>
			</div>
		</div>
		
		<div class="form-group" >
			<div class="material-icons-input" style="width: 421px">
			    <span class="material-icons">monetization_on</span>
			    <input type="text" name="price" id="price" class="form-control" placeholder="상품 금액을 입력하세요 (숫자만 입력)" required/>
			</div>	
		</div>

		<div style="padding-right: 303px">
			<p><input type="checkbox" id="weightCheckbox" onchange="abledOrNot()"> '무게 선택' 입력</p>  <!-- input 창 두개를 개별로 disabled 하지말고 한꺼번에 처리하기 -->
		</div>
 		<div class="form-group insert-input-container" >
 			<div class="material-icons-input">
				<span class="material-icons">fitness_center</span>
				<div>
					<select id="inputWeight" class="custom-select" style="width: 155px; padding-left: 40px;" onchange="weightCombine()"  disabled>
						<option selected disabled>무게 선택</option>
						<option value="g당">g당</option>
						<option value="kg당">kg당</option>
					</select>
				</div>
			</div>
		    <div class="material-icons-input" style="width: 266px">
		        <span class="material-icons">attach_money</span>
		        <input type="text" id="inputPrice" class="form-control"  placeholder="무게당 금액 (숫자만 입력)" onchange="weightCombine()"  disabled>
		    </div>
		</div> 
		
		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input" style="width: 421px">
				<span class="material-icons">add_a_photo</span>
				<input type="file"  class="form-control" name="img"  id="fileInput" accept="image/*" >
			</div>
		</div>

		<div class="form-group" >
			<div class="material-icons-input" style="width: 421px">
			    <span class="material-icons">textsms</span>
			    <input type="text" name="content" id="content" class="form-control" placeholder="제품에 대해 설명해주세요" required/>
			</div>	
		</div>
		
		<br>
		<button type="button" class="btn btn-outline-secondary" onclick="history.back()">이전</button>
		<button type="button" class="btn btn-primary" style="width: 128px" onclick="nullCheck()">상품 등록</button>
	</form>
</div>


<!-- <script src="/project4/js/productInfo.js"></script> -->
<script>
function nullCheck(){

	var userId = document.getElementById("userId").value;
	var name = document.getElementById("name").value;
    var category = document.getElementById("category").value;
    var price = document.getElementById("price").value;
    var content = document.getElementById("content").value;
    var img = document.getElementById("fileInput").value;
	var weight = weight;
	
	if(document.save.name === '' ){
		alert('상품명을 입력하세요');
	}else if(document.save.category === '카테고리'){
		alert('카테고리를 선택하세요');
	}else if(document.save.price === ''){
		alert('상품 금액을 입력하세요');
	}else if (isNaN(price)) {					// }else if (isNaN(price)) {
	    alert('상품 금액은 숫자로만 입력하세요');
	}else if(weightCheckbox.checked){			// '무게 선택' 입력을 선택하면
		weightCombine();
	}else {
		document.save.submit();
	}
}

// ====================================================	
//												weight 조합
//====================================================	
function weightCombine(){
	var inputWeight = document.getElementById("inputWeight").value;
	var inputPrice = document.getElementById("inputPrice").value;
	weight = inputWeight + inputPrice;
	
	if(isNaN(inputPrice)){					// inputPrice가 true면 (문자열이 있으면)
		alert('무게당 금액은 숫자로만 입력하세요');
	}else if(weight !== ''){					// inputWeight와 inputPrice가 공란이면	
		alert('무게를 선택하고 금액을 입력하세요');
	}
	
}

// ====================================================	
// 										'무게 선택' 체크박스
// ====================================================	
// - 체크 시, 입력가능
function abledOrNot(){
	var weightCheckbox = document.getElementById("weightCheckbox");
	var inputWeight = document.getElementById("inputWeight");
	var inputPrice = document.getElementById("inputPrice");
	
	if(weightCheckbox.checked){
		inputPrice.disabled = false;
		inputWeight.disabled = false;
	}else{
		inputPrice.disabled = true;
		inputWeight.disabled = true;
	}
}


</script>


<style>
    .material-icons-input {								/* input 될 아이콘 칸 */
        display: inline-block;
        position: relative;
    }
    .material-icons-input input {						/* 아이콘이 포함된 input 태그 */
	    width: 100%;
	    padding-left: 40px; /* 예시: 좀 더 넓은 여백을 주기 위해 padding-left 값 조정 */
    }
    .material-icons-input .material-icons {		/* 아이콘 위치 */
        position: absolute;
        left: 5px; /* 아이콘을 왼쪽에 위치 */
        top: 50%;
        transform: translateY(-50%);
    }
    
        /* 이메일 입력 칸과 버튼 간의 간격 조절 */
    .insert-input-container {
        display: flex;
        align-items: center; /* 세로 정렬을 위해 */
        justify-content: center; /* 수평 정렬을 위해 */
    }

    .insert-input-container .form-control {
        flex: 1; /* 입력 칸이 버튼의 크기에 따라 유동적으로 변할 수 있도록 */
        margin-right: 5px; /* 버튼과의 간격 조절 */
    }

    .insert-input-container .btn {
        flex-shrink: 0; /* 버튼이 입력 칸의 크기에 영향을 받지 않도록 */
    }
    
</style>