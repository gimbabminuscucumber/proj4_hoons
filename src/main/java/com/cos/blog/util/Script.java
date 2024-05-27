package com.cos.blog.util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

public class Script {

	// 응답받은 데이터에 대해 alert 메세지를 전달
	public static void back(HttpServletResponse response, String msg) {
		PrintWriter out;
		try {
			out = response.getWriter();
			out.println("<script>");
			out.println("alert(' "+msg+" ');");
			out.println("history.back()");
			out.println("</script>");
			out.flush();		// 버퍼 비우기
		} catch (IOException e) {
 			e.printStackTrace();
		}
	}

	// 응답받은 데이터에 대해 alert 메세지는 미전달
	public static void responseData(HttpServletResponse response, String jsonData) {
		PrintWriter out;
		try {
			out = response.getWriter();
			out.print(jsonData);
			out.flush();		// 버퍼 비우기
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
