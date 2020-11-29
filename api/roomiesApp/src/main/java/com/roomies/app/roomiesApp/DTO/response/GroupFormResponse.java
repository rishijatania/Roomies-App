package com.roomies.app.roomiesApp.DTO.response;

import java.util.Set;

public class GroupFormResponse {
	private Long id;
	private Long groupId;
	private String groupName;
	private String groupDescription;
	private Set<UserResponse> users;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getGroupId() {
		return groupId;
	}

	public void setGroupId(Long groupId) {
		this.groupId = groupId;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getGroupDescription() {
		return groupDescription;
	}

	public void setGroupDescription(String groupDescription) {
		this.groupDescription = groupDescription;
	}

	public Set<UserResponse> getUsers() {
		return users;
	}

	public void setUsers(Set<UserResponse> users) {
		this.users = users;
	}
}
