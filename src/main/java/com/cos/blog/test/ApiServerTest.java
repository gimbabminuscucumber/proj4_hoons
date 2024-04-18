package com.cos.blog.test;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// 리플렉션 개념 공부하면 하기 코드가 이해 됨

// localhost:8080/project4/test
@WebServlet("/test")
public class ApiServerTest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ApiServerTest() {
        super();
    }
    
    // GET 요청 시, 해당 메소드 실행 (GET 방식 : select -> 찾을 때 사용)
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	}

	// POST 요청 시, 해당 메소드 실행 (POST 방식 : insert -> 저장할 때 사용)
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// postman에서 key:value 전달
		String food = request.getParameter("food");
		String howto = request.getParameter("howto");
		
		// text/plain 
		// - 평문 보낼 때
//		int result = 1;														// 1이 뜨면 정상
//		PrintWriter out = response.getWriter()	;		// 버퍼 연결
//		out.println(result);
//		out.flush();
		
		// application/json
		// - DB에 insert 된 레코드를 응답결과로 띄울 때
		int result = 1;
		PrintWriter out = response.getWriter();
		if(result == 1) {
			out.println("{\"food\": "+food+", \"howto\": "+howto+"}");
		}else {
			out.println("{\"error\":\"fail\"}");
		}
	}

}
