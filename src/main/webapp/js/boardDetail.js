/*
function addReply(data){
	
	var replyItem = `<li id="reply-${data.id}" class="media">`;
	replyItem += `<img onerror="#" src="/project4/images/user.png" style="height: 45px " alt="" class="img-circle"></img>`;
	replyItem += `<div class="media-body">`;
	replyItem += `<strong class="text-primary">${data.userId}</strong>`;
	replyItem += `<p>${data.content}</p>작성시간(크기 작게 / 회색) <fmt: formatDate pattern="yyyy-MM-dd" value=""></fmt: formatDate></div>`;
	replyItem += `<div class="m-2">`;
	replyItem += `<i onclick="deleteReply(${data.id})" class="material-icons">delete</i></div></li><br>`;
	
	$("#reply__list").prepend(replyItem);
}
*/

// 댓글 삭제
function deleteReply(id){

	$.ajax({
		type: "post",
		url: "/project4/reply?cmd=delete&id=" + id,
		dataType: "json"
	}).done(function(result) {		// ReplyController의 jsonData에 {"statusCode": 1}가 result에 담김 
		if (result.statusCode == 1) {
			console.log(result);
			alert("댓글을 삭제하였습니다.");
			// 방법 1. 화면 새로고침
			//location.reload();
			// 방법 2. ajax
			$("#reply-"+id).remove();
		} else {
			alert("댓글 삭제에 실패하였습니다.");
		}
	});
}

// 댓글 작성
function replySave(userId, boardId) {
	//console.log(1, $("#content").text());		// 결과값 : ""
	//console.log(2, $("#content").val());			// 결과값 : "asdf"

	var data = {
		userId: userId,
		boardId: boardId,
		content: $("#content").val()
	}

	console.log("data : " + data);
	console.log("JSON.stringify() : " + JSON.stringify(data));

	$.ajax({
		type: "post",
		url: "/project4/reply?cmd=save",			// 여기로 object 를 가져가겠다
		data: JSON.stringify(data),
		contentType: "application/json; charset=utf-8",
		dataType: "json"
	}).done(function(result) {
		if (result.statusCode == 1) {
			console.log("result : " + result);
			$("#content").val("");		// 댓글 작성 후, input란 content 비우기
			// 방법 1.
			//addReply(result.data);
			// 방법 2.
			location.reload();
		} else {
			alert("댓글 쓰기 실패");
		}
	});
}

// 게시글 삭제
function deleteById(boardId) {

	$.ajax({
		type: "post",
		url: "/project4/board?cmd=delete&id=" + boardId,
		dataType: "json"
	}).done(function(result) {	
		if (result.statusCode == 1) {
			location.href = "index.jsp";
			alert("게시글을 삭제하였습니다.");
		} else {
			alert("삭제에 실패하였습니다.");
		}
	});
	
}