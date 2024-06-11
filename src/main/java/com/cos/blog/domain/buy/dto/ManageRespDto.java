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
public class ManageRespDto {
	private int id;						// basket테이블의 id
	private int userId;				// 유저 id
	private int productId;		// 상품 id
	private int totalPrice;		// 총 구매 금액
	private int totalCount;		// 총 구매 개수
	private int state;				// 주문 상태	(주문확인/배송중/배송완료/교환 신청완료 ... 무신사 참조)
	private String orderNum;	// 구매 번호
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
	private int categoryId;
	private int view;
	private int count;
	
	// review 테이블
	private int status;		// 추가
	private int score;
	private String text;
	
}
