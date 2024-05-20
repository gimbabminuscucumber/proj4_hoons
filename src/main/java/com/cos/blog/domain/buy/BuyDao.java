package com.cos.blog.domain.buy;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.cos.blog.config.DB;
import com.cos.blog.domain.buy.dto.BuyReqDto;

public class BuyDao {

	public int buy(BuyReqDto dto) {
		String sql = "INSERT INTO buy(userId, productId, totalPrice, totalCount, orderNum, createDate) VALUES(?,?,?,?,?,now())";
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DB.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getUserId());
			pstmt.setInt(2, dto.getProductId());
			pstmt.setInt(3, dto.getTotalPrice());
			pstmt.setInt(4, dto.getTotalCount());
			pstmt.setString(5, dto.getOrderNum());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

}
