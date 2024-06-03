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

import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.common.dto.CommonRespDto;
import com.cos.blog.domain.product.dto.DetailRespDto;
import com.cos.blog.domain.product.dto.SaveReqDto;
import com.cos.blog.domain.review.dto.InfoRespDto;
import com.cos.blog.domain.review.dto.ReviewReqDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.BuyService;
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
			BuyService buyService = new BuyService();
			HttpSession session = request.getSession();							// 세션 불러오기
			
			// ====================================================	
			// 												상품 등록 1
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
			// 												상품 등록 2
			// ====================================================	
			}else if(cmd.equals("save")) {
				
				int userId = Integer.parseInt(request.getParameter("userId"));
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
				// explanation 추가
	            Part explainPart = request.getPart("explanation");
	            String explainFileName = Paths.get(explainPart.getSubmittedFileName()).getFileName().toString();
	            InputStream explainInputStream = explainPart.getInputStream();
	            
				// 2. 파일 이름에 타임스탬프 추가
				String timestamp = String.valueOf(System.currentTimeMillis());
				String newImgFileName = timestamp + "_" + imgFileName;
				// explanation 추가
	            String newExplainFileName = timestamp + "_" + explainFileName;
				
				// 3. 파일 저장 경로 설정
				String uploadPath = getServletContext().getRealPath("/images/productImg");
				Path filePath = Paths.get(uploadPath, newImgFileName);
				// explain 추가
				 Path explainFilePath = Paths.get(uploadPath, newExplainFileName);
				 
				// 4. 파일 저장
				Files.copy(imgInputStream, filePath);
				// explanation 추가
				Files.copy(explainInputStream, explainFilePath);
				
				SaveReqDto dto = new SaveReqDto();
				dto.setUserId(userId);
				dto.setPrice(price);
				dto.setCategoryId(categoryId);
				dto.setWeight(weight);
				dto.setBrand(brand);
				dto.setContent(content);
//				dto.setImg(img);
				
				// 이미지 파일 업로드
	            dto.setImgFileName(newImgFileName);
	            dto.setImgInputStream(imgInputStream);
				// explanation 추가
	            dto.setExplainFileName(newExplainFileName);
	            dto.setExplainInputStream(explainInputStream);
				
	            System.out.println("ProductController/save/dto : " + dto);
	            
				int result = productService.상품등록(dto);
				
				if(result == 1) {	// 정상 입력 완료
					response.sendRedirect("/project4/product?cmd=list");
				}else {					// 정상 입력 실패
					Script.back(response, "상품 등록 실패");
				}
				
				
			// ====================================================	
			// 												상품 목록
			// ====================================================	
			}else if(cmd.equals("list")) {
				int page = Integer.parseInt(request.getParameter("page"));
				User principal = (User)session.getAttribute("principal");	// 세션에 principal이 있는지 확인 (로그인된 세션엔 princpal이 있으니까)
				request.setAttribute("principal", principal);
		
				List<DetailRespDto> products = productService.상품목록(page);
				request.setAttribute("products", products);
				
				// 페이지 계산
				int productCount = productService.상품개수();
				int lastPage = (productCount -1)/16;
				request.setAttribute("lastPage", lastPage);
				System.out.println("ProductController/list/등록된 상품 총 개수 : " + productCount);
				System.out.println("ProductController/list/마지막 페이지(0부터) : " + lastPage);

				RequestDispatcher dis = request.getRequestDispatcher("product/list.jsp");
				dis.forward(request, response);	
			
			// ====================================================	
			// 								상품 목록 (검색 & 카테고리)
			// ====================================================
			}else if(cmd.equals("search")) {
				String keyword = request.getParameter("keyword");
				String categoryIdStr = request.getParameter("categoryId");
				int page = Integer.parseInt(request.getParameter("page"));
				List<DetailRespDto> products;
				
				// 카테고리 페이지
				if(categoryIdStr != null && !categoryIdStr.isEmpty()) {
					int categoryId = Integer.parseInt(categoryIdStr);
					products = productService.카테고리상품목록(categoryId, page);
					System.out.println("ProductController/search/카테고리/products : " + products);
					
					// 페이지 계산
					int productCount = productService.카테고리상품개수(categoryId);
					request.setAttribute("products", products);
					int lastPage = (productCount -1)/16;
					request.setAttribute("lastPage", lastPage);
				}
				
				// 검색 페이지
				if(keyword != null && !keyword.isEmpty()) {
					products = productService.키워드상품목록(keyword, page);
					System.out.println("ProductController/search/검색/products : " + products);
					
					// 페이지 계산
					int productCount = productService.키워드상품개수(keyword);
					request.setAttribute("products", products);
					int lastPage = (productCount -1)/16;
					request.setAttribute("lastPage", lastPage);
				}
				
				RequestDispatcher dis = request.getRequestDispatcher("product/list.jsp");
				dis.forward(request, response);	
			// ====================================================	
			// 												상품 상세
			// ====================================================
			}else if(cmd.equals("detail")) {
				int id = Integer.parseInt(request.getParameter("id"));		// id = product테이블의 id
				String brand = request.getParameter("brand");
				DetailRespDto products = productService.상품상세보기(id);
				List<DetailRespDto> mostViews = productService.많이본상품();
				List<InfoRespDto> reviews = buyService.리뷰정보(id);
				List<DetailRespDto> suggests = productService.추천상품(brand);
				
				if(products == null) {
					Script.back(response, "상품을 찾을 수 없습니다.");
				}else {
					request.setAttribute("products", products);
					request.setAttribute("mostViews", mostViews);
					request.setAttribute("reviews", reviews);
					request.setAttribute("suggests", suggests);
					RequestDispatcher dis = request.getRequestDispatcher("product/detail.jsp");
					dis.forward(request, response);	
				}
				
			// ====================================================	
			// 												상품 삭제
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
			// 							 				데이터 수정 페이지
			// ====================================================
			}else if(cmd.equals("updateForm")) {
				System.out.println("ProductController/updateForm 진입");
				int id = Integer.parseInt(request.getParameter("id"));	// product 테이블의 id
				System.out.println("ProductController/updateForm/id : " + id);
				
				DetailRespDto products = productService.상품정보(id);
				System.out.println("ProductController/updateForm/products : " + products);
				System.out.println("ProductController/updateForm/products.getId() : " + products.getId());
				request.setAttribute("products", products);
				RequestDispatcher dis = request.getRequestDispatcher("product/updateForm.jsp");
				dis.forward(request, response);	
				System.out.println("ProductController/updateForm/0000 ");
				
			// ====================================================	
			// 							 					데이터 수정 
			// ====================================================
			}else if(cmd.equals("update")) {
				System.out.println("ProductController/update 진입");
				
				int id = Integer.parseInt(request.getParameter("id"));
				int userId = Integer.parseInt(request.getParameter("userId"));
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
				// explanation 추가
	            Part explainPart = request.getPart("explanation");
	            String explainFileName = Paths.get(explainPart.getSubmittedFileName()).getFileName().toString();
	            InputStream explainInputStream = explainPart.getInputStream();
	            
				// 2. 파일 이름에 타임스탬프 추가
				String timestamp = String.valueOf(System.currentTimeMillis());
				String newImgFileName = timestamp + "_" + imgFileName;
				// explanation 추가
	            String newExplainFileName = timestamp + "_" + explainFileName;
				
				// 3. 파일 저장 경로 설정
				String uploadPath = getServletContext().getRealPath("/images/productImg");
				Path filePath = Paths.get(uploadPath, newImgFileName);
				// explain 추가
				 Path explainFilePath = Paths.get(uploadPath, newExplainFileName);
				 
				// 4. 파일 저장
				Files.copy(imgInputStream, filePath);
				// explanation 추가
				Files.copy(explainInputStream, explainFilePath);
				
				SaveReqDto dto = new SaveReqDto();
				dto.setId(id);
				dto.setUserId(userId);
				dto.setPrice(price);
				dto.setCategoryId(categoryId);
				dto.setWeight(weight);
				dto.setBrand(brand);
				dto.setContent(content);
//				dto.setImg(img);
				
				// 이미지 파일 업로드
	            dto.setImgFileName(newImgFileName);
	            dto.setImgInputStream(imgInputStream);
				// explanation 추가
	            dto.setExplainFileName(newExplainFileName);
	            dto.setExplainInputStream(explainInputStream);
				
	            System.out.println("ProductController/save/dto : " + dto);
	            
				int result = productService.상품수정(dto);
				
				if(result == 1) {	// 정상 입력 완료
					response.sendRedirect("/project4/product?cmd=list");
				}else {					// 정상 입력 실패
					Script.back(response, "상품 수정 실패");
				}
				
				
			}
	}
}
