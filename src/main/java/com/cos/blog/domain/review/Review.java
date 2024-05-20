package com.cos.blog.domain.review;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Review {
	private int reviewId;
	private int userId;
	private int productId;
	private String content;
	private String img;
	private Timestamp createDate;
}
