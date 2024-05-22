package com.cos.blog.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.cos.blog.domain.buy.Buy;
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderRespDto;
import com.cos.blog.domain.common.dto.CommonRespDto;
import com.cos.blog.domain.product.dto.DetailRespDto;
import com.cos.blog.domain.product.dto.SaveReqDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.BuyService;
import com.cos.blog.service.ProductService;
import com.cos.blog.util.Script;
import com.google.gson.Gson;



// URL 주소를 테이블 명으로 하면 편하다
// http://localhost:8080/project4/product
@WebServlet("/buy")
// 이미지 파일 업로드를 위해 멀티파트 구성 설정을 위한 어노테이션
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024, 					// 파일 크기 임계값 설정
	    maxFileSize = 1024 * 1024 * 5, 							// 최대 파일 크기 설정
	    maxRequestSize = 1024 * 1024 * 5 * 5 			// 요청 전체 크기 설정
	)
public class BuyController extends HttpServlet{
		private static final long serialVersionUID = 1L;
		
		public BuyController() {
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
			BuyService buyService = new BuyService();
			
			// ====================================================	
			// 												상품 구매
			// ====================================================	
			// http://localhost:8080/project4/buy?cmd=buyProduct
			if(cmd.equals("buy")) {
				BufferedReader br = request.getReader();
				
				// detail.jsp > fucntion buy()의 var data{} 를  test에 저장 (json 타입이라 String 으로만 저장가능)
				String reqData = br.readLine();					
				System.out.println("reqData : " + reqData);	// detail.jsp에서 json 타입으로 받아온 data
				
				Gson gson = new Gson();
				BuyReqDto dto = gson.fromJson(reqData, BuyReqDto.class);
				
				// 상품 구매시, 구매번호 생성
				String orderNum = buyService.구매번호();
				dto.setOrderNum(orderNum);
				
				int result = buyService.상품구매(dto);

				/*
				 * 구매 성공시, buy 테이블의 id 값을 가져오지는 못함
				// CommonRespDto<String> commonRespDto
				// - CommonRespDto를 String 타입으로 매개변수화
				// - CommonRespDto 클래스의 인스턴스를 참조
				// - CommonRespDto<String> 타입의 변수를 선언
				// - 이 인스턴스는 String 타입의 데이터를 다루도록 설정
				CommonRespDto<String> commonRespDto = new CommonRespDto<>();
				
				if(result != 1) {					// 상품구매()에 데이터가 정상 입력 안되면
					commonRespDto.setStatusCode(result);
					commonRespDto.setData("상품구매 실패");
				}else if(result == 1) {		// 상품구매() 데이터 정상 입력시,
					commonRespDto.setStatusCode(result);
					commonRespDto.setData("상품구매 성공");
				}
				*/
				
				// 구매 성공시, buy 테이블의 id 값 가져오기
				CommonRespDto<Integer> commonRespDto = new CommonRespDto<>();
	            commonRespDto.setStatusCode(result != -1 ? 1 : -1);
	            commonRespDto.setData(result);
				String respData = gson.toJson(commonRespDto);
				Script.responseData(response, respData);
				
			// ====================================================	
			// 											주문 완료 페이지
			// ====================================================		
			}else if(cmd.equals("order")) {
				int id = Integer.parseInt(request.getParameter("id"));
				
				OrderRespDto orders = buyService.주문완료(id);
				request.setAttribute("orders", orders);
				
				RequestDispatcher dis = request.getRequestDispatcher("buy/order.jsp");
				dis.forward(request, response);	

			// ====================================================	
			// 												주문 내역
			// ====================================================	
			}else if(cmd.equals("basket")) {
				int userId = Integer.parseInt(request.getParameter("id"));
				List<OrderRespDto> orders = buyService.주문내역(userId);
				
				request.setAttribute("orders", orders);
				
				RequestDispatcher dis = request.getRequestDispatcher("buy/basket.jsp");
				dis.forward(request, response);	
				
			// ====================================================	
			// 												주문 상세
			// ====================================================		
			}else if(cmd.equals("detail")) {
				String orderNum = request.getParameter("orderNum");
				
				List<OrderRespDto> details = buyService.주문상세(orderNum);
				request.setAttribute("details", details);
				OrderRespDto buyer = buyService.구매자정보(orderNum);
				request.setAttribute("buyer", buyer);
				
				RequestDispatcher dis = request.getRequestDispatcher("buy/detail.jsp");
				dis.forward(request, response);	
			}
	}
}
