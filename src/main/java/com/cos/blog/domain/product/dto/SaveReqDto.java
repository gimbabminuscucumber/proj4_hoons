package com.cos.blog.domain.product.dto;

import java.io.InputStream;

import lombok.Data;

@Data
public class SaveReqDto {
	private int userId;
	private int price;
	private int categoryId;
	private String weight;
	private String name;
//	private String img;
	private String content;
		
    private InputStream imgInputStream;
    private String imgFileName;
	
}
