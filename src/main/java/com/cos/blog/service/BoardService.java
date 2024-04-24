package com.cos.blog.service;

import java.util.List;

import org.apache.catalina.connector.Response;

import com.cos.blog.domain.board.Board;
import com.cos.blog.domain.board.BoardDao;
import com.cos.blog.domain.board.dto.DetailRespDto;
import com.cos.blog.domain.board.dto.SaveReqDto;

public class BoardService {

	private BoardDao	boardDao;
	
	public BoardService() {
		boardDao = new BoardDao();
	}

	public int 글쓰기(SaveReqDto dto	) {
		return boardDao.save(dto);
	}
	
	// Board 테이블
//	public List<Board> 글목록보기(int page) {
//		return boardDao.findAll(page);
//	}
	// Board 테이블 + User 테이블 = 조인된 데이터
	public List<DetailRespDto> 글목록보기(int page) {
		return boardDao.findAll(page);
	}

	// 페이징 처리
	public int 글개수() {
		return boardDao.count();
	}

	// 하나의 Service 안에 여러가지 DB 관련 로직이 섞인다
	public DetailRespDto 글상세보기(int id) {
		int result = boardDao.updateReadCount(id);
		if(result == 1) {
			return boardDao.findById(id);
		}else {
			return null;
		} 
	}

	public int 글삭제(int id) {
		return boardDao.deleteById(id);
	}

}
