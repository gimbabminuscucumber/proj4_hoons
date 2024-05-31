package com.cos.blog.domain.review.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReviewReqDto {
	private int buyId;
	private int productId;
	private int userId;

	private int score;				// 별점 
	private String text;			// 내용
	private int status;				// 리뷰 작성 여부
	private Timestamp createDate;
	
}
