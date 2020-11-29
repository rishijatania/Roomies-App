package com.roomies.app.roomiesApp.models;

import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;

@Entity
@PrimaryKeyJoinColumn(name = "taskId")
public class Schedule extends TaskImpl {

	private Boolean isTaskComplete;

	public Boolean getIsTaskComplete() {
		return isTaskComplete;
	}

	public void setIsTaskComplete(Boolean isTaskComplete) {
		this.isTaskComplete = isTaskComplete;
	}

}
