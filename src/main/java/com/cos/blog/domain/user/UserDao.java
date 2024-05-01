package com.cos.blog.domain.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cos.blog.config.DB;
import com.cos.blog.domain.user.dto.JoinReqDto;
import com.cos.blog.domain.user.dto.LogReqDto;
import com.cos.blog.domain.user.dto.LoginReqDto;
import com.cos.blog.domain.user.dto.PasswordReqDto;

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

	public User findById(int id) {	// 유저 찾기
		String sql = "SELECT * FROM user WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;				// 외부로부터 injection 공격 방어
		ResultSet rs = null;
		User user = new User();
		
		try {
			pstmt = conn.prepareStatement(sql);	// sql문을 pstmt에 넣어 보호하기
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				user.setId(rs.getInt("id"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setEmail(rs.getString("email"));
				user.setAddress(rs.getString("address"));
			}
			return user;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;	
	}

	public int update(User user) {		// 회원정보 수정
		String sql = "UPDATE user SET password =?, email =?, address =? WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getPassword());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getAddress());
			pstmt.setInt(4, user.getId());
			
			int result = pstmt.executeUpdate();
			System.out.println("UserDao/update/result : " + result);
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			DB.close(conn, pstmt);
		}
		return -1;
	}

	public int findByEmail(String email) {		// 이메일로 아이디 찾기
		String sql = "SELECT username FROM user WHERE email = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;				// 확인한 email이 DB에 있을 때
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return -1;							// 확인한 email이 DB에 없을 떄
	}

	public User userInfo(String email) {			// 이메일로 유저정보 가져오기
		String sql = "SELECT * FROM user WHERE email = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = new User();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				user.setId(rs.getInt("id"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setEmail(rs.getString("email"));
				user.setAddress(rs.getString("address"));
			}
			return user;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public User userInfo2(PasswordReqDto dto) {		// 유저네임과 이메일로 유저정보 가져오기2
		String sql = "SELECT * FROM user WHERE username = ? AND email =?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = new User();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getEmail());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				user.setId(rs.getInt("id"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setEmail(rs.getString("email"));
				user.setAddress(rs.getString("address"));
			}
			return user;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public int findByUsernameAndEmail(PasswordReqDto dto) {
		String sql = "SELECT username FROM user WHERE username = ? AND email = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getEmail());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;				// 확인한 username과 email이 DB에 있을 때
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return -1;					// 확인한 username과 email이 DB에 없을 떄
	}

	public User findByLog(LogReqDto dto) {
		String sql = "SELECT username, password FROM user WHERE username =? AND password =?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = new User();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getPassword());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
			}
			return user;
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	public int userInfo3(LogReqDto dto) {
		String sql = "SELECT username, password FROM user WHERE username =? AND password =?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getPassword());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return -1;
	}


	
}
