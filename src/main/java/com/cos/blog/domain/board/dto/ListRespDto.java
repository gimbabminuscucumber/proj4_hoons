package com.cos.blog.domain.board.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// detail 에서 사용될 Board 테이블과 User 테이블이 조인된 변수들
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class ListRespDto {		// 전체 게시글 목록에 사용 (댓글 카운팅 적용시키기)
	private int id;
	private String title;
	private String content;
	private int readCount;	
	private Timestamp createDate;
	private int category;						// Board 테이블 ↑
	private String username;				// User 테이블 데이터 ↓
	private int userId;
	private int replyId;						// Reply 테이블 데이터 ↓
	private int count;	
	
	// 게시글 작성시, 제목(title)에 <script> 코드 방어
	// - lucy filter로도 방어 가능 (더 궁극적임)
	// - lucy filter 사용시 라이브러리 필요
	public String getTitle() {
		return title.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}
}
