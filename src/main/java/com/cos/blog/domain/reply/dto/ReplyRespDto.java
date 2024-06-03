package com.cos.blog.domain.reply.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class ReplyRespDto {
	private int replyId;
	private int userId;
	private int boardId;
	private String content;			// Reply 테이블 ↑
	private int id;							// User 테이블 ↓
	private String username;		
	private String nickName;
	private Timestamp createDate;
}
