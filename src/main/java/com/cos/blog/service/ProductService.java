package com.cos.blog.service;

import com.cos.blog.domain.product.ProductDao;
import com.cos.blog.domain.product.dto.SaveReqDto;

public class ProductService {

	private ProductDao productDao;
	
	public ProductService() {
		productDao = new ProductDao();
	}
	
	public int 제품등록(SaveReqDto dto) {
		System.out.println("ProductService/제품등록/dto : " + dto);		// ProductDao에서 저장성공시 1 / 실패시 -1
		return productDao.save(dto);
	}



}
