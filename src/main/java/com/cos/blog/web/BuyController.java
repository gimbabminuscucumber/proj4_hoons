package com.cos.blog.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderReqDto;
import com.cos.blog.domain.buy.dto.OrderSheetReqDto;
import com.cos.blog.domain.common.dto.CommonRespDto;
import com.cos.blog.domain.reply.Reply;
import com.cos.blog.domain.review.Review;
import com.cos.blog.domain.review.dto.ReviewReqDto;
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
			Gson gson = new Gson();		
			//Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss.S").create();
			// ====================================================	
			// 												상품 구매
			// ====================================================	
			// http://localhost:8080/project4/buy?cmd=buyProduct
			if(cmd.equals("buy")) {
				// 장바구니에서 배열 데이터를 DB에 저장하기
				BufferedReader br = request.getReader();
		        StringBuilder reqData = new StringBuilder();
		        String line;
		       
		        while ((line = br.readLine()) != null) {
		            reqData.append(line);
		        }

//		        Gson gson = new Gson();
		        BuyReqDto[] dtos = gson.fromJson(reqData.toString(), BuyReqDto[].class);
		        
		        // 상품 구매 처리
		        String orderNum = buyService.구매번호();
		        boolean allSuccessful = true;
		        for (BuyReqDto dto : dtos) {
		            // 각 dto를 활용하여 상품 구매 처리
		            dto.setOrderNum(orderNum);
		            int result = buyService.상품구매(dto);
		            if (result == -1) {
		                allSuccessful = false;
		            }
		        }
		        
		        // 응답 데이터 전송
		        CommonRespDto<String> commonRespDto = new CommonRespDto<>();
		        commonRespDto.setStatusCode(allSuccessful ? 1 : -1);
		        commonRespDto.setData(orderNum);
		        String respData = gson.toJson(commonRespDto);
		        System.out.println("respData : " + respData);
		        response.setContentType("application/json");
		        response.setCharacterEncoding("UTF-8");
		        response.getWriter().write(respData);
		        
		    // ====================================================	
			// 											주문서 작성
			// ====================================================		
			}else if(cmd.equals("buyForm")) {
			    String[] basketIds = request.getParameterValues("basketId");
			    int[] checkedItems = Arrays.stream(basketIds).mapToInt(Integer::parseInt).toArray();		
			    	// Arrays.stream(basketIds) : 가져온 문자열 배열을 스트림으로 변환
					// mapToInt(Integer::parseInt) : 각 문자열을 정수로 변환하여 IntStream을 생성
			    	// toArray() : IntStream의 요소들을 배열로 변환
			    System.out.println("checkedItems" + Arrays.toString(basketIds));
			    int userId = user.getId();
			    
			    List<OrderReqDto> orders = buyService.주문서작성(checkedItems, userId);

			    request.setAttribute("orders", orders);
			    RequestDispatcher dis = request.getRequestDispatcher("buy/buyForm.jsp");
			    dis.forward(request, response);

			    // 구매한 상품을 basket 테이블에서 삭제
			    for (OrderReqDto order : orders) {
			    	buyService.장바구니삭제(userId, order.getId());
			    }
			    
		    // ====================================================	
		    // 											주문서 작성2
		    // ====================================================		
			}else if(cmd.equals("buyForm2")) {
			    System.out.println("BuyController/buyForm2 진입");
			    // 생성된 id 값과 상품 id를 받아옴
			    int userId = Integer.parseInt(request.getParameter("userId"));
			    int productId = Integer.parseInt(request.getParameter("productId"));
			    
			    OrderReqDto orders = buyService.주문서작성2(productId, userId);
			    System.out.println("orders : " + orders);
			    request.setAttribute("orders", orders);

			    RequestDispatcher dis = request.getRequestDispatcher("buy/buyForm2.jsp");
			    dis.forward(request, response);
		   
			// ====================================================	
			// 											오더지 담기
			// ====================================================		
			}else if(cmd.equals("orderSheet")) {
				BufferedReader br = request.getReader();
			    String reqData = br.readLine();
			    
			    //Gson gson = new Gson();
			    OrderSheetReqDto dto = gson.fromJson(reqData, OrderSheetReqDto.class);
			    int id = buyService.오더지담기(dto); // 생성된 id 값을 받아옴
			    CommonRespDto<Integer> commonRespDto = new CommonRespDto<>();
			    if(id != -1) {
			        commonRespDto.setStatusCode(1);
			        commonRespDto.setData(id); // 생성된 id 값을 설정하여 응답
			    } else {
			        commonRespDto.setStatusCode(-1);
			        commonRespDto.setData(-1);
			    }
			    response.getWriter().write(gson.toJson(commonRespDto));
				
	        // ====================================================	
			// 											주문 완료 페이지
			//					- 주문한 제품만 보여지게 하기(이전에 구매한 제품은 안보이게 > createDate나 by id이용하면 될거같긴한데...)
			// ====================================================		
			}else if(cmd.equals("order")) {
			    String orderNum = request.getParameter("orderNum");
			    int userId = user.getId();
			    //List<OrderReqDto> orders = buyService.주문완료(userId, buyId);
			    List<OrderReqDto> orders = buyService.주문완료(orderNum);
			    System.out.println("BuyController/order/orders : " + orders);
			    request.setAttribute("orders", orders);
			    request.setAttribute("userId", userId);

			    RequestDispatcher dis = request.getRequestDispatcher("buy/order.jsp");
			    dis.forward(request, response);
			    
			// ====================================================	
			// 												주문 내역
			// ====================================================	
			}else if(cmd.equals("list")) {
				int userId = Integer.parseInt(request.getParameter("id"));
				List<OrderReqDto> orders = buyService.주문내역(userId);
				System.out.println("BuyController/list/orders : " + orders);
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
				
//				Gson gson = new Gson();
				BasketReqDto dto = gson.fromJson(reqData, BasketReqDto.class);
				int result = buyService.장바구니담기(dto);
				
				CommonRespDto<BasketReqDto> commonRespDto = new CommonRespDto<>()	;
				if(result == 1) {
					commonRespDto.setStatusCode(result);
					commonRespDto.setData(dto);
				}else {
					commonRespDto.setStatusCode(result);
					commonRespDto.setData(null);
				}
				
				String data = gson.toJson(commonRespDto);
				
				PrintWriter out = response.getWriter();		// response 반환
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
		        
			// ====================================================	
			// 											리뷰 작성 페이지
			// ====================================================		
			}else if(cmd.equals("reviewForm")) {
				int id = Integer.parseInt(request.getParameter("id"));		// buy 테이블의 id값
				
				OrderReqDto reviews = buyService.리뷰상품(id);
				request.setAttribute("reviews", reviews);
				RequestDispatcher dis = request.getRequestDispatcher("buy/reviewForm.jsp");
				dis.forward(request, response);
					
			// ====================================================	
			// 												리뷰 저장
			// ====================================================		
			}else if(cmd.equals("review")) {
				BufferedReader br = request.getReader();
			    StringBuilder reqData = new StringBuilder();
			    String line;
			    while ((line = br.readLine()) != null) {
			        reqData.append(line);
			    }
			    
			    // JSON 데이터를 ReviewReqDto 객체로 파싱
			    ReviewReqDto dto = gson.fromJson(reqData.toString(), ReviewReqDto.class);
				
				int result = buyService.리뷰작성(dto);
			    
			    CommonRespDto<Integer> commonRespDto = new CommonRespDto<>();
			    commonRespDto.setStatusCode(result != -1 ? 1 : -1);
			    commonRespDto.setData(result);
			    String respData = gson.toJson(commonRespDto);
			    Script.responseData(response, respData);
			    
			// ====================================================	
			// 												리뷰 삭제
			// ====================================================
			}else if(cmd.equals("reviewDelete")) {
				int reviewId = Integer.parseInt(request.getParameter("id"));
				int result = buyService.리뷰삭제(reviewId);
				
				CommonRespDto<Review> commonDto = new CommonRespDto<>();
				commonDto.setStatusCode(result);
				
				//Gson gson = new Gson();
				String jsonData = gson.toJson(commonDto);
				Script.responseData(response, jsonData);
				
			// ====================================================	
			// 									주문 관리 (관리자 전용)
			// ====================================================
			}else if(cmd.equals("manage")) {
				List<OrderReqDto> orders = buyService.주문관리();
				
				request.setAttribute("orders", orders);
				RequestDispatcher dis = request.getRequestDispatcher("buy/manage.jsp");
				dis.forward(request, response);
			
			// ====================================================	
			// 									처리 현황 (관리자 전용)
			// ====================================================
			}else if(cmd.equals("stateChange")) {
				int id = Integer.parseInt(request.getParameter("id"));
				int state = Integer.parseInt(request.getParameter("state"));

				int result = buyService.주문처리(id, state);
				System.out.println("BuyController/result : " + result);
				
				if(result ==1 ) {
					response.sendRedirect("/project4/buy?cmd=manage");
				}else {
					Script.back(response, "처리 현황 수정에 실패했습니다.");
				}
				
			// ====================================================	
			// 										장바구니 상품 삭제
			// ====================================================
			}else if(cmd.equals("productDelete")) {
				int basketId = Integer.parseInt(request.getParameter("basketId"));
				int userId = Integer.parseInt(request.getParameter("userId"));
				System.out.println("BuyController/productDelete/basketId : " + basketId + " & userId : " + userId);
				int result = buyService.장바구니삭제(userId, basketId);
				System.out.println("BuyController/productDelete/result : " + result);
				
				CommonRespDto<Integer> commonDto = new CommonRespDto<>();
				commonDto.setStatusCode(result);
				
				String jsonData = gson.toJson(commonDto);
				System.out.println("BuyController/productDelete/jsonData : " + jsonData);
				Script.responseData(response, jsonData);
				
			// ====================================================	
			// 										장바구니 상품 변경
			// ====================================================
			}else if(cmd.equals("basketUpdate")) {
				int basketId = Integer.parseInt(request.getParameter("basketId"));
	            int totalCount = Integer.parseInt(request.getParameter("totalCount"));
	            System.out.println("BuyController/basketUpdate/basketId : " + basketId + " & totalCount : " + totalCount);
	            
	            int result = buyService.장바구니수정(basketId, totalCount);

	            CommonRespDto<String> commonRespDto = new CommonRespDto<>();
	            commonRespDto.setStatusCode(result == 1 ? 1 : -1);
	            String respData = new Gson().toJson(commonRespDto);
	            response.setContentType("application/json");
	            response.setCharacterEncoding("UTF-8");
	            response.getWriter().write(respData);
				
			// ====================================================	
			// 									장바구니 상품 선택 삭제
			// ====================================================
			}else if(cmd.equals("basketProductDelete")) {
				String[] basketIds = request.getParameterValues("basketIds");
			    int[] ids = Arrays.stream(basketIds).mapToInt(Integer::parseInt).toArray();
			    int userId = user.getId();
			    boolean success = true;
			    for (int id : ids) {
			        boolean deleted = buyService.장바구니선택삭제(userId, id);
			        if (!deleted) {
			            success = false;
			            break;
			        }
			    }

			    // JSON 형식으로 응답을 보내기 위해 content type 설정
			    response.setContentType("application/json");
			    response.setCharacterEncoding("UTF-8");
			    PrintWriter out = response.getWriter();

			    // 삭제 성공 여부에 따라 JSON 응답 작성
			    if (success) {
			        out.print("{\"success\": true}");
			    } else {
			        out.print("{\"success\": false}");
			    }
			    out.flush();
			}
			
	}
}
