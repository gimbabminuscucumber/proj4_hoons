package com.cos.blog.service;

import com.cos.blog.domain.user.User;
import com.cos.blog.domain.user.dto.JoinReqDto;
import com.cos.blog.domain.user.dto.LoginReqDto;
import com.cos.blog.domain.user.dto.UpdateReqDto;

public class UserService {

	// 필요 기능 : 회원가입, 회원수정, 로그인, 로그아웃, 아이디중복체크 ...
	// - 로그아웃은 세션값만 날리면 되기 때문에 request 처리만 하면 된다 -> controller에서 바로 처리할거임
	
	public int 회원가입(JoinReqDto dto) {		// insert 작업 : 잘됐다 안됐다의 결과값을 리턴
		
		return -1;
	}
	
	public User 로그인(LoginReqDto dto) {		// select 작업 : 특정 행을 찾아서 결과값으로 리턴
		
		return null;
	}
	
	public int 회원수정(UpdateReqDto dto) {
		
		return -1;
	} 
	
	public int 아이디중복체크(String username) {
		
		return -1; 
	}
}
