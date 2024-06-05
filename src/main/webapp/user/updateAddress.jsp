<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
 <!-- marterial css -->
 <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>

<br>
<div class="container">
    <div class="form-group">
        <label for="address">배송지 주소:</label> 
        <input type="text" id="address" class="form-control" placeholder="Enter Address" required />
    </div>
    <li style="text-align: left; color:grey; font-size:12px">배송지 주소를 수정할 경우, 회원정보에 저장된 주소도 함께 수정됩니다.</li>
    <br>
    <br>
    <div>
        <button type="button" class="btn btn-danger" onclick="window.close()">닫기</button>
        <button type="button" class="btn btn-primary" onclick="updateAddress()">수정하기</button>
    </div>
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
        var address = getParameterByName('address');
        document.getElementById("address").value = address;
    });
    
    // 회원정보 수정
    function updateAddress() {
        var userId = getParameterByName('userId');
        var address = document.getElementById("address").value;

        // URL 생성
        //var url = "/project4/user?cmd=updateForm&id=" + userId;

        // 페이지 이동
        window.location.href = "/project4/user?cmd=updateForm&id=" + userId;
    }
    
    
</script>
</body>
</html>
