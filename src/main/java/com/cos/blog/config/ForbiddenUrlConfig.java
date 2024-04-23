package com.cos.blog.config;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// 이제부터는 내부에서의 모든 요청은 RequestDispatcher로 해야한다
// 그래야 다시 필터를 타지 않는다

public class ForbiddenUrlConfig implements Filter{
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) resp;

//		System.out.println("ForbiddenUrlConfig 접근");
//		System.out.println("getRequestURL : " + request.getRequestURL());		// URL : 풀 주소가 다 나옴
//		System.out.println("getRequestURI : " + request.getRequestURI());			// URI : 끝에 context 주소만 나옴
		
		if(request.getRequestURI().equals("/project4/") || request.getRequestURI().equals("/project4/index.jsp")) {
			chain.doFilter(request, response);
		}else {
			PrintWriter out = response.getWriter();
			out.print("잘못된 접근입니다.");
			out.flush();
		}
	}
}
