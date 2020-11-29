package com.roomies.app.roomiesApp.DTO.response;

import java.util.Date;
import java.util.List;

import com.roomies.app.roomiesApp.models.TaskStatus;
import com.roomies.app.roomiesApp.models.TaskType;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemsResponse {
	private String taskId;
	private String taskName;
	private TaskType taskType;
	private TaskStatus taskStatus;
	private String taskDescription;
	private Date creationDate;
	private Date completionDate;
	private UserResponse addedByUser;
	private Boolean isTaskComplete;

	private String itemName;
	private Double itemPrice;
	private List<UserResponse> sharedUsers;
	private Date purchasedOnDate;
	private UserResponse boughtBy;
}