package com.cos.blog.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cos.blog.domain.user.User;
import com.cos.blog.domain.user.dto.JoinReqDto;
import com.cos.blog.domain.user.dto.LoginReqDto;
import com.cos.blog.service.UserService;
import com.cos.blog.util.Script;

// http://localhost:8080/project4/user
@WebServlet("/user")	
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UserController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	// http://localhost:8080/project4/user?cmd=쿼리스트링	>> project4의 user폴더 내에 있는 html에서 넘어온 데이터이기 때문에
	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getParameter("cmd");
		UserService userService = new UserService(); 
		
		// http://localhost:8080/project4/user?cmd=loginForm
		if(cmd.equals("loginForm")) {
			// 아이디 기억하게 하는 서비스 작성
			RequestDispatcher dis =
					request.getRequestDispatcher("user/loginForm.jsp");
			dis.forward(request, response);	
			
			//response.sendRedirect("user/loginForm.jsp");	// filter 사용으로 인해 sendRedirect() 사용불가
		}else if(cmd.equals("login")) {
			// 1. http에서 데이터를 받기
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			
			// 2. dto로 오브젝트 만들어 데이터 넣기
			LoginReqDto dto = new LoginReqDto();
			dto.setUsername(username);
			dto.setPassword(password);
			
			// 3. Service에 오브젝트 담기 (Service : 전달받은 데이터 처리 / 가공은 다른 곳에서 처리)
			User userEntity = userService.로그인(dto);
			
			if(userEntity != null) {
				HttpSession session = request.getSession();
				session.setAttribute("principal", userEntity);
				RequestDispatcher dis =
						request.getRequestDispatcher("index.jsp");
				dis.forward(request, response);	
				
				//response.sendRedirect("index.jsp");	// filter 사용으로 인해 sendRedirect() 사용불가
			}else {
				Script.back(response, "아이디/비밀번호가 틀립니다.");		// Script.java의 back() 메소드로 매개변수 전달 / PrintWriter로 "로그인 실패"를 담은 response를 전달
			}
		}else if(cmd.equals("joinForm")) {
			RequestDispatcher dis =
					request.getRequestDispatcher("user/joinForm.jsp");
			dis.forward(request, response);	
			
			//response.sendRedirect("user/joinForm.jsp");		// filter 사용으로 인해 sendRedirect() 사용불가
		}else if(cmd.equals("join")) {
			// 1. http에서 데이터를 받기
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String email = request.getParameter("email");
			String address = request.getParameter("address");
			
			// 2. dto로 오브젝트 만들어 데이터 넣기
			JoinReqDto dto = new JoinReqDto();
			dto.setUsername(username);
			dto.setPassword(password);
			dto.setEmail(email);
			dto.setAddress(address);
			
			// Test
			System.out.println("UserController.회원가입 : " + dto);
			
			// 3. Service에 오브젝트 담기 (Service : 전달받은 데이터 처리 / 가공은 다른 곳에서 처리)
			int result = userService.회원가입(dto);
			if(result == 1) {
				response.sendRedirect("index.jsp");		// filter 사용으로 인해 sendRedirect() 사용불가하지만 index.jsp 접근은 허용했기에 가능
			}else {
				Script.back(response, "회원가입 실패");
			}
			
		}else if(cmd.equals("usernameCheck")) {	// 유저네임 중복 체크
			// joinForm.jsp의 ajax에서 보내는 username 데이터가 text 타입이라서 버퍼로 받아야함 (파라미터로 받을 수 없기 때문에)
			BufferedReader br = request.getReader();
			String username = br.readLine();
			
			System.out.println("UserController.username : "+username);
			
			int result = userService.유저네임중복체크(username);
			PrintWriter out = response.getWriter();
			
			if(result == 1	) {		// result가 1(중복)이면
				out.print("ok");		// println을 하면 칸 띄우기 때문에 일치여부 확인 불가
			}else {							// result가 -1(신규)이면 
				out.print("fail");	
			}
			out.flush();
		}else if(cmd.equals("logout")) {
			HttpSession session = request.getSession();
			session.invalidate();	// session 무효화
			response.sendRedirect("index.jsp");	// filter 사용으로 인해 sendRedirect() 사용불가하지만 index.jsp 접근은 허용했기에 가능
		}
	}
}
