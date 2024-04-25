package com.cos.blog.domain.board.dto;

import lombok.Data;

@Data
public class CommonRespDto<T> {
	private int statusCode;		// 정상 : 1 / 실패 : -1
	private T data;
}
