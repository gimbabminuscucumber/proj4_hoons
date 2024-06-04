package com.cos.blog.domain.buy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderSheet {
	private int id;			// orderSheet 테이블의 id
	private int userId;
	private int productId;
	
	private int totalCount;
	private int totalPrice;
	
	private String img;
	private String brand;
	private String content;
	private int price;
}
