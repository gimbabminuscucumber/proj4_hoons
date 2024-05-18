package com.cos.blog.domain.product.dto;

import java.io.InputStream;
import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DetailRespDto {
	private int id;
	private int userId;
	private int price;
	private int categoryId;
	private String weight;
	private String name;
	private String content;
	private Timestamp createDate;
	private int count;
	private String img;
    
    
	// 상품 등록 시, 상품명(name)에 <script> 코드 방어
	// - lucy filter로도 방어 가능 (더 궁극적임)
	// - lucy filter 사용시 라이브러리 필요
	public String getName() {
		return name.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}
    
}
