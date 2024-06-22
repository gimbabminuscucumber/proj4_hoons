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
	
	public int 상품등록(SaveReqDto dto) throws IOException  {
		System.out.println("ProductService/상품등록/dto : " + dto);		// ProductDao에서 저장성공시 1 / 실패시 -1
		return productDao.save(dto);
	}

	/*
	public List<DetailRespDto> 상품목록(int page) {
		return productDao.findAll(page);
	}
	 */
	public List<DetailRespDto> 상품목록(int page) {
		return productDao.findAll(page);
	}
	
	public List<DetailRespDto> 키워드상품목록(String keyword, int page) {
		return productDao.findByKeyword(keyword, page);
	}
	
	public List<DetailRespDto> 카테고리상품목록(int categoryId, int page) {
		return productDao.findByCategory(categoryId, page);
	}

	public int 상품개수() {
		return productDao.count();
	}

	public int 카테고리상품개수(int categoryId) {
		return productDao.categoryCount(categoryId);
	}
	
	public int 키워드상품개수(String keyword) {
		return productDao.keywordCount(keyword);
	}

	public int 상품삭제(int id) {
		return productDao.deleteById(id);
	}

	public DetailRespDto 상품상세보기(int id) {
		int result = productDao.viewUp(id);		// 상품 상세보기하면 조회수 +1
		
		if(result == 1) {
			return productDao.findById(id);
		}else {
			return null;
		}
	}

	public List<DetailRespDto> 많이본상품() {
		return productDao.findByView();
	}

	public List<DetailRespDto> 추천상품(String brand) {
		System.out.println("ProductService/추천상품/brand : " + brand);
		return productDao.findByBrand(brand);
	}

	public DetailRespDto 상품정보(int id) {
		return productDao.findById(id);
	}

	public int 상품수정(SaveReqDto dto) throws IOException {
		System.out.println("ProductService/상품수정");
		return productDao.update(dto);
	}





}
