package com.cos.blog.domain.buy.dto;

import java.io.InputStream;

import lombok.Data;

@Data
public class SaveReqDto {
	private int userId;			// 구매자
	private int productId;	// 구매 제품
	private int totalPrice;
	private int totalCount;
		
	
}
