<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
 <!-- marterial css 
 https://materializecss.com/icons.html-->
 <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>

<br>
<div class="container" style="text-align:center">
		<h5><strong>변경할 옵션을 선택하세요</strong></h5>
		<br>
		<div class="form-group" style="margin-left:25px">
                <div class="form-group d-flex" >
                    <button type="button" class="btn btn-light" onclick="minus()" >-</button>
                    <input type="text" class="btn btn" id="totalCount" value="1" min="1" style="width:50px">
                    <button type="button" class="btn btn-light" onclick="plus()">+</button>
                </div>
		</div>
		<br>
	
		<button type="button" class="btn btn-danger" style="width: 40%" onclick="window.close()">닫기</button>
		<button type="button" class="btn btn-primary" style="width: 40%" onclick="update()">변경</button>
</div>	
<script>

	// URL 파라미터 읽기
	function getParameterByName(name) {
	    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
	        results = regex.exec(location.search);
	    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}
	
	document.addEventListener("DOMContentLoaded", function() {
	    var totalCount = getParameterByName('totalCount');
	    document.getElementById("totalCount").value = totalCount;
	});

	// 수량 +
    function plus(){
        var digit = document.getElementById("totalCount");
        var digitUp = parseInt(digit.value);
        digit.value = digitUp + 1;
        updateTotalPrice();
    }

	// 수량 -
    function minus(){
        var digit = document.getElementById("totalCount");
        var digitDown = parseInt(digit.value);
        if(digitDown > 1) { // 최소값은 1로 제한
            digit.value = digitDown - 1;
        }
        updateTotalPrice();
    }
	
 	// 수량 변경
	function update(){
	    var basketId = getParameterByName('basketId');
	    var totalCount = document.getElementById("totalCount").value;
		console.log('basketId : ' + basketId);
		console.log('totalCount : ' + totalCount);
		
	    // AJAX 요청으로 변경된 데이터 전송
		$.ajax({
		    type: "post",
		    url: "/project4/buy?cmd=basketUpdate",
		    data: { basketId: basketId, totalCount: totalCount },
		    success: function(response) {
		        if (response.statusCode == 1) {
		            window.opener.location.reload(); // 부모 창 새로고침
		            window.opener.alert("수량이 변경되었습니다."); // 부모 창에서 alert
		            window.close(); // 팝업 창 닫기
		        } else {
		            window.opener.alert("수량 변경에 실패했습니다."); // 부모 창에서 alert
		            window.close(); // 팝업 창 닫기
		        }
		    },
		    error: function(error) {
		        window.opener.alert("에러 발생: " + error); // 부모 창에서 alert
		        window.close(); // 팝업 창 닫기
		    }
		});
		
	}
</script>	
	
</body>
</html>