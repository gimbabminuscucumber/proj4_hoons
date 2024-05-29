package com.cos.blog.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cos.blog.domain.buy.dto.BasketReqDto;
import com.cos.blog.domain.buy.dto.BuyFormReqDto;
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderReqDto;
import com.cos.blog.domain.common.dto.CommonRespDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.BuyService;
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
			HttpSession session = request.getSession();
			User user = (User)session.getAttribute("principal");
			
			// ====================================================	
			// 												상품 구매
			// ====================================================	
			// http://localhost:8080/project4/buy?cmd=buyProduct
			if(cmd.equals("buy")) {
				/*
				// 제품 상세페이지에서 데이터를 DB에 저장하기
				BufferedReader br = request.getReader();
				
				// detail.jsp > fucntion buy()의 var data{} 를  test에 저장 (json 타입이라 String 으로만 저장가능)
				String reqData = br.readLine();					
				
				Gson gson = new Gson();
				BuyReqDto dto = gson.fromJson(reqData, BuyReqDto.class);
				
				// 상품 구매시, 구매번호 생성
				String orderNum = buyService.구매번호();
				dto.setOrderNum(orderNum);
				int result = buyService.상품구매(dto);

				// 구매 성공시, buy 테이블의 id 값 가져오기
				CommonRespDto<Integer> commonRespDto = new CommonRespDto<>();
				commonRespDto.setStatusCode(result != -1 ? 1 : -1);
				commonRespDto.setData(result);
				String respData = gson.toJson(commonRespDto);
				Script.responseData(response, respData);
				*/
				
				// 장바구니에서 배열 데이터를 DB에 저장하기
				BufferedReader br = request.getReader();
		        StringBuilder reqData = new StringBuilder();
		        String line;
		        while ((line = br.readLine()) != null) {
		            reqData.append(line);
		        }
		        
		        // 요청 데이터 확인
		        System.out.println("Request Data: " + reqData.toString());

		        Gson gson = new Gson();
		        BuyReqDto[] dtos = gson.fromJson(reqData.toString(), BuyReqDto[].class);
		        
		        // 상품 구매 처리
		        for (BuyReqDto dto : dtos) {
		            // 각 dto를 활용하여 상품 구매 처리
		            String orderNum = buyService.구매번호();
		            dto.setOrderNum(orderNum);
		            int result = buyService.상품구매(dto);
		            
		            // 응답 데이터 전송
		            CommonRespDto<Integer> commonRespDto = new CommonRespDto<>();
		            commonRespDto.setStatusCode(result != -1 ? 1 : -1);
		            commonRespDto.setData(result);
		            String respData = gson.toJson(commonRespDto);
		            Script.responseData(response, respData);
		        }
				
				
			// ====================================================	
			// 												주문서 작성
			// ====================================================		
			}else if(cmd.equals("buyForm")) {
				String[] productIds = request.getParameterValues("productId");
			    int[] checkedItems = Arrays.stream(productIds).mapToInt(Integer::parseInt).toArray();

			    // 로그인된 사용자 정보 가져오기 (예: 세션에서 userId를 가져오는 방식)
			    int userId = user.getId();

			    List<OrderReqDto> orders = buyService.주문서작성(checkedItems, userId);

			    // 구매한 상품을 basket 테이블에서 삭제
			    for (int productId : checkedItems) {
			        buyService.장바구니삭제(userId, productId);
			    }

			    request.setAttribute("orders", orders);
			    RequestDispatcher dis = request.getRequestDispatcher("buy/buyForm.jsp");
			    dis.forward(request, response);
				
	        // ====================================================	
			// 											주문 완료 페이지
			// ====================================================		
			}else if(cmd.equals("order")) {
			    int id = Integer.parseInt(request.getParameter("id"));

			    // 주문 완료된 데이터만을 가져오기
			    List<OrderReqDto> orders = buyService.주문완료(id);
			    request.setAttribute("orders", orders);

			    RequestDispatcher dis = request.getRequestDispatcher("buy/order.jsp");
			    dis.forward(request, response);

			// ====================================================	
			// 												주문 내역
			// ====================================================	
			}else if(cmd.equals("list")) {
				int userId = Integer.parseInt(request.getParameter("id"));
				List<OrderReqDto> orders = buyService.주문내역(userId);
				
				request.setAttribute("orders", orders);
				
				RequestDispatcher dis = request.getRequestDispatcher("buy/list.jsp");
				dis.forward(request, response);	
				
			// ====================================================	
			// 												주문 상세
			// ====================================================		
			}else if(cmd.equals("detail")) {
				String orderNum = request.getParameter("orderNum");
				
				List<OrderReqDto> details = buyService.주문상세(orderNum);
				request.setAttribute("details", details);
				OrderReqDto buyer = buyService.구매자정보(orderNum);
				request.setAttribute("buyer", buyer);
				
				RequestDispatcher dis = request.getRequestDispatcher("buy/detail.jsp");
				dis.forward(request, response);	
			
			// ====================================================	
			// 											장바구니 담기
			// ====================================================		
			}else if(cmd.equals("basket")) {
				BufferedReader br = request.getReader();
				String reqData = br.readLine();
				
				Gson gson = new Gson();
				BasketReqDto dto = gson.fromJson(reqData, BasketReqDto.class);
				
				CommonRespDto<String> commonRespDto = new CommonRespDto<>()	;
				int result = buyService.장바구니담기(dto);
				if(result == 1) {
					commonRespDto.setStatusCode(result);
					commonRespDto.setData("ok");
				}else {
					commonRespDto.setStatusCode(result);
					commonRespDto.setData("fail");
				}
				
				String data = gson.toJson(commonRespDto);
				
				PrintWriter out = response.getWriter();
				out.print(data);
				out.flush();
			
			// ====================================================	
			// 											장바구니 조회
			// ====================================================		
			}else if(cmd.equals("basketList")) {
				int userId = Integer.parseInt(request.getParameter("id"));
				
				List<BasketReqDto> baskets = buyService.장바구니조회(userId);
		        request.setAttribute("baskets", baskets);
		        RequestDispatcher dis = request.getRequestDispatcher("buy/basketList.jsp");
		        dis.forward(request, response);
		        
			}

	}
}
