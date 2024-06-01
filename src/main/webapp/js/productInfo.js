
//이미지 파일 업로드를 위한 함수
function uploadImage() {
    // 파일 입력 필드에서 이미지 파일 가져오기
    var fileInput = document.getElementById('fileInput');
    var file = fileInput.files[0];
    
    // FormData 객체 생성
    var formData = new FormData();
    formData.append('imageFile', file);
    
    // 서버로 이미지 업로드 요청
    fetch('/upload', {
        method: 'POST',
        body: formData
    }).then(response => response.json())
   	.then(data => {
       console.log('Image uploaded successfully:', data);
       // 서버로부터 응답을 받으면 처리할 코드 추가
   	})
   	.catch(error => {
       	console.error('Error uploading image:', error);
   	});
}

// 상품 삭제
function deleteById(id){
	
	$.ajax({
		type: "post",
		url: "/project4/product?cmd=delete&id="+id,
		dataType: "json"		
	}).done(function(result){
		if(result.statusCode == 1){
			console.log(result);
			location.reload();
			alert("상품을 삭제하였습니다.");
			$("#product-" + id).remove();
		}else{
			alert("상품 삭제에 실패하였습니다.");
		}
	});
}