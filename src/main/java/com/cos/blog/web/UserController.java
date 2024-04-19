package com.cos.blog.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
			response.sendRedirect("user/loginForm.jsp");
		}else if(cmd.equals("login")) {
			// 1. http에서 데이터를 받기
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			
			// 2. dto로 오브젝트 만들어 데이터 넣기
			LoginReqDto dto = new LoginReqDto();
			dto.setUsername(username);
			dto.setPassword(password);
			
			// 3. Service에 오브젝트 담기 (Service : 전달받은 데이터 처리 / 가공은 다른 곳에서 처리)
			userService.로그인(dto);
		}else if(cmd.equals("joinForm")) {
			response.sendRedirect("user/joinForm.jsp");
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
			System.out.println("회원가입 : " + dto);
			
			// 3. Service에 오브젝트 담기 (Service : 전달받은 데이터 처리 / 가공은 다른 곳에서 처리)
			int result = userService.회원가입(dto);
			if(result == 1) {
				response.sendRedirect("index.jsp");
			}else {
				Script.back(response, "회원가입 실패");
			}
		}
	}
}
