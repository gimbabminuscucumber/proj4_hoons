package com.cos.blog.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import com.cos.blog.domain.buy.BuyDao;
import com.cos.blog.domain.buy.dto.BuyReqDto;

public class BuyService {
	
	private BuyDao buyDao;
	
	public BuyService() {
		buyDao = new BuyDao();
	}

	public int 상품구매(BuyReqDto dto) {
		System.out.println("BuyService/상품구매/dto : "  +dto);
		return buyDao.buy(dto);
	}
	
	public String 구매번호() {
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String dateNum = df.format(new Date());
		//int randomNum = (int)(Math.random() * 10000) + 0000;									// 0 ~ 9999 까지의 난수
		String randomNum = String.format("%04d", (int)(Math.random() * 10000));	// 0000 ~ 9999 까지의 4자리 난수 
		return dateNum + randomNum;
	}
	
}
