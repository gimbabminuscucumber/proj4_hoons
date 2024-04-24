package com.cos.blog.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cos.blog.domain.board.dto.DeleteReqDto;
import com.cos.blog.domain.board.dto.DeleteRespDto;
import com.cos.blog.domain.board.dto.DetailRespDto;
import com.cos.blog.domain.board.dto.SaveReqDto;
import com.cos.blog.domain.board.dto.UpdateReqDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.BoardService;
import com.cos.blog.util.Script;
import com.google.gson.Gson;


// URL 주소를 테이블 명으로 하면 편하다
// http://localhost:8080/project4/board
@WebServlet("/board")
public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public BoardController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getParameter("cmd");
		BoardService boardService = new BoardService(); 
		// http://localhost:8080/project4/board?cmd=saveFor m
		HttpSession session = request.getSession();							// 세션 불러오기
		
		if(cmd.equals("saveForm")) {
			User principal = (User)session.getAttribute("principal");	// 세션에 principal이 있는지 확인 (로그인된 세션엔 princpal이 있으니까)
			
			if(principal != null) {
				RequestDispatcher dis =
						request.getRequestDispatcher("board/saveForm.jsp");
				dis.forward(request, response);	
				//response.sendRedirect("board/saveForm.jsp");				// principal이 있으면 글쓰기 페이지로
			}else {
				RequestDispatcher dis =
						request.getRequestDispatcher("user/loginForm.jsp");
				dis.forward(request, response);	
				//response.sendRedirect("user/loginForm.jsp");				// 없으면 로그인 페이지로
			}
		}else if(cmd.equals("save")) {
			int userId = Integer.parseInt(request.getParameter("userId"));		// saveForm 에서 hidden으로 받아온 userId
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			
//			System.out.println("BoardController/userId : " + userId);
//			System.out.println("BoardController/title : " + title);
//			System.out.println("BoardController/content: " + content);
			
			SaveReqDto dto = new SaveReqDto();
			dto.setUserId(userId);
			dto.setTitle(title);
			dto.setContent(content);
			int result = boardService.글쓰기(dto);
			
			if(result == 1) {	// 정상 입력 완료
				response.sendRedirect("index.jsp");
			}else {					// 정상 입력 실패
				Script.back(response, "글쓰기 실패");
			}
			
		}else if(cmd.equals("list")) {
			int page = Integer.parseInt(request.getParameter("page"));		// 최초 페이지는 0, NEXT 클릭시 1
			List<DetailRespDto> boards = boardService.글목록보기(page);
			request.setAttribute("boards", boards);
			
			// 페이지 계산
			int boardCount = boardService.글개수();
			int lastPage = (boardCount -1)/4;
			request.setAttribute("lastPage", lastPage);
			
			// 페이지 진척도
			double currentPercent = (double)page/(lastPage)*100;
			request.setAttribute("currentPercent", currentPercent);
			
			RequestDispatcher dis = request.getRequestDispatcher("board/list.jsp");
			dis.forward(request, response);	
		}else if(cmd.equals("detail")) {			// 게시글 상세보기
			int id = Integer.parseInt(request.getParameter("id"));
			DetailRespDto dto = boardService.글상세보기(id);		// board 테이블 + user 테이블 = 조인된 데이터 필요
			
			if(dto == null) {
				Script.back(response, "게시글을 불러올 수 없습니다.");
			}else {
				request.setAttribute("dto", dto);
				RequestDispatcher dis = request.getRequestDispatcher("board/detail.jsp");
				dis.forward(request, response);	
			}
		}else if(cmd.equals("delete")) {
			
			// 1. 요청받은 JSON 데이터를 자바 오브젝트로 파싱
			BufferedReader br = request.getReader();
			String data = br.readLine();
			
			Gson gson = new Gson();
			DeleteReqDto dto = gson.fromJson(data, DeleteReqDto.class);
			
			System.out.println("data : " + data);
			System.out.println("dto : " + dto);

			// 2. DB에서 id 값으로 글 삭제
			int result = boardService.글삭제(dto.getBoardId());
			
			// 3. 응답할 JSON 데이터 생성
			DeleteRespDto respDto = new DeleteRespDto()	;
			if(result == 1) {
				respDto.setStatus("ok");
			}else {
				respDto.setStatus("fail");
			}
			
			String respData = gson.toJson(respDto);
			System.out.println("respData : " + respData);
			
			// 4. 응답
			PrintWriter out = response.getWriter();
			out.print(respData);
			out.flush();
		}else if(cmd.equals("updateForm")) {
			// 수정할 데이터를 가져가야 함
			int id = Integer.parseInt(request.getParameter("id"));		// 수정할 게시글의 id 가져오기
			DetailRespDto dto = boardService.글상세보기(id);					// 수정한 메소드 내용을 dto에 담기
			request.setAttribute("dto", dto);											// dto 뿌리기
			RequestDispatcher dis = request.getRequestDispatcher("board/updateForm.jsp");
			dis.forward(request, response);	
		}else if(cmd.equals("update")) {
			// updateForm에서 데이터를 받아온 name 값들 (id, title, content)
			int id = Integer.parseInt(request.getParameter("id"));
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			
			UpdateReqDto dto = new UpdateReqDto();
			dto.setId(id);
			dto.setTitle(title);
			dto.setContent(content);
			
			int result = boardService.글수정(dto);
			
			if(result == 1) {
				// ReqestDispatch 안 쓰는 이유에 대해 고민해보기 (이해 안되면 ReqestDispatch로 detail.jsp 호출해보기)
				response.sendRedirect("/project4/board?cmd=detail&id="+id);		// 수정된 내용으로 저장이 완성되면, 게시글 상세보기 페이지가 열려야해서 재호출
			}else {
				Script.back(response, "글 수정에 실패했습니다.");
			}
			
		}
	}

}
