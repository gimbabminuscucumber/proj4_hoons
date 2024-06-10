package com.cos.blog.domain.refund.dto;

import java.sql.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class RefundReqDto {
	private int id;
	private int buyId;
	private int userReason;
	private int manageReason;
	private String text;
	private Timestamp createDate;
		
}
