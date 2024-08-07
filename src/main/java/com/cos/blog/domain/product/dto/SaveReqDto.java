package com.cos.blog.domain.product.dto;

import java.io.InputStream;

import lombok.Data;

@Data
public class SaveReqDto {
	private int id;
	private int userId;
	private int price;
	private int categoryId;
	private String brand;
	private String content;
	private String weight;
		
	// img
    private InputStream imgInputStream;
    private String imgFileName;
	// explanation
    private InputStream explainInputStream;
    private String explainFileName;
    
}
