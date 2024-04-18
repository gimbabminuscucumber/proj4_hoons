package com.cos.blog.domain.user.dto;

import lombok.Data;

@Data
public class JoinReqDto {			// = Data Transfer Object : 계층 간 데이터 전송을 위해 도메인 모델 대신 사용되는 객체
													// RequestDto : 여러 테이블을 조인해서 요청할 때 사용
	private String username;
	private String password;
	private String email;
	private String address;
}
