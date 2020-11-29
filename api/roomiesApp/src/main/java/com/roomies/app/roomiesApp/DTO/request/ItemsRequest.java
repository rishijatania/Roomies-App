package com.roomies.app.roomiesApp.DTO.request;

import java.util.Set;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemsRequest {

	@NotBlank
	private String taskName;

	private String taskStatus;

	@NotBlank
	private String taskDescription;

	private String completionDate;

	private Boolean isTaskComplete;

	@NotBlank
	private String itemName;

	private Double itemPrice;
	private Set<String> sharedUsers;
	private String purchasedOnDate;
	private String boughtBy;

}
