package com.cos.blog.domain.user;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class User {
	private int id;
	private String username;
	private String nickName;	// 추가
	private String password;
	private String email;
	private String address;
	private String phone;
	private String userRole;	// admin, user
	private Timestamp createDate; 
}
