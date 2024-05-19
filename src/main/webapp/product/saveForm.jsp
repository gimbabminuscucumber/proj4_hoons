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
			    <input type="text" name="brand" id="brand" class="form-control" placeholder="브랜드를 입력하세요"  required/>
			</div>
		</div>
		
		<div class="form-group" >
			<div class="material-icons-input" style="width: 421px">
			    <span class="material-icons">textsms</span>
			    <input type="text" name="content" id="content" class="form-control" placeholder="제품에 대해 설명해주세요" required/>
			</div>	
		</div>

		<div class="form-group">
			<div class="material-icons-input" style="width: 421px">
				<span class="material-icons">local_offer</span>
				<div>
				    <select name="category" id="category" class="custom-select" style="padding-left: 40px;">
				        <option selected disabled>카테고리</option>
				        <option value=0>정육</option>
				        <option value=1>과일</option>
				        <option value=2>채소</option>
				        <option value=3>과자/간식</option>
				        <option value=4>밀키트</option>
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

		<div class="form-group d-flex insert-input-container">
			<div class="material-icons-input" style="width: 421px">
				<span class="material-icons">add_a_photo</span>
				<input type="file"  class="form-control" name="img"  id="fileInput" accept="image/*" >
			</div>
		</div>

		
		<div style="padding-right: 303px">
			<p><input type="checkbox" id="weightCheckbox" onchange="abledOrNot()"> '무게 선택' 입력</p>  <!-- input 창 두개를 개별로 disabled 하지말고 한꺼번에 처리하기 -->
		</div>
 		<div class="form-group insert-input-container" >
 			<div class="material-icons-input">
				<span class="material-icons">fitness_center</span>
				<div>
					<select id="inputWeight" class="custom-select" style="width: 155px; padding-left: 40px;" onchange="nullCheck()"  disabled>
						<option selected disabled>무게 선택</option>
						<option value="g당">g당</option>
						<option value="kg당">kg당</option>
					</select>
				</div>
			</div>
		    <div class="material-icons-input" style="width: 266px">
		        <span class="material-icons">attach_money</span>
		        <input type="text" id="inputPrice" class="form-control"  placeholder="무게당 금액 (숫자만 입력)" onchange="nullCheck()"  disabled>
		    </div>
		</div> 
		
		<br>
		<button type="button" class="btn btn-outline-secondary" onclick="history.back()">이전</button>
		<button type="button" class="btn btn-info" >미리보기</button>
		<button type="button" class="btn btn-primary" style="width: 128px" onclick="nullCheck()">상품 등록</button>
	</form>
</div>


<!-- <script src="/project4/js/productInfo.js"></script> -->
<script>

	// ====================================================	
	// 											submit 조건
	// ====================================================	
	function nullCheck(){
	
		var userId = document.getElementById("userId").value;
		var brand = document.getElementById("brand").value;
	    var category = document.getElementById("category").value;
	    var price = document.getElementById("price").value;
	    var img = document.getElementById("fileInput").value;
	    var content = document.getElementById("content").value;
	    //var weight = document.getElementById("inputWeight").value + document.getElementById("inputPrice").value;
	    
	    
	    // submit 조건
		if(brand === '' ){									// 브랜드명이 공란이면
			alert('브랜드명을 입력하세요');
		}else if(content === ''){
			alert('제품 설명을 작성하세요');	
		}else if(category === '카테고리'){			// 카테고리가 선택이 안되면('카테고리')
			alert('카테고리를 선택하세요');
		}else if(price === ''){								// 상품 가격이 공란이면
			alert('상품 금액을 입력하세요');
		}else if (isNaN(price)) {						// 상품 가격이 문자열이면
		    alert('상품 금액은 숫자로만 입력하세요');
		}else if(img === ''){								// img가 공란이면
			alert('상품 이미지를 등록하세요');
		}else{
			document.save.submit();
		}
	}
	
	// ** '무게 선택' 체크박스 선택 시, 데이터 전달

	// ====================================================	
	// 											'무게 선택' 조건사항
	// ====================================================	
	function weightCombine(){
		var inputWeight = document.getElementById("inputWeight").value;
		var inputPrice = document.getElementById("inputPrice").value;
		weight = "";
		
		// '무게 선택' 체크박스 체크 시 
		if(inputWeight === '무게 선택' && inputPrice === ''){		// 둘다 입력 안하면
			alert('\'무게 선택\'과 \'무게당 금액\'을 입력하세요');
		}else if(inputWeight !== '무게 선택' && inputPrice === ''){		// 무게 선택만 하면
			alert('무게당 금액을 입력하세요');
		}else if(inputWeight === '무게 선택' && inputPrice === ''){		// 무게당 금액이 공란이면
			alert('무게당 금액을 입력하세요');
			console.log('2222222222');
		}else if(inputWeight === '무게 선택' && inputPrice !== ''){		// 무게당 금액만 입력하면
			alert('무게를 선택하세요');
		}else if(isNaN(inputPrice)){			// 무게당 금액이 문자열이면
			alert('무게당 금액은 숫자로만 입력하세요');
		}else {
			weightPass = true;
		}
		weight = inputWeight + inputPrice;
	}
		
		
	// ====================================================	
	// 								'무게 선택' 체크박스 입력란 활성화
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