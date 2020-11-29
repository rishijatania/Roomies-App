package com.roomies.app.roomiesApp.models;

import java.util.Date;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@PrimaryKeyJoinColumn(name = "taskId")
public class Item extends TaskImpl {

	private String itemName;

	private Double itemPrice;

	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "item_users", joinColumns = @JoinColumn(name = "taskId"), inverseJoinColumns = @JoinColumn(name = "sharedUser_Id", referencedColumnName = "id"))
	private Set<User> sharedUsers;

	@Temporal(TemporalType.DATE)
	private Date purchasedOnDate;

	@OneToOne
	@JoinColumn(referencedColumnName = "id")
	private User boughtBy;

	@OneToOne(mappedBy = "item", cascade = CascadeType.ALL, fetch = FetchType.LAZY, optional = false)
	private Payments payments;

	public Payments getPayments() {
		return payments;
	}

	public void setPayments(Payments payments) {
		this.payments = payments;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public Double getItemPrice() {
		return itemPrice;
	}

	public void setItemPrice(Double itemPrice) {
		this.itemPrice = itemPrice;
	}

	public Set<User> getSharedUsers() {
		return sharedUsers;
	}

	public void setSharedUsers(Set<User> sharedUsers) {
		this.sharedUsers = sharedUsers;
	}

	public Date getPurchasedOnDate() {
		return purchasedOnDate;
	}

	public void setPurchasedOnDate(Date purchasedOnDate) {
		this.purchasedOnDate = purchasedOnDate;
	}

	public User getBoughtBy() {
		return boughtBy;
	}

	public void setBoughtBy(User boughtBy) {
		this.boughtBy = boughtBy;
	}

}