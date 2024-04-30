package com.cos.blog.service;

import com.cos.blog.domain.user.User;
import com.cos.blog.domain.user.UserDao;
import com.cos.blog.domain.user.dto.JoinReqDto;
import com.cos.blog.domain.user.dto.LoginReqDto;
import com.cos.blog.domain.user.dto.PasswordReqDto;

public class UserService {
	// 필요 기능 : 회원가입, 회원수정, 로그인, 로그아웃, 아이디중복체크 ...
	// - 로그아웃은 세션값만 날리면 되기 때문에 request 처리만 하면 된다 -> controller에서 바로 처리할거임

	private UserDao userDao;
	
	public UserService() {
		userDao = new UserDao();
	}
	
	public int 회원가입(JoinReqDto dto) {		// insert 작업 : 잘됐다 안됐다의 결과값을 리턴
		int result = userDao.save(dto);
		return result;
	}
	
	public User 로그인(LoginReqDto dto) {		// select 작업 : 특정 행을 찾아서 결과값으로 리턴
		return userDao.findByUsernameAndPassword(dto);
	}
	
	public int 유저네임중복체크(String username) {
		int result = userDao.findByUsername(username);
		System.out.println("UserService.유저네임 중복 여부 : " + result);		// 1 이면 중복, -1 이면 신규
		return result; 
	}

	public User 회원찾기(int id) {
		return userDao.findById(id);
	}

	public int 회원수정(User user) {
		int result = userDao.update(user);
		return result;	
	}

	public User 회원이메일(String email) {			// 이메일로 아이디 찾기 1
		return userDao.userInfo(email);
	}

	public int 유저네임찾기(String email) {			// 이메일로 아이디 찾기 2
		int result = userDao.findByEmail(email);
		return result;
	}


	public User 회원패스워드(PasswordReqDto dto) {
		System.out.println("UserService dto : " + dto);
		return userDao.userInfo2(dto);
	}

	public int 비밀번호찾기(PasswordReqDto dto) {
		int result = userDao.findByUsernameAndEmail(dto);
		return result;
	}

}
