package com.cos.blog.domain.buy.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class BuyReqDto {
	private int buyId;
	private int userId;			// 구매자
	private int productId;	// 구매 제품
	private int totalPrice;	// 총 구매 금액
	private int totalCount;	// 총 구매 개수
	private int state;			// 주문 상태 (default 0)
	private String orderNum;	// 구매 번호
	private Timestamp createDate;	// 구매 일자
}
