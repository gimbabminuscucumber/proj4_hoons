package com.cos.blog.domain.buy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cos.blog.config.DB;
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderRespDto;

public class BuyDao {

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
					return rs.getInt(1);		// 생성된 id 리턴
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
	public OrderRespDto findByOrder(int id) {
		String sql = "SELECT * FROM buy b INNER JOIN user u ON b.userId = u.id INNER JOIN product p ON b.productId = p.id WHERE b.id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		// ResultSet : SQL 쿼리 실행 후 반환된 결과 집합
		OrderRespDto dto = new OrderRespDto();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();		// 실행한 SQL 쿼리의 결과를 pstmt를 통해 rs에 할당
			
			if(rs.next()){
				dto.setId(rs.getInt("b.id"));
				dto.setUserId(rs.getInt("b.userId"));
				dto.setProductId(rs.getInt("b.productId"));
				dto.setOrderNum(rs.getString("b.orderNum"));
				dto.setTotalCount(rs.getInt("b.totalCount"));
				dto.setTotalPrice(rs.getInt("b.totalPrice"));
				dto.setState(rs.getString("b.state"));
				dto.setCreateDate(rs.getTimestamp("b.createDate"));
				dto.setNickName(rs.getString("u.nickName"));
				dto.setEmail(rs.getString("u.email"));
				dto.setAddress(rs.getString("u.address"));
				dto.setBrand(rs.getString("p.brand"));
				dto.setImg(rs.getString("p.img"));
				dto.setContent(rs.getString("p.content"));
				return dto;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			System.out.println("BuyDao/findByOrder/dto : " + dto);
			DB.close(conn, pstmt, rs);
		}
		
		return null;
	}

	// 주문 내역
	public List<OrderRespDto> findOrderList(int userId) {
		String sql = "SELECT * FROM buy b INNER JOIN user u ON b.userId = u.id INNER JOIN product p ON b.productId = p.id WHERE b.userId = ? ORDER BY b.id DESC";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		List<OrderRespDto> orders = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();		// 실행한 SQL 쿼리의 결과를 pstmt를 통해 rs에 할당
			
			while(rs.next()){
				OrderRespDto dto = OrderRespDto.builder()
						.id(rs.getInt("b.id"))
						.userId(rs.getInt("b.userId"))
						.productId(rs.getInt("b.productId"))
						.orderNum(rs.getString("b.orderNum"))
						.totalCount(rs.getInt("b.totalCount"))
						.totalPrice(rs.getInt("b.totalPrice"))
						.state(rs.getString("b.state"))
						.createDate(rs.getTimestamp("b.createDate"))
						.nickName(rs.getString("u.nickName"))
						.email(rs.getString("u.email"))
						.address(rs.getString("u.address"))
						.brand(rs.getString("p.brand"))
						.img(rs.getString("p.img"))
						.content(rs.getString("p.content"))
						.build();
					orders.add(dto);
			}
			return orders;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			System.out.println("BuyDao/findOrderList/orders : " + orders);
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

}
