package com.cos.blog.domain.board.dto;

import lombok.Data;

@Data
public class UpdateReqDto {			// 게시글 수정
	private int id;
	private int userId;
	private String title;
	private String content;
	private int category;
}
