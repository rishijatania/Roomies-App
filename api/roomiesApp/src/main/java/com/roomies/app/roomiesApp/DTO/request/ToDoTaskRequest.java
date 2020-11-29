package com.roomies.app.roomiesApp.DTO.request;

import javax.validation.constraints.NotBlank;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ToDoTaskRequest {

	@NotBlank
	private String taskName;

	private String taskStatus;

	@NotBlank
	private String taskDescription;

	@NotBlank
	private String completionDate;

	@NotBlank
	private String userInCharge;

	private Boolean isTaskComplete;

	private Boolean isTaskUpForSwap;

}
