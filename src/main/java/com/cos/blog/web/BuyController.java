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
import com.cos.blog.domain.review.dto.ReviewReqDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.BuyService;
import com.cos.blog.util.Script;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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
//	        Gson gson = new Gson();		// 날짜 형식 때문에 아래 코드로 변경
			Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss.S").create();
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
		        
		        // 요청 데이터 확인
		        System.out.println("Request Data: " + reqData.toString());

//		        Gson gson = new Gson();
		        BuyReqDto[] dtos = gson.fromJson(reqData.toString(), BuyReqDto[].class);
		        
		        // 상품 구매 처리
		        String orderNum = buyService.구매번호();
		        for (BuyReqDto dto : dtos) {
		            // 각 dto를 활용하여 상품 구매 처리
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
/*
			    // 구매한 상품을 basket 테이블에서 삭제
			    for (int productId : checkedItems) {
			        buyService.장바구니삭제(userId, productId);
			    }
*/
			    request.setAttribute("orders", orders);
			    RequestDispatcher dis = request.getRequestDispatcher("buy/buyForm.jsp");
			    dis.forward(request, response);
				
	        // ====================================================	
			// 											주문 완료 페이지
			//					- 주문한 제품만 보여지게 하기(이전에 구매한 제품은 안보이게 > createDate나 by id이용하면 될거같긴한데...)
			// ====================================================		
			}else if(cmd.equals("order")) {
			    int userId = Integer.parseInt(request.getParameter("userId"));
			    int productId = Integer.parseInt(request.getParameter("productId"));
			    System.out.println("BuyController/order/productIds : " + productId);
			    List<OrderReqDto> orders = buyService.주문완료(userId, productId);
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
				
//				Gson gson = new Gson();
				BasketReqDto dto = gson.fromJson(reqData, BasketReqDto.class);
				int result = buyService.장바구니담기(dto);
				
				CommonRespDto<String> commonRespDto = new CommonRespDto<>()	;
				if(result == 1) {
					commonRespDto.setStatusCode(result);
					commonRespDto.setData("ok");
				}else {
					commonRespDto.setStatusCode(result);
					commonRespDto.setData("fail");
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
			// 											리뷰 작성 페이지
			// ====================================================		
			}else if(cmd.equals("review")) {
				/*
				 * reviewForm.jsp에서 ajax를 통해 json으로 보내기 '전'
				int id = Integer.parseInt(request.getParameter("buyId"));
				int userId = Integer.parseInt(request.getParameter("userId"));
				int productId = Integer.parseInt(request.getParameter("productId"));
				String text = request.getParameter("text");
			    int score = Integer.parseInt(request.getParameter("score"));
				System.out.println("BuyController/review :: userId : " + userId +" id : " + id + " productId : " +productId + " text : " + text + " score : " + score);
				
				ReviewReqDto dto = new ReviewReqDto();
				dto.setBuyId(id);
				dto.setUserId(userId);
				dto.setProductId(productId);
				dto.setScore(score);
				dto.setText(text);
				
				int result = buyService.리뷰작성(dto);	
				
			    CommonRespDto<String> commonRespDto = new CommonRespDto<>();
			    if (result == 1) {
			        commonRespDto.setStatusCode(1);
			        commonRespDto.setData("리뷰 작성을 완료하였습니다.");
			    } else {
			        commonRespDto.setStatusCode(-1);
			        commonRespDto.setData("리뷰 작성에 실패했습니다.");
			    }

			    String respData = new Gson().toJson(commonRespDto);
			    PrintWriter out = response.getWriter();
			    out.print(respData);
			    out.flush();
				 */
				
				// reviewForm.jsp에서 ajax를 통해 json으로 보낸 '후'
				BufferedReader br = request.getReader();
			    StringBuilder reqData = new StringBuilder();
			    String line;
			    while ((line = br.readLine()) != null) {
			        reqData.append(line);
			    }
			    
			    // 요청 데이터 확인
			    System.out.println("Request Data: " + reqData.toString());

			    // JSON 데이터를 ReviewReqDto 객체로 파싱
			    ReviewReqDto dto = gson.fromJson(reqData.toString(), ReviewReqDto.class);
			    System.out.println("BuyController/review/dto : " + dto);
				
				int result = buyService.리뷰작성(dto);
			    System.out.println("BuyController/review/result : " + result);
			    
			    CommonRespDto<Integer> commonRespDto = new CommonRespDto<>();
			    commonRespDto.setStatusCode(result != -1 ? 1 : -1);
			    commonRespDto.setData(result);
			    String respData = gson.toJson(commonRespDto);
			    Script.responseData(response, respData);
			    
			    
			    
			}

	}
}
