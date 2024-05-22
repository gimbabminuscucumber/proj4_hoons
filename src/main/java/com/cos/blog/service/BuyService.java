package com.cos.blog.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

import com.cos.blog.domain.buy.BuyDao;
import com.cos.blog.domain.buy.dto.BuyReqDto;
import com.cos.blog.domain.buy.dto.OrderRespDto;

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

	public OrderRespDto 주문완료(int id) {
		return buyDao.findByOrder(id);
	}

	public List<OrderRespDto> 주문내역(int userId) {
		return buyDao.findOrderList(userId);
	}

	public List<OrderRespDto> 주문상세(String orderNum) {
		return buyDao.findOrderDetail(orderNum);
	}

	public OrderRespDto 구매자정보(String orderNum) {
		return buyDao.findByBuyer(orderNum);
	}

	
}
