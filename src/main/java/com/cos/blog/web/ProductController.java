package com.cos.blog.web;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.cos.blog.domain.product.dto.SaveReqDto;
import com.cos.blog.domain.user.User;
import com.cos.blog.service.ProductService;
import com.cos.blog.util.Script;

// URL 주소를 테이블 명으로 하면 편하다
// http://localhost:8080/project4/product
@WebServlet("/product")
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
				int userId = Integer.parseInt(request.getParameter("userId"));		// saveForm 에서 hidden으로 받아온 userId
				int price = Integer.parseInt(request.getParameter("price"));
				int categoryId = Integer.parseInt(request.getParameter("categoryId"));
				String weight = request.getParameter("weight");
				String name = request.getParameter("name");
				String content = request.getParameter("cotent");
//				String img = request.getParameter("img");
				
				
				// 이미지 파일 업로드
	            Part imgPart = request.getPart("img");
	            String imgFileName = Paths.get(imgPart.getSubmittedFileName()).getFileName().toString();
	            InputStream imgInputStream = imgPart.getInputStream();
				
	            System.out.println("ProductController/save/imgPart : " + imgPart);
	            System.out.println("ProductController/save/imgFileName : " + imgFileName);
	            System.out.println("ProductController/save/imgInputStream : " + imgInputStream);
	            
				SaveReqDto dto = new SaveReqDto();
				dto.setUserId(userId);
				dto.setPrice(price);
				dto.setCategoryId(categoryId);
				dto.setWeight(weight);
				dto.setName(name);
				dto.setContent(content);
//				dto.setImg(img);
				
				// 이미지 파일 업로드
	            dto.setImgFileName(imgFileName);
	            dto.setImgInputStream(imgInputStream);
				
	            System.out.println("ProductController/save/dto : " + dto);
	            
				int result = productService.제품등록(dto);
				
				if(result == 1) {	// 정상 입력 완료
					response.sendRedirect("index.jsp");
				}else {					// 정상 입력 실패
					Script.back(response, "상품 등록 실패");
				}
				
			}
	}
}