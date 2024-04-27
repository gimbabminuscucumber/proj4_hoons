package com.cos.blog.service;

import java.util.List;

import com.cos.blog.domain.board.BoardDao;
import com.cos.blog.domain.reply.Reply;
import com.cos.blog.domain.reply.ReplyDao;
import com.cos.blog.domain.reply.dto.ReplyRespDto;
import com.cos.blog.domain.reply.dto.SaveReqDto;

public class ReplyService {
	
	private ReplyDao replyDao;
	
	public ReplyService() {
		replyDao = new ReplyDao();
	}
	
	public int 댓글쓰기(SaveReqDto dto) {
		return replyDao.save(dto);
	}

	public Reply 댓글찾기(int id) {
		return replyDao.findById(id);
	}

	public int 댓글삭제(int id) {
		return replyDao.deleteById(id);
	}

//	public List<Reply> 댓글목록(int boardId) {					// 댓글 목록
//		return replyDao.findAll(boardId);
//	}
	
	public List<ReplyRespDto> 댓글목록(int id) {		// list : 댓글 목록 + 유저의 username / 파라미터는 게시글 id
		return replyDao.findAll(id);
	}
	
	public int 댓글수(int boardId){
		return replyDao.updateCount(boardId);
	}

}
