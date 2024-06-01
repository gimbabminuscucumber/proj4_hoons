package com.cos.blog.domain.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cos.blog.config.DB;
import com.cos.blog.domain.board.dto.DetailRespDto;
import com.cos.blog.domain.board.dto.SaveReqDto;
import com.cos.blog.domain.board.dto.UpdateReqDto;

public class BoardDao {

	public int save(SaveReqDto dto) {			// 게시글 작성
		String sql = "INSERT INTO board(userId, title, content, createDate, category) VALUES(?,?,?, now(), ?)";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getUserId());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setInt(4, dto.getCategory());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}
	
	/*
	public int save(SaveReqDto dto) {			// 게시글 작성
		String sql = "INSERT INTO board(userId, title, content, createDate) VALUES(?,?,?, now())";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getUserId());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}
	*/
	// 페이징 처리 (list 페이지) 
	public int count() {
		String sql = "SELECT count(*) FROM board";	
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
		String sql = "SELECT count(*) FROM board WHERE title LIKE ? OR content LIKE ?";	
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			pstmt.setString(2, "%"+keyword+"%");
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
	

	public DetailRespDto findById(int id) {		// 게시글 상세보기
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM board b INNER JOIN user u ON b.userId = u.id WHERE b.id = ?;");
		
		String sql = sb.toString(); 
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);				// 쿼리스트링의 물음표에 들어갈 데이터
			rs = pstmt.executeQuery();	
			
			if(rs.next()) {					
				DetailRespDto dto	= new DetailRespDto();
				dto.setId(rs.getInt("b.id"));
				dto.setTitle(rs.getString("b.title"));
				dto.setContent(rs.getString("b.content"));
				dto.setReadCount(rs.getInt("b.readCount"));
				dto.setCreateDate(rs.getTimestamp("b.createDate"));
				dto.setUsername(rs.getString("u.username"));
				dto.setUserId(rs.getInt("b.userId"));
				dto.setCategory(rs.getInt("b.category"));
				return dto;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}


	// Board 테이블 + User 테이블 = 조인된 데이터
	public List<DetailRespDto> findAll(int page) {		// 게시글 목록 + 페이지 처리
		String sql = "SELECT * FROM board b INNER JOIN user u ON b.userId = u.id ORDER BY b.id DESC LIMIT ?, 5";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		List<DetailRespDto> boards = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, page*5);					// page 당 보여질 게시글이 4개씩이라서 *4 를 연산
			rs = pstmt.executeQuery();				// rs : 위에서 select 한 결과를 담고 있음
			
			while(rs.next()) {								// 커서를 이동하는 함수 (board에 데이터가 한 행씩 담기면 커서가 이동해서 그 다음 행의 데이터를 담음)
				DetailRespDto dto = DetailRespDto.builder()
						.id(rs.getInt("b.id"))
						.title(rs.getString("b.title"))
						.content(rs.getString("b.content"))
						.readCount(rs.getInt("b.readCount"))
						.userId(rs.getInt("b.userId"))
						.createDate(rs.getTimestamp("b.createDate"))
						.category(rs.getInt("b.category"))
						.username(rs.getString("u.username"))
						.build();
				boards.add(dto);						// select 된 데이터를 한 행씩 읽어서 board에 담음
			}
			return boards;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	public int deleteById(int id) {
		String sql = "DELETE FROM board WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			int result = pstmt.executeUpdate();		// executeUpdate() : 수정된 행의 개수 리턴
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

	public int updateReadCount(int id) {		// 조회수 증가
		String sql = "UPDATE board SET readCount = readCount +1 WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			int result = pstmt.executeUpdate();
			return result; 
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}
	
	public int update(UpdateReqDto dto) {
		String sql = "UPDATE board SET title = ?, content = ?, category =? WHERE id = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getCategory());
			pstmt.setInt(4, dto.getId());
			int result = pstmt.executeUpdate();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

	//public DetailRespDto findByKeyword(String keyword, int page) {
	public List<DetailRespDto> findByKeyword(String keyword, int page) {
		String sql = "SELECT * FROM board b INNER JOIN user u ON b.userId = u.id WHERE b.title LIKE ? OR b.content LIKE ? ORDER BY b.id DESC LIMIT ?, 5";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		List<DetailRespDto> boards = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			pstmt.setString(2, "%"+keyword+"%");		// b.content의 물음표도 써야함
			pstmt.setInt(3, page*5);					// page 당 보여질 게시글이 4개씩이라서 *4 를 연산
			rs = pstmt.executeQuery();				// rs : 위에서 select 한 결과를 담고 있음
			
			while(rs.next()) {								// 커서를 이동하는 함수 (board에 데이터가 한 행씩 담기면 커서가 이동해서 그 다음 행의 데이터를 담음)
				DetailRespDto dto = DetailRespDto.builder()
						.id(rs.getInt("b.id"))
						.title(rs.getString("b.title"))
						.content(rs.getString("b.content"))
						.readCount(rs.getInt("b.readCount"))
						.userId(rs.getInt("b.userId"))
						.createDate(rs.getTimestamp("b.createDate"))
						.username(rs.getString("u.username"))
						.build();
				boards.add(dto);							// select 된 데이터를 한 행씩 읽어서 board에 담음
			}
			return boards;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}
		
	
	/*
	 * Board 테이블 (User 데이터가 조인 안됨)
	public List<Board> findAll(int page) {		// 게시글 목록 + 페이지 처리
//		String sql = "SELECT * FROM board ORDER BY id DESC LIMIT ?, 4";	// Limit : 데이터 개수가 0 <= x < 4 까지만 보임
		String sql = "SELECT * FROM board b INNER JOIN user u ON b.userId = u.id ORDER BY b.id DESC LIMIT ?, 4";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;		// PreparedStatement 사용하는 이유 : 외부로 부터 오는 injection 공격을 막기 위해
		ResultSet rs = null;
		List<Board> boards = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, page*4);					// page 당 보여질 게시글이 4개씩이라서 *4 를 연산
			rs = pstmt.executeQuery();				// rs : 위에서 select 한 결과를 담고 있음
			
			while(rs.next()) {								// 커서를 이동하는 함수 (board에 데이터가 한 행씩 담기면 커서가 이동해서 그 다음 행의 데이터를 담음)
				Board board = Board.builder()
						.id(rs.getInt("id"))
						.title(rs.getString("title"))
						.content(rs.getString("content"))
						.readCount(rs.getInt("readCount"))
						.userId(rs.getInt("userId"))
						.createDate(rs.getTimestamp("createDate"))
						.build();
				boards.add(board);						// select 된 데이터를 한 행씩 읽어서 board에 담음
			}
			return boards;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		
		return null;
	}
	 */

	
}