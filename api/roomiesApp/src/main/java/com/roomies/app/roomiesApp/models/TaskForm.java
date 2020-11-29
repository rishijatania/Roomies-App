package com.roomies.app.roomiesApp.models;

import java.util.List;

public class TaskForm {

	private String taskId;
	private String taskName;
	private TaskType taskType;
	private TaskStatus taskStatus;
	private String taskDescription;
	private String creationDate;
	private String completionDate;
	private User addedByUser;
	private Boolean isTaskComplete;
	private String userInCharge;

	private String itemName;
	private String itemPrice;
	private List<String> sharedUsers;
	private String purchasedOnDate;
	private String boughtBy;

	public TaskStatus getTaskStatus() {
		return taskStatus;
	}

	public void setTaskStatus(TaskStatus taskStatus) {
		this.taskStatus = taskStatus;
	}

	public String getTaskDescription() {
		return taskDescription;
	}

	public void setTaskDescription(String taskDescription) {
		this.taskDescription = taskDescription;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public TaskType getTaskType() {
		return taskType;
	}

	public void setTaskType(TaskType taskType) {
		this.taskType = taskType;
	}

	public String getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(String creationDate) {
		this.creationDate = creationDate;
	}

	public String getCompletionDate() {
		return completionDate;
	}

	public void setCompletionDate(String completionDate) {
		this.completionDate = completionDate;
	}

	public User getAddedByUser() {
		return addedByUser;
	}

	public void setAddedByUser(User addedByUser) {
		this.addedByUser = addedByUser;
	}

	public Boolean getIsTaskComplete() {
		return isTaskComplete;
	}

	public void setIsTaskComplete(Boolean isTaskComplete) {
		this.isTaskComplete = isTaskComplete;
	}

	public String getUserInCharge() {
		return userInCharge;
	}

	public void setUserInCharge(String userInCharge) {
		this.userInCharge = userInCharge;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getItemPrice() {
		return itemPrice;
	}

	public void setItemPrice(String itemPrice) {
		this.itemPrice = itemPrice;
	}

	public List<String> getSharedUsers() {
		return sharedUsers;
	}

	public void setSharedUsers(List<String> sharedUsers) {
		this.sharedUsers = sharedUsers;
	}

	public String getPurchasedOnDate() {
		return purchasedOnDate;
	}

	public void setPurchasedOnDate(String purchasedOnDate) {
		this.purchasedOnDate = purchasedOnDate;
	}

	public String getBoughtBy() {
		return boughtBy;
	}

	public void setBoughtBy(String boughtBy) {
		this.boughtBy = boughtBy;
	}

}
