package com.cos.blog.domain.buy.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class BuyFormReqDto {
	private int userId;				// 구매자
	private int productId;		// 구매 제품
	
	// user 테이블
	private String nickName;
	private String address;
	private String phone;
	
	// product 테이블
	private String brand;
	private String content;
	private String weight;
	private String img;
	
	// buy 테이블
	private int totalPrice;		// 총 구매 금액
	private int totalCount;		// 총 구매 개수
}
