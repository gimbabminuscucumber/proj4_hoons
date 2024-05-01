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

import com.cos.blog.domain.common.dto.CommonRespDto;
import com.cos.blog.domain.reply.Reply;
import com.cos.blog.domain.user.User;
import com.cos.blog.domain.user.dto.JoinReqDto;
import com.cos.blog.domain.user.dto.LoginReqDto;
import com.cos.blog.domain.user.dto.PasswordReqDto;
import com.cos.blog.domain.user.dto.UpdateReqDto;
import com.cos.blog.service.UserService;
import com.cos.blog.util.Script;
import com.google.gson.Gson;

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
			RequestDispatcher dis = request.getRequestDispatcher("user/loginForm.jsp");
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
				RequestDispatcher dis = request.getRequestDispatcher("index.jsp");
				dis.forward(request, response);	
				
				//response.sendRedirect("index.jsp");	// filter 사용으로 인해 sendRedirect() 사용불가
			}else {
				Script.back(response, "아이디/비밀번호가 틀립니다.");		// Script.java의 back() 메소드로 매개변수 전달 / PrintWriter로 "로그인 실패"를 담은 response를 전달
			}
		}else if(cmd.equals("joinForm")) {
			RequestDispatcher dis = request.getRequestDispatcher("user/joinForm.jsp");
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
		}else if(cmd.equals("updateForm")) {
			// 1. 유저 확인
			int id = Integer.parseInt(request.getParameter("id"));
			User user = userService.회원찾기(id);		// 해당 id의 유저가 있으면 데이터 뿌리기
			
			// 2. 현재 데이터 뿌리기
			request.setAttribute("user", user);
			
			// 3. 데이터 뿌릴 위치
			RequestDispatcher dis = request.getRequestDispatcher("user/updateForm.jsp");
			dis.forward(request, response);	
		}else if(cmd.equals("update")) {		// 회원정보 수정
			
			// 1. 수정할 유저 정보 가져오기
			int id = Integer.parseInt(request.getParameter("id"));		// 왜 파라미터의 변수 값을 쌍따옴표로 감싸지?
			String password = request.getParameter("password");
			String email = request.getParameter("email");
			String address = request.getParameter("address");
			
			// 2. 유저 객체에 수정된 데이터 넣기
			User user = new User();
			user.setId(id);
			user.setPassword(password);
			user.setEmail(email);
			user.setAddress(address);
			
			// 3. 수정된 유저 객체를 넣은 서비스 호출
			int result = userService.회원수정(user);		// Service에서 결과 받기 (1이면 성공, -1이면 실패)
			
			// 4. 결과에 따른 페이지 이동
			if(result == 1) {
				response.sendRedirect("index.jsp");	
//				response.sendRedirect("/project4/user?cmd=list&id=" + id);	// id 값을 들고가야 해서 response.sendRedirect() 사용
			}else {
				Script.responseData(response, "회원정보 수정에 실패했습니다.");
			}
			
		}else if(cmd.equals("emailCheck")) {		// 유저네임 찾기
			// ajax에서 보내는 username 데이터가 text 타입이라서 버퍼로 받아야함 (파라미터로 받을 수 없기 때문에)
			String email = request.getParameter("email");
			User user = userService.회원이메일(email);
			
			System.out.println("UserController/user : " + user);

			CommonRespDto<User> commonRespDto = new CommonRespDto<>();
				
			int result = userService.유저네임찾기(email);
			if(result != -1) {			// 유저가 없지(-1) 않으면(!=)
				commonRespDto.setStatusCode(1);
				commonRespDto.setData(user);
			}else {		
				commonRespDto.setStatusCode(-1);
			}
			System.out.println("UserController/commonRespDto : " + commonRespDto);
			
			Gson gson = new Gson();
			String responseData = gson.toJson(commonRespDto);
			System.out.println("UserController/responseData : " + responseData);
			
			Script.responseData(response, responseData);
		}else if(cmd.equals("passwordCheck")) {
	
			BufferedReader br = request.getReader();
			String reqData = br.readLine();
			System.out.println("reqData : " + reqData);
			
			Gson gson = new Gson();
			PasswordReqDto dto = gson.fromJson(reqData, PasswordReqDto.class);
			
			User user = userService.회원패스워드(dto);
			System.out.println("UserController/회원패스워드.user : " + user);
			
			CommonRespDto<User> commonRespDto = new CommonRespDto<>();
			
			int result = userService.비밀번호찾기(dto);
			if(result != -1) {			// 유저가 없지(-1) 않으면(!=)
				commonRespDto.setStatusCode(1);
				commonRespDto.setData(user);
			}else {		
				commonRespDto.setStatusCode(-1);
			}
			
			String responseData = gson.toJson(commonRespDto);
			Script.responseData(response, responseData);
		}
		
		
	}
}
