package com.cos.blog.web;

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

import com.cos.blog.domain.common.dto.CommonRespDto;
import com.cos.blog.domain.product.dto.DetailRespDto;
import com.cos.blog.domain.product.dto.SaveReqDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.ProductService;
import com.cos.blog.util.Script;
import com.google.gson.Gson;



// URL 주소를 테이블 명으로 하면 편하다
// http://localhost:8080/project4/product
@WebServlet("/product")
// 이미지 파일 업로드를 위해 멀티파트 구성 설정을 위한 어노테이션
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024, 					// 파일 크기 임계값 설정
	    maxFileSize = 1024 * 1024 * 5, 							// 최대 파일 크기 설정
	    maxRequestSize = 1024 * 1024 * 5 * 5 			// 요청 전체 크기 설정
	)
public class ProductController extends HttpServlet{
		private static final long serialVersionUID = 1L;
	       
		public ProductController() {
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
			ProductService productService = new ProductService();
			HttpSession session = request.getSession();							// 세션 불러오기
			
			// ====================================================	
			// 												제품 등록 1
			// ====================================================	
			// http://localhost:8080/project4/board?cmd=saveForm
			if(cmd.equals("saveForm")) {
				User principal = (User)session.getAttribute("principal");	// 세션에 principal이 있는지 확인 (로그인된 세션엔 princpal이 있으니까)
				request.setAttribute("principal", principal);
				if(principal != null) {
					RequestDispatcher dis = request.getRequestDispatcher("product/saveForm.jsp");
					dis.forward(request, response);	
				}else {
					RequestDispatcher dis = request.getRequestDispatcher("user/loginForm.jsp");
					dis.forward(request, response);	
				}
				
			// ====================================================	
			// 												제품 등록 2
			// ====================================================	
			}else if(cmd.equals("save")) {
				// 일반적인 form 태그에 심어둔 hidden 값을 가져오는 방법
				int userId = Integer.parseInt(request.getParameter("userId"));

				// Multipart form data에서 일반 폼 필드 데이터를 추출하는 방법
				//int userId = Integer.parseInt(request.getPart("userId").getInputStream().toString());
				int price = Integer.parseInt(request.getParameter("price"));
				int categoryId = Integer.parseInt(request.getParameter("category"));
				String brand = request.getParameter("brand");
				String content = request.getParameter("content");
				String weight = request.getParameter("weight");
				
				// 1. 이미지 파일 업로드
//				String img = request.getParameter("img");
				Part imgPart = request.getPart("img");
				String imgFileName = Paths.get(imgPart.getSubmittedFileName()).getFileName().toString();
				InputStream imgInputStream = imgPart.getInputStream();
				
				// 2. 파일 이름에 타임스탬프 추가
				String timestamp = String.valueOf(System.currentTimeMillis());
				String newImgFileName = timestamp + "_" + imgFileName;
				System.out.println("ProductController/save/newImgFileName : " + newImgFileName);
	            
				// 3. 파일 저장 경로 설정
				String uploadPath = getServletContext().getRealPath("/images/productImg");
				Path filePath = Paths.get(uploadPath, newImgFileName);

				// 4. 파일 저장
				Files.copy(imgInputStream, filePath);
	            
				SaveReqDto dto = new SaveReqDto();
				dto.setUserId(userId);
				dto.setPrice(price);
				dto.setCategoryId(categoryId);
				dto.setWeight(weight);
				dto.setBrand(brand);
				dto.setContent(content);
//				dto.setImg(img);
				
				// 이미지 파일 업로드
//	            dto.setImgFileName(imgFileName);				// 수정전
	            dto.setImgFileName(newImgFileName);		// 수정후
	            dto.setImgInputStream(imgInputStream);
				
	            System.out.println("ProductController/save/dto : " + dto);
	            
				int result = productService.제품등록(dto);
				
				if(result == 1) {	// 정상 입력 완료
					response.sendRedirect("/project4/product/list.jsp");
				}else {					// 정상 입력 실패
					Script.back(response, "상품 등록 실패");
				}
			
			// ====================================================	
			// 												제품 목록
			// ====================================================	
			}else if(cmd.equals("list")) {
				//int page = Integer.parseInt(request.getParameter("page"));
				//List<DetailRespDto> products = productService.상품목록(page);
				List<DetailRespDto> products = productService.상품목록();
				request.setAttribute("products", products);
				/*
				// 페이지 계산
				int productCount = productService.상품개수();
				int lastPage = (productCount -1)/4;
				request.setAttribute("lastPage", lastPage);
				
				// 페이지 진척도
				double currentPercent = (double)page/(lastPage)*100;		// 진척도별 바 게이지
				request.setAttribute("currentPercent", currentPercent);	
				*/
				RequestDispatcher dis = request.getRequestDispatcher("product/list.jsp");
				dis.forward(request, response);	
			
			// ====================================================	
			// 												제품 삭제
			// ====================================================
			}else if(cmd.equals("delete")) {
				int id = Integer.parseInt(request.getParameter("id"));
				int result = productService.상품삭제(id);
				CommonRespDto<String> commonRespDto = new CommonRespDto<>();
				commonRespDto.setStatusCode(result);
				commonRespDto.setData("성공");
				
				Gson gson = new Gson();
				String respData = gson.toJson(commonRespDto);
				System.out.println("respData : " + respData);
				
				PrintWriter out = response.getWriter();
				out.print(respData);
				out.flush();

			// ====================================================	
			// 												상품 상세
			// ====================================================
			}else if(cmd.equals("detail")) {
				int id = Integer.parseInt(request.getParameter("id"));
				DetailRespDto products = productService.상품상세보기(id);
				
				if(products == null) {
					Script.back(response, "상품을 찾을 수 없습니다.");
				}else {
					request.setAttribute("products", products);
					RequestDispatcher dis = request.getRequestDispatcher("product/detail.jsp");
					dis.forward(request, response);	
				}
				
			// ====================================================	
			// 												포장하기
			// ====================================================	
			}else if(cmd.equals("packProduct")) {
			    int userId = Integer.parseInt(request.getParameter("userId"));
			    int productId = Integer.parseInt(request.getParameter("productId"));
			    int quantity = Integer.parseInt(request.getParameter("quantity"));

			    int result = productService.제품포장(productId, quantity);

			    if (result == 1) {
			        DetailRespDto product = productService.상품상세보기(productId);
			        CommonRespDto<DetailRespDto> responseDto = new CommonRespDto<>();
			        responseDto.setStatusCode(1);
			        responseDto.setData(product);
			        
			        String jsonResponse = new Gson().toJson(responseDto);
			        response.setContentType("application/json; charset=UTF-8");
			        
			        PrintWriter out = response.getWriter();
			        out.print(jsonResponse);
			        out.flush();
			    } else {
			        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "포장 실패");
			    }
			
			// ====================================================	
			// 							메인 페이지 검색 && 카테고리 별 리스트
			// ====================================================
			}else if(cmd.equals("search")) {
				String keyword = request.getParameter("keyword");
				String categoryIdStr = request.getParameter("categoryId");
				System.out.println("ProductController/search/categoryIdStr000 : " + categoryIdStr);
				List<DetailRespDto> products;

				if(categoryIdStr != null && !categoryIdStr.isEmpty()) {
					int categoryId = Integer.parseInt(categoryIdStr);
					products = productService.카테고리별상품목록(categoryId);
					System.out.println("ProductController/search/categoryIdStr111 : " + categoryIdStr);
					System.out.println("ProductController/search/products111 : " + products);
				}else {
					products = productService.상품검색(keyword);
					System.out.println("ProductController/search/categoryIdStr222 : " + categoryIdStr);
					System.out.println("ProductController/search/products222 : " + products);
				}
				
				request.setAttribute("products", products);
				RequestDispatcher dis = request.getRequestDispatcher("product/list.jsp");
				dis.forward(request, response);	
			}
	}
}
