package com.roomies.app.roomiesApp.DTO.response;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ErrorMessageResponse {
	private String message;
	private String timestamp;
	private Integer status;
	private String error;
	private String path;

	public ErrorMessageResponse(String timestamp, String message,Integer status,String error,String path) {
		this.timestamp=timestamp;
		this.message = message;
		this.status=status;
		this.error=error;
		this.path=path;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
