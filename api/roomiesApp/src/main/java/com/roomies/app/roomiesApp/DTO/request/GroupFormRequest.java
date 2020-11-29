package com.roomies.app.roomiesApp.DTO.request;

import java.util.Set;

import javax.validation.constraints.NotBlank;

public class GroupFormRequest {
	@NotBlank
	private String groupName;
	@NotBlank
	private String groupDescription;
	private Set<String> users;

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

	public Set<String> getUsers() {
		return users;
	}

	public void setUsers(Set<String> users) {
		this.users = users;
	}
}
