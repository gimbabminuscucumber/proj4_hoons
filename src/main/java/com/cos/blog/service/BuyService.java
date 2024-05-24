package com.cos.blog.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

import com.cos.blog.domain.buy.BuyDao;
import com.cos.blog.domain.buy.dto.BasketReqDto;
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderReqDto;

public class BuyService {
	
	private BuyDao buyDao;
	
	public BuyService() {
		buyDao = new BuyDao();
	}

	public int 상품구매(BuyReqDto dto) {
		return buyDao.buy(dto);
	}
	
	public String 구매번호() {
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String dateNum = df.format(new Date());
		//int randomNum = (int)(Math.random() * 10000) + 0000;										// 0 ~ 9999 까지의 난수
		String randomNum = String.format("%06d", (int)(Math.random() * 1000000));	// 000000 ~ 999999 까지의 6자리 난수 
		return dateNum + randomNum;
	}

	public OrderReqDto 주문완료(int id) {
		return buyDao.findByOrder(id);
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


	
}
