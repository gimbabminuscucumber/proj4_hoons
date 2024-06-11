package com.cos.blog.domain.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cos.blog.config.DB;
import com.cos.blog.domain.user.dto.JoinReqDto;
import com.cos.blog.domain.user.dto.LogReqDto;
import com.cos.blog.domain.user.dto.LoginReqDto;
import com.cos.blog.domain.user.dto.PasswordReqDto;

public class UserDao {
	
	// 회원가입
	public int save(JoinReqDto dto) {		
		System.out.println("UserDao/save/dto : " + dto);
		System.out.println("UserDao/save/dto.getEmail() : " + dto.getEmail());
		
		String sql = "INSERT INTO user(username, nickName, password, phone, email, address, userRole, createDate) VALUES(?,?,?,?,?,?,'USER', now())";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getNickName());
			pstmt.setString(3, dto.getPassword());
			pstmt.setString(4, dto.getPhone());
			pstmt.setString(5, dto.getEmail());
			pstmt.setString(6, dto.getAddress());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}
	
	// 로그인
	public User findByUsernameAndPassword(LoginReqDto dto) {		
		String sql = "SELECT * FROM user WHERE username =? AND password =?";
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
						.nickName(rs.getString("nickName"))
						.phone(rs.getString("phone"))
						.email(rs.getString("email"))
						.address(rs.getString("address"))
						.userRole(rs.getString("userRole"))
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

	// 유저네임 중복 체크
	public int findByUsername(String username) {		
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

	// 유저 찾기
	public User findById(int id) {	
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
				user.setNickName(rs.getString("nickName"));
				user.setPassword(rs.getString("password"));
				user.setPhone(rs.getString("phone"));
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

	// 회원정보 수정
	public int update(User user) {	
		String sql = "UPDATE user SET nickName =?, password =?, phone =?, email =?, address =? WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getNickName());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(3, user.getPhone());
			pstmt.setString(4, user.getEmail());
			pstmt.setString(5, user.getAddress());
			pstmt.setInt(6, user.getId());
			
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

	// 아이디 찾기 2 - 이메일로 아이디 찾기
	public int findByEmail(String email) {	
		String sql = "SELECT username FROM user WHERE email = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;						// 확인한 email이 DB에 있을 때 (중복 되면)
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return -1;							// 확인한 email이 DB에 없을 때 (중복 안 되면)
	}

	// 아이디 찾기 1 - 이메일로 유저정보 가져오기
	public User userInfo(String email) {			
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
				user.setUsername(rs.getString("nickName"));
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

	// 비밀번호 찾기 - 유저네임과 이메일로 유저정보 가져오기2
	public User userInfo2(PasswordReqDto dto) {		
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
				user.setNickName(rs.getString("nickName"));
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

	// 로그인 처리 1 - 유저네임 확인 (미사용)
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

	// 로그인 처리 2 - 유저네임과 비밀번호 확인 (미사용)
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

	// 로그인 처리 - 유저네임과 비밀번호 일치 여부
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

	// 닉네임 중복 확인
	public int findByNickName(String nickName) {
		String sql = "SELECT nickName FROM user WHERE nickName = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nickName);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return -1;	// 중복 아님
	}

	// 연락처 중복확인
	public int findByPhone(String phone) {
		String sql = "SELECT phone FROM user WHERE phone = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, phone);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return 1;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return -1;	// 중복 아님
	}

	// 유저 관리 (관리자 전용)
	public List<User> findByManage(int page) {
		String sql = "SELECT * FROM user ORDER BY id ASC LIMIT ?, 10";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<User> users = new ArrayList<>();
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, page*10);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				User dto = User.builder()
						.id(rs.getInt("id"))
						.username(rs.getString("username"))
						.nickName(rs.getString("nickName"))
						.email(rs.getString("email"))
						.address(rs.getString("address"))
						.phone(rs.getString("phone"))
						.userRole(rs.getString("userRole"))
						.createDate(rs.getTimestamp("createDate"))
						.build();
				users.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return users;
	}

	// 유저관리 검색목록 (관리자 전용)
	public List<User> findByKeyword(String keyword, int page) {
		String sql = "SELECT * FROM user WHERE nickName LIKE ? OR username LIKE ? OR email LIKE ? ORDER BY id ASC LIMIT ?, 10";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<User> users = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			pstmt.setString(2, "%"+keyword+"%");
			pstmt.setString(3, "%"+keyword+"%");
			pstmt.setInt(4, page*10);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				User dto = User.builder()
						.id(rs.getInt("id"))
						.username(rs.getString("username"))
						.nickName(rs.getString("nickName"))
						.email(rs.getString("email"))
						.address(rs.getString("address"))
						.phone(rs.getString("phone"))
						.userRole(rs.getString("userRole"))
						.createDate(rs.getTimestamp("createDate"))
						.build();
				users.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return users;
	}

	// 회원수
	public int userCount() {
		String sql = "SELECT count(*) FROM user";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt,rs);
		}
		return -1;
	}

	// 회원수 오버로딩
	public int userCount(String keyword) {
		String sql = "SELECT count(*) FROM user WHERE nickName LIKE ? OR username LIKE ? OR email LIKE ? ";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			pstmt.setString(2, "%"+keyword+"%");
			pstmt.setString(3, "%"+keyword+"%");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt,rs);
		}
		return -1;
	}



	
}
