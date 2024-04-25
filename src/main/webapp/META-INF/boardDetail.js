alert('boardDetail.js 테스트');

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
		url: "/project4/reply?cmd=save",
		data: JSON.stringify(data),
		contentType: "application/json; charset=utf-8",
		dataType: "json"
	}).done(function(result) {
		if (result.statusCode == 1) {
			$("#reply__list").prepend("<div>" + data.content + "</div>")
		} else {
			alert("댓글 쓰기 실패");
		}
	});
}

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