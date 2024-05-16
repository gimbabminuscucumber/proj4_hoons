package com.cos.blog.domain.product;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.cos.blog.config.DB;
import com.cos.blog.domain.product.dto.SaveReqDto;

public class ProductDao {

	public int save(SaveReqDto dto) {			// 제품 작성

		// 이미지 파일 경로 저장
		String imagePath = uploadImage(dto.getImgInputStream(), dto.getImgFileName());
		if(imagePath == null) {
			System.out.println("ProductDao/save/imagePath : "  + imagePath);
			return -1;	// 이미지 업로드 실패 시 처리
		}
		
		String sql = "INSERT INTO product(userId, price, categoryId, weight, name, img, content, createDate) VALUES(?,?,?,?,?,?,?, now())";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getUserId());
			pstmt.setInt(2, dto.getPrice());
			pstmt.setInt(3, dto.getCategoryId());
			pstmt.setString(4, dto.getWeight());
			pstmt.setString(5, dto.getName());
			pstmt.setString(6, imagePath);		// 이미지 경로 저장
//			pstmt.setString(6, dto.getImg());	// 
			pstmt.setString(7, dto.getContent());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}
	
	
	// 이미지 파일 업로드 및 경로 변환 메소드
	public String uploadImage(InputStream fileInputStream, String fileName) {
		String uploadPath = "/Users/gimdong-eun/Desktop/STS/Workspace2_JSP/project4/src/main/webapp/images/productImg/";		// 업로드한 이미지 파일을 저장할 위치
		Path path = Paths.get(uploadPath + fileName);

		try {
			Files.copy(fileInputStream, path);
		}catch(Exception e) {
			e.printStackTrace();
			return null;
		}
		return uploadPath + fileName;
	}
	
	
	// 페이징 처리
	public int count() {
		String sql = "SELECT count(*) FROM product";	
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();				// rs : 위에서 select 한 결과를 담고 있음
			if(rs.next()) {
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally { 
			DB.close(conn, pstmt, rs);
		}
 		return -1; 
	}

	// 페이징 처리 (search가 추가된 페이지) - 오버로딩 
	public int count(String keyword) {
		String sql = "SELECT count(*) FROM product WHERE name LIKE ?";	
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			rs = pstmt.executeQuery();				// rs : 위에서 select 한 결과를 담고 있음
		
			if(rs.next()) {
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally { 
			DB.close(conn, pstmt, rs);
		}
 		return -1; 
	}
	

	
}
