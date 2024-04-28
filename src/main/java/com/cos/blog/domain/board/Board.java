package com.cos.blog.domain.board;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Board {
	private int id;
	private int userId;
	private String title;
	private String content;
	private int readCount;			// 조회수 디폴트값 0
	private Timestamp createDate;
	private int category;			// 추가
	
	// 게시글 작성시, 제목(title)에 <script> 코드 방어
	// - lucy filter로도 방어 가능 (더 궁극적임)
	// - lucy filter 사용시 라이브러리 필요
	public String getTitle() {
		return title.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}
	
}
