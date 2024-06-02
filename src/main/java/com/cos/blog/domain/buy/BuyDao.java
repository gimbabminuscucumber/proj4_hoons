package com.cos.blog.domain.buy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cos.blog.config.DB;
import com.cos.blog.domain.board.dto.SaveReqDto;
import com.cos.blog.domain.buy.dto.BasketReqDto;
import com.cos.blog.domain.buy.dto.BuyFormReqDto;
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderReqDto;
import com.cos.blog.domain.review.dto.InfoRespDto;
import com.cos.blog.domain.review.dto.ReviewReqDto;
import com.cos.blog.domain.user.User;

public class BuyDao {

	// 상품 구매
	public int buy(BuyReqDto dto) {
		String sql = "INSERT INTO buy(userId, productId, totalPrice, totalCount, orderNum, createDate) VALUES(?,?,?,?,?,now())";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		// 추가
		
		try {
			conn = DB.getConnection();
			pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);	// sql 실행 후, 생성된 id 값 반환 >> 구매성공 후, 구매완료 페이지에 buy의 id값을 가져가기 위해 사용
			pstmt.setInt(1, dto.getUserId());
			pstmt.setInt(2, dto.getProductId());
			pstmt.setInt(3, dto.getTotalPrice());
			pstmt.setInt(4, dto.getTotalCount());
			pstmt.setString(5, dto.getOrderNum());
			int result = pstmt.executeUpdate();

			// 추가
			if(result == 1) {
				rs = pstmt.getGeneratedKeys();		// 생성된 id 값 반환
				if(rs.next()) {
					return rs.getInt(1);		// 생성된 id 리턴		// 수정 전
				}
			}
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

	// 주문 완료 (buy, user, product 테이블 조인)
	public List<OrderReqDto> findByOrder(int userId, int productId) {
	    List<OrderReqDto> orders = new ArrayList<>();
	    String sql = "SELECT * FROM buy b INNER JOIN user u ON b.userId = u.id INNER JOIN product p ON b.productId = p.id WHERE u.id =? AND p.id = ?";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = DB.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, userId);
	        pstmt.setInt(2, productId);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            OrderReqDto dto = OrderReqDto.builder()
	                    .id(rs.getInt("b.id"))
	                    .userId(rs.getInt("b.userId"))
	                    .productId(rs.getInt("b.productId"))
	                    .orderNum(rs.getString("b.orderNum"))
	                    .totalCount(rs.getInt("b.totalCount"))
	                    .totalPrice(rs.getInt("b.totalPrice"))
	                    .state(rs.getInt("b.state"))
	                    .createDate(rs.getTimestamp("b.createDate"))
	                    .nickName(rs.getString("u.nickName"))
	                    .email(rs.getString("u.email"))
	                    .address(rs.getString("u.address"))
	                    .phone(rs.getString("u.phone"))
	                    .brand(rs.getString("p.brand"))
	                    .img(rs.getString("p.img"))
	                    .content(rs.getString("p.content"))
	                    .build();
	            orders.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DB.close(conn, pstmt, rs);
	    }
	    return orders;
	}
	
	// 주문 내역
	public List<OrderReqDto> findByOrderList(int userId) {
		String sql = "SELECT * FROM buy b INNER JOIN user u ON b.userId = u.id INNER JOIN product p ON b.productId = p.id LEFT JOIN review r ON b.id = r.buyId WHERE b.userId = ? ORDER BY b.id DESC";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		List<OrderReqDto> orders = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();		// 실행한 SQL 쿼리의 결과를 pstmt를 통해 rs에 할당
			
			while(rs.next()){
				OrderReqDto dto = OrderReqDto.builder()
						.id(rs.getInt("b.id"))
						.userId(rs.getInt("b.userId"))
						.productId(rs.getInt("b.productId"))
						.orderNum(rs.getString("b.orderNum"))
						.totalCount(rs.getInt("b.totalCount"))
						.totalPrice(rs.getInt("b.totalPrice"))
						.state(rs.getInt("b.state"))
						.createDate(rs.getTimestamp("b.createDate"))
						.nickName(rs.getString("u.nickName"))
						.email(rs.getString("u.email"))
						.address(rs.getString("u.address"))
						.phone(rs.getString("u.phone"))
						.brand(rs.getString("p.brand"))
						.img(rs.getString("p.img"))
						.content(rs.getString("p.content"))
						.status(rs.getInt("r.status"))
						.build();
					orders.add(dto);
			}
			return orders;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 주문 상세
	public List<OrderReqDto> findByOrderDetail(String orderNum) {
		String sql = "SELECT * FROM buy b INNER JOIN user u ON b.userId = u.id INNER JOIN product p ON b.productId = p.id WHERE b.orderNum = ? ORDER BY b.id DESC";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<OrderReqDto> details = new ArrayList<>();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, orderNum);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				OrderReqDto dto = OrderReqDto.builder()
						.id(rs.getInt("b.id"))
						.userId(rs.getInt("b.userId"))
						.productId(rs.getInt("b.productId"))
						.orderNum(rs.getString("b.orderNum"))
						.totalCount(rs.getInt("b.totalCount"))
						.totalPrice(rs.getInt("b.totalPrice"))
						.state(rs.getInt("b.state"))
						.createDate(rs.getTimestamp("b.createDate"))
						.nickName(rs.getString("u.nickName"))
						.email(rs.getString("u.email"))
						.address(rs.getString("u.address"))
						.phone(rs.getString("u.phone"))
						.brand(rs.getString("p.brand"))
						.img(rs.getString("p.img"))
						.content(rs.getString("p.content"))
						.build();
					details.add(dto);
			}
			return details;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 구매자 정보
	public OrderReqDto findByBuyer(String orderNum) {
		String sql = "SELECT * FROM buy b INNER JOIN user u ON b.userId = u.id INNER JOIN product p ON b.productId = p.id WHERE b.orderNum = ? ORDER BY b.id DESC";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		OrderReqDto dto = new OrderReqDto();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, orderNum);
			rs = pstmt.executeQuery();	
			
			if(rs.next()){
				dto.setId(rs.getInt("b.id"));
				dto.setUserId(rs.getInt("b.userId"));
				dto.setProductId(rs.getInt("b.productId"));
				dto.setOrderNum(rs.getString("b.orderNum"));
				dto.setTotalCount(rs.getInt("b.totalCount"));
				dto.setTotalPrice(rs.getInt("b.totalPrice"));
				dto.setState(rs.getInt("b.state"));
				dto.setCreateDate(rs.getTimestamp("b.createDate"));
				dto.setNickName(rs.getString("u.nickName"));
				dto.setEmail(rs.getString("u.email"));
				dto.setPhone(rs.getString("u.phone"));
				dto.setAddress(rs.getString("u.address"));
				dto.setBrand(rs.getString("p.brand"));
				dto.setImg(rs.getString("p.img"));
				dto.setContent(rs.getString("p.content"));
				return dto;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	// 장바구니 담기
	public int basket(BasketReqDto dto) {
	    String sql = "INSERT INTO basket (userId, productId, totalCount, totalPrice, img, brand, content, price, createDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, now())";
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = DB.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, dto.getUserId());
	        pstmt.setInt(2, dto.getProductId());
	        pstmt.setInt(3, dto.getTotalCount());
	        pstmt.setInt(4, dto.getTotalPrice());
	        pstmt.setString(5, dto.getImg());
	        pstmt.setString(6, dto.getBrand());
	        pstmt.setString(7, dto.getContent());
	        pstmt.setInt(8, dto.getPrice());
	        int result = pstmt.executeUpdate();
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DB.close(conn, pstmt);
	    }
	    return -1;
	}

	// 장바구니 조회
	public List<BasketReqDto> basketList(int userId) {
		String sql = "SELECT * FROM basket WHERE userId = ? ORDER BY createDate DESC" ;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    List<BasketReqDto> baskets = new ArrayList<>();

	    try {
	        conn = DB.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, userId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            BasketReqDto dto = BasketReqDto.builder()
	                .id(rs.getInt("id"))
	                .userId(rs.getInt("userId"))
	                .productId(rs.getInt("productId"))
	                .totalCount(rs.getInt("totalCount"))
	                .totalPrice(rs.getInt("totalPrice"))
	                .img(rs.getString("img"))
	                .brand(rs.getString("brand"))
	                .content(rs.getString("content"))
	                .price(rs.getInt("price"))
	                .build();
	            baskets.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DB.close(conn, pstmt, rs);
	    }
	    return baskets;
	}

	// 주문서 작성
	public OrderReqDto buyForm(int productId, int userId) {
		String sql = "SELECT * FROM basket b INNER JOIN user u ON b.userId = u.id WHERE b.productId = ? AND u.id = ?";
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    OrderReqDto dto = null;
	
	    try {
	        conn = DB.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, productId);
	        pstmt.setInt(2, userId);
	        rs = pstmt.executeQuery();
	
	        if (rs.next()) {
	        	dto = OrderReqDto.builder()
	                .productId(rs.getInt("productId"))
	                .userId(rs.getInt("userId"))
	                .totalCount(rs.getInt("totalCount"))
	                .totalPrice(rs.getInt("totalPrice"))
	                .img(rs.getString("img"))
	                .brand(rs.getString("brand"))
	                .content(rs.getString("content"))
	                .nickName(rs.getString("nickName"))
	                .email(rs.getString("email"))
	                .address(rs.getString("address"))
	                .phone(rs.getString("phone"))
	                .price(rs.getInt("price"))
	                .build();
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DB.close(conn, pstmt, rs);
	    }
	    return dto;
	}

	// 장바구니를 통해 구매한 상품은 구매완료 후, 장바구니에서 상품 목록 삭제하기
	public int basketDelete(int userId, int productId) {
	    String sql = "DELETE FROM basket WHERE userId = ? AND productId = ?";
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        conn = DB.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, userId);
	        pstmt.setInt(2, productId);
	        int result = pstmt.executeUpdate();
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DB.close(conn, pstmt);
	    }
	    return -1;
	}

	// 리뷰 작성 페이지에 데이터 가져가기
	public OrderReqDto findByProduct(int id) {
		String sql = "SELECT * FROM buy b INNER JOIN product p ON b.productId = p.id WHERE b.id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    OrderReqDto dto = null;
	    
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = OrderReqDto.builder()
						.id(rs.getInt("id"))
						.productId(rs.getInt("productId"))
		                .userId(rs.getInt("userId"))
		                .totalCount(rs.getInt("totalCount"))
		                .totalPrice(rs.getInt("totalPrice"))
		                .img(rs.getString("img"))
		                .brand(rs.getString("brand"))
		                .content(rs.getString("content"))
		                .price(rs.getInt("price"))
		                .build();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return dto;
	}

	// 리뷰 저장
	public int review(ReviewReqDto dto) {
		String sql = "INSERT INTO review(userId, buyId, productId, score, text, status, createDate) VALUES(?,?,?,?,?,1,now())";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getUserId());
			pstmt.setInt(2, dto.getBuyId());
			pstmt.setInt(3, dto.getProductId());
			pstmt.setInt(4, dto.getScore());
			pstmt.setString(5, dto.getText());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

	// 리뷰 정보 (제품 상세 페이지에서 출력하려고)
	public List<InfoRespDto> findByReview(int id) {		// id = productId
		String sql = "SELECT * FROM review r INNER JOIN user u ON r.userId = u.id WHERE r.productId = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<InfoRespDto> reviews = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				InfoRespDto dto = InfoRespDto.builder()	
						.buyId(rs.getInt("r.id"))
						.productId(rs.getInt("r.productId"))
						.userId(rs.getInt("r.userId"))
						.score(rs.getInt("r.score"))
						.text(rs.getString("r.text"))
						.status(rs.getInt("r.status"))
						.createDate(rs.getTimestamp("r.createDate"))
						.nickName(rs.getString("u.nickName"))
						.build();
				reviews.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return reviews;
	}
	
	
}
