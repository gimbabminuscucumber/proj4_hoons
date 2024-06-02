package com.cos.blog.web;

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

import com.cos.blog.domain.board.dto.DetailRespDto;
import com.cos.blog.domain.board.dto.ListRespDto;
import com.cos.blog.domain.board.dto.SaveReqDto;
import com.cos.blog.domain.board.dto.UpdateReqDto;
import com.cos.blog.domain.common.dto.CommonRespDto;
import com.cos.blog.domain.reply.dto.ReplyRespDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.BoardService;
import com.cos.blog.service.ReplyService;
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
		ReplyService replyService = new ReplyService();
		HttpSession session = request.getSession();							// 세션 불러오기
		
		// ====================================================	
		// 												게시글 저장 1
		// ====================================================	
		// http://localhost:8080/project4/board?cmd=saveForm
		if(cmd.equals("saveForm")) {
			User principal = (User)session.getAttribute("principal");	// 세션에 principal이 있는지 확인 (로그인된 세션엔 princpal이 있으니까)
			System.out.println("BoardController/saveForm/principal : " + principal);
			if(principal != null) {
				RequestDispatcher dis = request.getRequestDispatcher("board/saveForm.jsp");
				dis.forward(request, response);	
				//response.sendRedirect("board/saveForm.jsp");				// principal이 있으면 글쓰기 페이지로
			}else {
				RequestDispatcher dis = request.getRequestDispatcher("user/loginForm.jsp");
				dis.forward(request, response);	
				//response.sendRedirect("user/loginForm.jsp");				// 없으면 로그인 페이지로
			}
			
		// ====================================================	
		// 												게시글 저장 2
		// ====================================================	
		}else if(cmd.equals("save")) {
			int userId = Integer.parseInt(request.getParameter("userId"));		// saveForm 에서 hidden으로 받아온 userId
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			int category = Integer.parseInt(request.getParameter("category"));	// categoryId 추가
			
			SaveReqDto dto = new SaveReqDto();
			dto.setUserId(userId);
			dto.setTitle(title);
			dto.setContent(content);
			dto.setCategory(category);			// categoryId 추가
			
			int result = boardService.글쓰기(dto);
			
			if(result == 1) {	// 정상 입력 완료
				//response.sendRedirect("index.jsp");
				RequestDispatcher dis = request.getRequestDispatcher("board?cmd=list&page=0");
				dis.forward(request, response);	
			}else {					// 정상 입력 실패
				Script.back(response, "글쓰기 실패");
			}
			
		// ====================================================	
		// 												메인 화면
		// ====================================================	
		}else if(cmd.equals("list")) {
			int page = Integer.parseInt(request.getParameter("page"));		// 최초 페이지는 0, NEXT 클릭시 1
			List<DetailRespDto> boards = boardService.글목록보기(page);
			request.setAttribute("boards", boards);

			// 페이지 계산
			int boardCount = boardService.글개수();
			int lastPage = (boardCount -1)/5;
			request.setAttribute("lastPage", lastPage);
			
			// 페이지 진척도
			double currentPercent = (double)page/(lastPage)*100;		// 진척도별 바 게이지
			request.setAttribute("currentPercent", currentPercent);	
			
			// RequestDispatcher는 특정 자원(예: JSP 페이지, 서블릿 등)으로 요청을 전달하거나 포함할 수 있는 객체
			// - 반환된 RequestDispatcher 객체를 dis라는 변수에 할당
			RequestDispatcher dis = request.getRequestDispatcher("board/list.jsp");
			// RequestDispatcher 객체의 forward 메서드를 호출
			// - 현재 요청과 응답 객체를 지정된 자원("board/list.jsp")으로 전달
			dis.forward(request, response);	
			
		// ====================================================	
		// 											게시글 상세보기
		// ====================================================		
		}else if(cmd.equals("detail")) {			// 게시글 상세보기
			int id = Integer.parseInt(request.getParameter("id"));	// 게시글 id 가져오기
			DetailRespDto boards = boardService.글상세보기(id);			// board 테이블 + user 테이블 = 조인된 데이터 필요

			List<ReplyRespDto> replys = replyService.댓글목록(id);		// 댓글 목록 + 유저의 username
			int replyCount = replyService.댓글수(id);
			
			if(boards == null) {
				Script.back(response, "게시글을 불러올 수 없습니다.");
			}else {
				request.setAttribute("boards", boards);
				request.setAttribute("replys", replys);
				request.setAttribute("replyCount", replyCount);
				RequestDispatcher dis = request.getRequestDispatcher("board/detail.jsp");
				dis.forward(request, response);	
			}
			
		// ====================================================	
		// 											게시글 삭제
		// ====================================================		
		}else if(cmd.equals("delete")) {
			
			// 1. 요청받은 JSON 데이터를 자바 오브젝트로 파싱
			// - board 테이블 id
			int id =Integer.parseInt(request.getParameter("id"));
			System.out.println("BoardController/delete/id : " + id);
			System.out.println("BoardController/delete/000");
 			// 2. DB에서 id 값으로 글 삭제
			int result = boardService.글삭제(id);
			// 3. 응답할 JSON 데이터 생성
			CommonRespDto<String> commonRespDto = new CommonRespDto<>()	;
			commonRespDto.setStatusCode(result);
			commonRespDto.setData("성공");
			
			Gson gson = new Gson();
			String respData = gson.toJson(commonRespDto);
			System.out.println("respData : " + respData);
			
			// 4. 응답
			PrintWriter out = response.getWriter();
			out.print(respData);
			out.flush();
			
		// ====================================================	
		// 											게시글 수정 1
		// ====================================================		
		}else if(cmd.equals("updateForm")) {
			// 수정할 데이터를 가져가야 함
			int id = Integer.parseInt(request.getParameter("id"));		// board 테이블의 id
			DetailRespDto dto = boardService.글상세보기(id);					// 수정한 메소드 내용을 dto에 담기
			
			request.setAttribute("dto", dto);											// dto 뿌리기
			RequestDispatcher dis = request.getRequestDispatcher("board/updateForm.jsp");
			dis.forward(request, response);	
			
		// ====================================================	
		// 											게시글 수정 2
		// ====================================================		
		}else if(cmd.equals("update")) {
			int id = Integer.parseInt(request.getParameter("id"));
			int userId = Integer.parseInt(request.getParameter("userId"));
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			int category = Integer.parseInt(request.getParameter("category"));

			UpdateReqDto dto = new UpdateReqDto();
			dto.setId(id);
			dto.setUserId(userId);
			dto.setTitle(title);
			dto.setContent(content);
			dto.setCategory(category);
			
			int result = boardService.글수정(dto);
			if(result == 1) {
				// ReqestDispatch 안 쓰는 이유에 대해 고민해보기 (이해 안되면 ReqestDispatch로 detail.jsp 호출해보기)
				// - ReqestDispatch를 쓰면 id 값을 못 가져가기 때문에?!
				response.sendRedirect("/project4/board?cmd=detail&id="+id);		// 수정된 내용으로 저장이 완성되면, 게시글 상세보기 페이지가 열려야해서 재호출
			}else {
				Script.back(response, "글 수정에 실패했습니다.");
			}
			
		// ====================================================	
		// 									메인 페이지 검색 기능
		// ====================================================		
		}else if(cmd.equals("search")) {		// 검색 기능
			// 파라미터로 가져온 3개 (cmd, keyword, page) 중 2개
			String keyword = request.getParameter("keyword");	
			int page = Integer.parseInt(request.getParameter("page"));
			
//			DetailRespDto boards = boardService.글검색(keyword, page); 		// List 안쓰면 어떻게 되나???
			List<DetailRespDto> boards = boardService.글검색(keyword, page); 
			//List<Board> boards = boardService.글검색(keyword, page);
			request.setAttribute("boards", boards);
			
			// 페이지 계산
			int boardCount = boardService.글개수(keyword);
			int lastPage = (boardCount -1)/5;
			request.setAttribute("lastPage", lastPage);
			
			// 페이지 진척도
			double currentPercent = (double)page/(lastPage)*100;
			request.setAttribute("currentPercent", currentPercent);
			
			RequestDispatcher dis = request.getRequestDispatcher("board/list.jsp");
			dis.forward(request, response);	
			
			
		// ====================================================	
		// 								메인 페이지 카테고리 선택 기능
		// ====================================================		
		}else if(cmd.equals("ctgr")) {
			int page = Integer.parseInt(request.getParameter("page"));
            int category = Integer.parseInt(request.getParameter("category"));

            List<DetailRespDto> boards = boardService.카테고리별게시글(page, category);
            request.setAttribute("boards", boards);

        	// 페이지 계산
			int boardCount = boardService.글개수(category);
			int lastPage = (boardCount -1)/5;
			request.setAttribute("lastPage", lastPage);
			
			// 페이지 진척도
			double currentPercent = (double)page/(lastPage)*100;
			request.setAttribute("currentPercent", currentPercent);
			
			RequestDispatcher dis = request.getRequestDispatcher("board/list.jsp");
			dis.forward(request, response);	
		}
			
	}

}
