package com.cos.blog.domain.buy.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderSheetReqDto {
	private int id;			// orderSheet 테이블의 id
	private int userId;
	private int productId;

	// buy 테이블
	private int totalCount;
	private int totalPrice;

	// product 테이블
	private String img;
	private String brand;
	private String content;
	private int price;
	
	
}
