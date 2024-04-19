package com.cos.blog.config;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DB {
	
	public static Connection getConnection() {		// DB 연결시, Connection() 메소드 호출하기
		try{
			// https://tomcat.apache.org/tomcat-9.0-doc/jndi-datasource-examples-howto.html#MySQL_DBCP_2_Example
			// 3. Code example 에서 코드 가져옴
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource)envContext.lookup("jdbc/TestDB");	 	// jdbc/TestDB는 context.xml의 Resource name
			Connection conn = ds.getConnection();
			return conn;													// DB 연결에 성공하면 conn 리턴
		}catch(Exception e) {
			System.out.println("DB연결 실패 : " + e.getMessage());
		}
		return null;
	}
	
	public static void close(Connection conn, PreparedStatement pstmt){
		try {
			conn.close();
			pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
