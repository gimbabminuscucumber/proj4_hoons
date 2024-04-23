package com.cos.blog.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cos.blog.domain.board.Board;
import com.cos.blog.domain.board.dto.SaveReqDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.BoardService;
import com.cos.blog.util.Script;


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
			List<Board> boards = boardService.글목록보기(page);
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
		}
	}

}
