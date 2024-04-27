
// 주소 API 실행 함수
function goPopup(){
	var pop = window.open("/project4/user/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}

function jusoCallBack(roadFullAddr){
	var addressElement = document.querySelector("#address");	
	addressElement.value = roadFullAddr;
}
