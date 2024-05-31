package com.cos.blog.domain.buy.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class OrderReqDto {
	private int id;					// buy 테이블의 id
	private int userId;			// 구매자
	private int productId;	// 구매 제품
	private int totalPrice;	// 총 구매 금액
	private int totalCount;	// 총 구매 개수
	private String orderNum;	// 구매 번호
	private String state;		// 주문 상태	(주문확인/배송중/배송완료/교환 신청완료 ... 무신사 참조)
	private Timestamp createDate;	// 구매 일자
	
	// user 테이블
	private String nickName;
	private String email;
	private String address;
	private String phone;

	// product 테이블
	private String brand;
	private String img;
	private String content;
	private int price;
	
	// review 테이블
	private int status;		// 추가
	
}
