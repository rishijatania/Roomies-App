package com.roomies.app.roomiesApp.models;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import lombok.Getter;
import lombok.Setter;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Getter
@Setter
public class TaskImpl implements Task {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long taskId;

	@Column(nullable = false)
	private String taskName;

	@Column(nullable = false)
	private String taskDescription;

	@Temporal(TemporalType.DATE)
	private Date creationDate;

	@Temporal(TemporalType.DATE)
	private Date completionDate;

	@Enumerated(EnumType.STRING)
	private TaskType taskType;

	@Enumerated(EnumType.STRING)
	private TaskStatus status;

	@ManyToOne
	@JoinColumn(name = "userInChargeId", referencedColumnName = "id")
	private User userInCharge;

	@OneToOne
	@JoinColumn(name = "addedByUserId", referencedColumnName = "id")
	private User addedByUser;

	@OneToOne
	@JoinColumns({ @JoinColumn(name = "groupPk", referencedColumnName = "id"),
			@JoinColumn(name = "groupId", referencedColumnName = "groupId") })
	private Group groupInfo;

	@Column
	private Boolean isTaskComplete;

	@Column
	private Boolean isTaskUpForSwap;

	public Boolean getIsTaskComplete() {
		return isTaskComplete;
	}

	public void setIsTaskComplete(Boolean isTaskComplete) {
		this.isTaskComplete = isTaskComplete;
	}

	public User getUserInCharge() {
		return userInCharge;
	}

	public void setUserInCharge(User userInCharge) {
		this.userInCharge = userInCharge;
	}

	public User getAddedByUser() {
		return addedByUser;
	}

	public void setAddedByUser(User addedByUser) {
		this.addedByUser = addedByUser;
	}

	public Group getGroupInfo() {
		return groupInfo;
	}

	public void setGroupInfo(Group groupInfo) {
		this.groupInfo = groupInfo;
	}

	public Long getTaskId() {
		return taskId;
	}

	public void setTaskId(Long taskId) {
		this.taskId = taskId;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public String getTaskDescription() {
		return taskDescription;
	}

	public void setTaskDescription(String taskDescription) {
		this.taskDescription = taskDescription;
	}

	public Date getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	public Date getCompletionDate() {
		return completionDate;
	}

	public void setCompletionDate(Date completionDate) {
		this.completionDate = completionDate;
	}

	public TaskType getTaskType() {
		return taskType;
	}

	public void setTaskType(TaskType taskType) {
		this.taskType = taskType;
	}

	public TaskStatus getStatus() {
		return status;
	}

	public void setStatus(TaskStatus status) {
		this.status = status;
	}

	@Override
	public int compareTo(Object o) {
		// TODO Auto-generated method stub
		if (TaskStatus.COMPLETED.equals(this.getStatus()) && !TaskStatus.COMPLETED.equals(((TaskImpl) o).getStatus())) {
			return 1;
		} else if (!TaskStatus.COMPLETED.equals(this.getStatus())
				&& TaskStatus.COMPLETED.equals(((TaskImpl) o).getStatus())) {
			return -1;
		} else {
			return this.completionDate.compareTo(((TaskImpl) o).getCompletionDate());
		}
	}

}
