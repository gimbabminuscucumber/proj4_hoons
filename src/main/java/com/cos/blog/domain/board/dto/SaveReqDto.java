package com.cos.blog.domain.board.dto;

import lombok.Data;

@Data
public class SaveReqDto {			// = Data Transfer Object : 계층 간 데이터 전송을 위해 도메인 모델 대신 사용되는 객체
													// RequestDto : 여러 테이블을 조인해서 요청할 때 사용
	private int userId;
	private String title;
	private String content;
	private int category;		// 추가
}
