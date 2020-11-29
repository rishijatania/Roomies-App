package com.roomies.app.roomiesApp.models;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "users", uniqueConstraints = { @UniqueConstraint(columnNames = "username"),
		@UniqueConstraint(columnNames = "email") })
public class User {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@NotBlank
	@Size(max = 20)
	private String username;

	@NotBlank
	@Size(max = 50)
	@Email
	private String email;

	@NotBlank
	@Size(max = 120)
	private String password;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "user_roles", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
	private Set<Role> roles = new HashSet<>();

	@Getter
	@Setter
	@Column
	private String firstName;

	@Getter
	@Setter
	@Column
	private String lastName;

	@Getter
	@Setter
	@Column
	private Long phoneNo;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinTable(name = "group_users", joinColumns = { @JoinColumn(name = "userId") }, inverseJoinColumns = {
			@JoinColumn(name = "grpId", referencedColumnName = "id") })
	private Group groupInfo;

	@OneToMany(mappedBy = "userInCharge")
	private List<TaskImpl> tasks;

	public User() {
	}

	public User(String username, String email, String password, String firstName, String lastName, Long phoneNo) {
		this.username = username;
		this.email = email;
		this.password = password;
		this.firstName = firstName;
		this.lastName = lastName;
		this.phoneNo = phoneNo;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Set<Role> getRoles() {
		return roles;
	}

	public void setRoles(Set<Role> roles) {
		this.roles = roles;
	}

	public Group getGroupInfo() {
		return groupInfo;
	}

	public void setGroupInfo(Group groupInfo) {
		this.groupInfo = groupInfo;
	}

	public List<TaskImpl> getTasks() {
		return tasks;
	}

	public void setTasks(List<TaskImpl> tasks) {
		this.tasks = tasks;
	}

	public void addRole(Role role) {
		this.roles.add(role);
	}

	public void removeRole(Role role) {
		this.roles.remove(role);
	}

	public List<TaskImpl> getToDoTasks() {
		return tasks.stream().filter(task -> task.getTaskType().equals(TaskType.TO_DO_TASK))
				.collect(Collectors.toList());
	}
}
