package com.roomies.app.roomiesApp.DTO.response;

import com.roomies.app.roomiesApp.models.TaskStatus;
import com.roomies.app.roomiesApp.models.TaskType;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ToDoTaskResponse {
	private String taskId;
	private String taskName;
	private TaskType taskType;
	private TaskStatus taskStatus;
	private String taskDescription;
	private String creationDate;
	private String completionDate;
	private UserResponse addedByUser;
	private Boolean isTaskComplete;
	private UserResponse userInCharge;
	private Boolean isTaskUpForSwap;
}