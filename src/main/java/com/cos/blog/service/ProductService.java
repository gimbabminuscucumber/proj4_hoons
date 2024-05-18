package com.cos.blog.service;

import java.io.IOException;
import java.util.List;

import com.cos.blog.domain.product.ProductDao;
import com.cos.blog.domain.product.dto.DetailRespDto;
import com.cos.blog.domain.product.dto.SaveReqDto;

public class ProductService {

	private ProductDao productDao;
	
	public ProductService() {
		productDao = new ProductDao();
	}
	
	public int 제품등록(SaveReqDto dto) throws IOException  {
		System.out.println("ProductService/제품등록/dto : " + dto);		// ProductDao에서 저장성공시 1 / 실패시 -1
		return productDao.save(dto);
	}

	/*
	public List<DetailRespDto> 상품목록(int page) {
		return productDao.findAll(page);
	}
	 */
	public List<DetailRespDto> 상품목록() {
		return productDao.findAll();
	}
	public int 상품개수() {
		return productDao.count();
	}

	public int 상품삭제(int id) {
		return productDao.deleteById(id);
	}

	public DetailRespDto 상품상세보기(int id) {
		return productDao.findById(id);
	}

	public int 제품구매(int productId, int quantity) {
	    return productDao.updateProductCount(productId, quantity);
	}


}
