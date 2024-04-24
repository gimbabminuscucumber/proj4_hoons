package com.cos.blog.domain.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.cos.blog.config.DB;
import com.cos.blog.domain.user.dto.JoinReqDto;
import com.cos.blog.domain.user.dto.LoginReqDto;

public class UserDao {
	
	public int save(JoinReqDto dto) {		// 회원가입
		String sql = "INSERT INTO user(username, password, email, address, userRole, createDate) VALUES(?,?,?,?,'USER', now())";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getPassword());
			pstmt.setString(3, dto.getEmail());
			pstmt.setString(4, dto.getAddress());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}
	
	public User findByUsernameAndPassword(LoginReqDto dto) {		// 로그인
		String sql = "SELECT id, username, email, address FROM user WHERE username =? AND password =?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getPassword());
			rs = pstmt.executeQuery();				// rs : 위에서 select 한 결과를 담고 있음
			
			if(rs.next()) {
				User user = User.builder()
						.id(rs.getInt("id"))
						.username(rs.getString("username"))
						.email(rs.getString("email"))
						.address(rs.getString("address"))
						.build();
				return user;		// session이 정상이면, user 오브젝트를 만들어서 리턴
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		
		return null;
	}

	public int findByUsername(String username) {		// 유저네임 중복 체크
		String sql = "SELECT * FROM user WHERE username =?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, username);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;		// DB에 해당 유저네임이 있다
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		
		return -1;			// DB에 해당 유저네임이 없다
	}

	public void update() {	// 회원수정
		
	}
	
	public void usernameCheck() {	// 아이디 중복 체크
		
	}
	
	public void findById() {		// 회원 정보 보기
		
	}

}
