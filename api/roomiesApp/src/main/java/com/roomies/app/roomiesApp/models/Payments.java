package com.roomies.app.roomiesApp.models;

import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;

@Entity
public class Payments {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "item_id")
	private Item item;

	private Double amountPaid;

	private Double amountToBePaid;

	private Double amountToBePaidPerUser;

	@ManyToMany(cascade = { CascadeType.ALL })
	@JoinTable(name = "PaymentsPending")
	private Set<User> usersPaymentPending;

	@ManyToMany(cascade = { CascadeType.ALL })
	@JoinTable(name = "PaymentsReceived")
	private Set<User> usersPaymentReceived;

	public Double getAmountToBePaid() {
		return amountToBePaid;
	}

	public void setAmountToBePaid(Double amountToBePaid) {
		this.amountToBePaid = amountToBePaid;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Item getItem() {
		return item;
	}

	public void setItem(Item item) {
		this.item = item;
	}

	public Double getAmountPaid() {
		return amountPaid;
	}

	public void setAmountPaid(Double amountPaid) {
		this.amountPaid = amountPaid;
	}

	public Double getAmountToBePaidPerUser() {
		return amountToBePaidPerUser;
	}

	public void setAmountToBePaidPerUser(Double amountToBePaidPerUser) {
		this.amountToBePaidPerUser = amountToBePaidPerUser;
	}

	public Set<User> getUsersPaymentPending() {
		return usersPaymentPending;
	}

	public void setUsersPaymentPending(Set<User> usersPaymentPending) {
		this.usersPaymentPending = usersPaymentPending;
	}

	public Set<User> getUsersPaymentReceived() {
		return usersPaymentReceived;
	}

	public void setUsersPaymentReceived(Set<User> usersPaymentReceived) {
		this.usersPaymentReceived = usersPaymentReceived;
	}

}
