package com.cos.blog.domain.product;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Product {
	private int id;
	private int userId;			
	private int price;				// 가격	
	private int categoryId;		// 카테고리		(foreign key)
	private String weight;		// 무게
	private String name;			// 이름
	private String img;			// 사진				(대용량 업로드는 어떤 자료형을 쓰나?)
	private String content;		// 설명
	private int count;				// 구매된 개수
	private Timestamp createDate;
	
	// 이름(name)에 <script> 코드 방어
	// - lucy filter로도 방어 가능 (더 궁극적임)
	// - lucy filter 사용시 라이브러리 필요
	public String getName() {
		return name.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}
	
}
