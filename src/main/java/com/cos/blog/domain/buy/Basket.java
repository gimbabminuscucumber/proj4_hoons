package com.cos.blog.domain.buy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Basket {
	private int id;
	private int userId;
	private int productId;
	private int totalCount;
	private int totalPrice;
	private String img;
	private String brand;
	private String content;
	private int price;
}
