package com.cos.blog.domain.board.dto;

import java.sql.Timestamp;

import lombok.Data;

// detail 에서 사용될 Board 테이블과 User 테이블이 조인된 변수들
@Data
public class ListRespDto {
	private int id;
	private String title;
	private String content;
	private int readCount;	
	private Timestamp createDate;
	private String username;
	private int userId;
	
	// 게시글 작성시, 제목(title)에 <script> 코드 방어
	// - lucy filter로도 방어 가능 (더 궁극적임)
	// - lucy filter 사용시 라이브러리 필요
	public String getTitle() {
		return title.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}
}
