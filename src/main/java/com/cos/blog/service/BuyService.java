package com.cos.blog.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import com.cos.blog.domain.buy.BuyDao;
import com.cos.blog.domain.buy.dto.BasketReqDto;
import com.cos.blog.domain.buy.dto.BuyFormReqDto;
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderReqDto;
import com.cos.blog.domain.user.User;

public class BuyService {
	
	private BuyDao buyDao;
	
	public BuyService() {
		buyDao = new BuyDao();
	}
	
	public int 상품구매(BuyReqDto dto) {
		System.out.println("BuyService/상품구매");
		return buyDao.buy(dto);						// MyBatis 또는 직접 작성한 SQL 쿼리를 사용하여 데이터를 관리 / 데이터베이스와 직접 상호작용
		//return buyRepository.save(dto);		// JPA/Hibernate를 사용하여 ORM 방식으로 데이터를 관리 / 객체와 관계형 데이터베이스 간의 매핑을 자동으로 처리
	}
	
	public String 구매번호() {
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String dateNum = df.format(new Date());
		//int randomNum = (int)(Math.random() * 10000) + 0000;										// 0 ~ 9999 까지의 난수
		String randomNum = String.format("%06d", (int)(Math.random() * 1000000));	// 000000 ~ 999999 까지의 6자리 난수 
		return dateNum + randomNum;
	}

	//public OrderReqDto 주문완료(int id) {
	public List<OrderReqDto> 주문완료(int id) {
		return buyDao.findOrder(id);
	}

	public List<OrderReqDto> 주문내역(int userId) {
		return buyDao.findOrderList(userId);
	}

	public List<OrderReqDto> 주문상세(String orderNum) {
		return buyDao.findOrderDetail(orderNum);
	}

	public OrderReqDto 구매자정보(String orderNum) {
		return buyDao.findByBuyer(orderNum);
	}

	public int 장바구니담기(BasketReqDto dto) {
		int result = buyDao.basket(dto);
		return result;
	}
	
	public List<BasketReqDto> 장바구니조회(int userId){
		return buyDao.basketList(userId);
	}

	public List<OrderReqDto> 주문서작성(int[] checkedItems, int userId) {
	    List<OrderReqDto> orders = new ArrayList<>();
	    for (int productId : checkedItems) {
	        OrderReqDto dto = buyDao.buyForm(productId, userId);
	        orders.add(dto);
	    }
	    return orders;
	}

	public int 장바구니삭제(int userId, int productId) {
	    return buyDao.basketDelete(userId, productId);
	}
	
	
}
