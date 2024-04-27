package com.cos.blog.domain.reply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cos.blog.config.DB;
import com.cos.blog.domain.board.dto.DetailRespDto;
import com.cos.blog.domain.reply.dto.ReplyRespDto;
import com.cos.blog.domain.reply.dto.SaveReqDto;

public class ReplyDao {
	
	public int save(SaveReqDto dto) {		// 댓글 작성
		String sql = "INSERT INTO reply(userId, boardId, content, createDate) VALUES(?,?,?, now())";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int generateKey;
		try {
			pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, dto.getUserId());
			pstmt.setInt(2, dto.getBoardId());
			pstmt.setString(3, dto.getContent());
			int result = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if(rs.next()) {
				generateKey = rs.getInt(1	);
				System.out.println("생성된 키 : " + generateKey);
				if(result == 1) {
					return generateKey;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt);
		}
		return -1;
	}

	public Reply findById(int id) {
		String sql = "SELECT * FROM reply WHERE replyId = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				Reply reply = new Reply();
				reply.setReplyId(rs.getInt("replyId"));
				reply.setUserId(rs.getInt("userId"));
				reply.setBoardId(rs.getInt("boardId"));
				reply.setContent(rs.getString("content"));
				return reply;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}

	public int deleteById(int id) {
		String sql = "DELETE FROM reply WHERE replyId = ?";
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

	
	public List<ReplyRespDto> findAll(int id) {						// 파라미터 : 게시글 id
		String sql = "SELECT * FROM reply r INNER JOIN user u ON r.userId = u.id INNER JOIN board b ON r.boardId = b.id WHERE r.boardId = ? ORDER BY r.replyId DESC";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<ReplyRespDto> replys = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ReplyRespDto dto = new ReplyRespDto();
				dto.setId(rs.getInt("r.replyId"));
				dto.setUserId(rs.getInt("r.userId"));
				dto.setBoardId(rs.getInt("r.boardId"));
				dto.setContent(rs.getString("r.content"));
				dto.setId(rs.getInt("u.id"));
				dto.setUsername(rs.getString("u.username"));
				replys.add(dto);
			}
			return replys;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}
	
	/*
	public List<Reply> findAll(int boardId) {
		String sql = "SELECT * FROM reply WHERE boardId = ? ORDER BY id DESC";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Reply> replys = new ArrayList<>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Reply reply = new Reply();
				reply.setId(rs.getInt("id"));
				reply.setUserId(rs.getInt("userId"));
				reply.setBoardId(rs.getInt("boardId"));
				reply.setContent(rs.getString("content"));
				replys.add(reply);
			}
			return replys;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DB.close(conn, pstmt, rs);
		}
		return null;
	}
	*/

	public int updateCount(int boardId) {		// 댓글 개수
		String sql ="SELECT count(*) FROM reply r INNER JOIN user u ON r.userId = u.id WHERE boardId = ?";
		Connection conn = DB.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardId);
			rs = pstmt.executeQuery();
			
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
