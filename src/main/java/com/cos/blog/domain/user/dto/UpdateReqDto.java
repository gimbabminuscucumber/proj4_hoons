package com.cos.blog.domain.user.dto;

import lombok.Data;

@Data
public class UpdateReqDto {
	private int id;
	private String nickName;
	private String passwrod;
	private String email;
	private String address;
}
