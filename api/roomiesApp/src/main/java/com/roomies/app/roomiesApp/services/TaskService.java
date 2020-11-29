package com.roomies.app.roomiesApp.services;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import com.roomies.app.roomiesApp.DTO.request.ItemsRequest;
import com.roomies.app.roomiesApp.DTO.request.ToDoTaskRequest;
import com.roomies.app.roomiesApp.DTO.response.ItemsResponse;
import com.roomies.app.roomiesApp.DTO.response.ToDoTaskResponse;
import com.roomies.app.roomiesApp.models.Item;
import com.roomies.app.roomiesApp.models.Payments;
import com.roomies.app.roomiesApp.models.TaskImpl;
import com.roomies.app.roomiesApp.models.TaskStatus;
import com.roomies.app.roomiesApp.models.TaskType;
import com.roomies.app.roomiesApp.models.User;
import com.roomies.app.roomiesApp.repository.PaymentsRepository;
import com.roomies.app.roomiesApp.repository.ShoppingItemRepository;
import com.roomies.app.roomiesApp.repository.TaskRepository;
import com.roomies.app.roomiesApp.repository.UserRepository;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class TaskService {

	@Autowired
	UserDetailsServiceImpl userServiceImpl;

	@Autowired
	GroupActionServiceImpl groupActionServiceImpl;

	@Autowired
	TaskRepository taskRepository;

	@Autowired
	UserRepository userRepository;

	@Autowired
	ShoppingItemRepository shoppingItemRepository;

	@Autowired
	PaymentsRepository paymentsRepository;

	@Autowired
	ModelMapper modelMapper;

	public ResponseEntity<?> createTask(ToDoTaskRequest taskForm) {
		User user = null;
		TaskImpl task = new TaskImpl();
		task.setTaskName(taskForm.getTaskName());
		task.setTaskDescription(taskForm.getTaskDescription());
		task.setStatus(TaskStatus.NEW);
		task.setCreationDate(new Date());
		task.setCompletionDate(stringTODate(taskForm.getCompletionDate()));
		User u = userRepository.findByUsername(taskForm.getUserInCharge());
		task.setUserInCharge(u);
		user = userServiceImpl.getCurrentUserFromSession();
		task.setAddedByUser(user);
		task.setTaskType(TaskType.TO_DO_TASK);
		task.setIsTaskComplete(false);
		task.setIsTaskUpForSwap(taskForm.getIsTaskUpForSwap() == null ? false : taskForm.getIsTaskUpForSwap());
		task.setGroupInfo(groupActionServiceImpl.findByGroupName(user.getGroupInfo().getGroupName()));
		try {
			task = save(task);
			user.getTasks().add(task);

		} catch (Exception e) {
			log.error(e.getMessage());
			return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}

		return ResponseEntity.ok(modelMapper.map(task, ToDoTaskResponse.class));
	}

	public ResponseEntity<?> createItem(ItemsRequest itemForm) {
		User user = null;
		Item task = new Item();
		task.setTaskName(itemForm.getTaskName());
		task.setTaskDescription(itemForm.getTaskDescription());
		task.setStatus(TaskStatus.NEW);
		task.setCreationDate(new Date());
		task.setCompletionDate(stringTODate(itemForm.getCompletionDate()));
		task.setItemName(itemForm.getItemName());
		// User u = userRepository.findByUsername(itemForm.getUserInCharge());
		// task.setUserInCharge(u);
		user = userServiceImpl.getCurrentUserFromSession();
		task.setAddedByUser(user);
		task.setIsTaskComplete(false);
		task.setIsTaskUpForSwap(false);
		task.setTaskType(TaskType.SHOPPING_LIST_ITEM);
		task.setGroupInfo(groupActionServiceImpl.findByGroupName(user.getGroupInfo().getGroupName()));
		try {
			task = save(task);
			user.getTasks().add(task);

		} catch (Exception e) {
			log.error(e.getMessage());

			return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return ResponseEntity.ok(modelMapper.map(task, ItemsResponse.class));
	}

	public List<Item> viewShoppingAllItems() {
		List<Item> taskList = new ArrayList<>();
		taskList = shoppingItemRepository.findAllTaskByGroupAndType(
				userServiceImpl.getCurrentUserFromSession().getGroupInfo(), TaskType.SHOPPING_LIST_ITEM);
		return taskList;
	}

	public List<Item> viewAllUserBoughtItems(HttpServletRequest request) {
		User user = userServiceImpl.getCurrentUserFromSession();
		return shoppingItemRepository.findAllShoppingItemsByUser(user.getId());
	}

	public TaskImpl save(TaskImpl task) {
		return taskRepository.save(task);
	}

	public Item save(Item item) {
		return shoppingItemRepository.save(item);
	}

	public Date stringTODate(String s) {
		Date date;
		try {
			return date = new SimpleDateFormat("yyyy-MM-dd").parse(s);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	public String DateToString() {
		Date date = new Date();
		DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd");
		return dateFormat.format(date);
	}

	public void deleteScheduleTask(Long id) {
		taskRepository.deleteByTaskId(id);
	}

	public ResponseEntity<?> updateScheduleTask(TaskImpl taskInfo, ToDoTaskRequest task, User userInCharge) {

		taskInfo.setTaskName(task.getTaskName());
		taskInfo.setTaskDescription(task.getTaskDescription());
		taskInfo.setUserInCharge(userInCharge);
		taskInfo.setCompletionDate(stringTODate(task.getCompletionDate()));
		if (null != task.getIsTaskComplete() && task.getIsTaskComplete()) {
			taskInfo.setStatus(TaskStatus.COMPLETED);
			taskInfo.setIsTaskComplete(true);
		} else if (null != task.getTaskStatus() && null != TaskStatus.valueOf(task.getTaskStatus())) {
			taskInfo.setStatus(TaskStatus.valueOf(task.getTaskStatus()));
			taskInfo.setIsTaskComplete(false);
		}
		if (null != task.getIsTaskUpForSwap()) {
			taskInfo.setIsTaskUpForSwap(task.getIsTaskUpForSwap());
		}
		try {
			taskInfo = save(taskInfo);
		} catch (Exception e) {
			return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return ResponseEntity.ok(modelMapper.map(taskInfo, ToDoTaskResponse.class));
	}

	public void deleteShoppingItems(long id) {
		shoppingItemRepository.deleteByTaskId(id);
	}

	public ResponseEntity<?> updateShoppingItems(Item item, ItemsRequest itemForm, User boughtBy, Set<User> sharedBy) {

		item.setTaskName(itemForm.getTaskName());
		item.setTaskDescription(itemForm.getTaskDescription());
		item.setCompletionDate(stringTODate(itemForm.getCompletionDate()));
		item.setItemName(itemForm.getItemName());
		if (itemForm.getIsTaskComplete()) {
			item.setStatus(TaskStatus.COMPLETED);
			item.setIsTaskComplete(true);
			item.setPurchasedOnDate(stringTODate(itemForm.getPurchasedOnDate()));
			item.setItemPrice(itemForm.getItemPrice());
			item.setBoughtBy(boughtBy);
			item.setSharedUsers(sharedBy);

			// //Payments
			// Payments payment = new Payments();
			// Set<User> sharedUsers = item.getSharedUsers();
			// Double sharePerUser = item.getItemPrice() / sharedUsers.size();
			// payment.setAmountToBePaidPerUser(sharePerUser);
			// final User boughtByU = item.getBoughtBy();
			// if (sharedUsers.contains(item.getBoughtBy())) {
			// payment.setAmountToBePaid(item.getItemPrice() - sharePerUser);
			// payment.setUsersPaymentPending(item.getSharedUsers().stream().filter(i ->
			// !i.equals(boughtByU))
			// .collect(Collectors.toSet()));
			// } else {
			// payment.setAmountToBePaid(item.getItemPrice());
			// payment.setUsersPaymentPending(item.getSharedUsers());
			// }

			// payment.setAmountPaid(0.0);
			// payment.setItem(item);
			// paymentsRepository.save(payment);

		}
		try {
			item = save(item);
		} catch (Exception e) {
			return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return ResponseEntity.ok(modelMapper.map(item, ItemsResponse.class));

	}

	public List<Payments> viewAllUserPendingPayments(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return paymentsRepository.getAllPendingPaymentsByUser(userServiceImpl.getCurrentUserFromSession().getId());

	}

	public List<Payments> getAllPaidPaymentsByUser(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return paymentsRepository.getAllPaidPaymentsByUser(userServiceImpl.getCurrentUserFromSession().getId());

	}

	public List<Payments> getAllUserBoughtItems(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return paymentsRepository.getAllUserBoughtItems(userServiceImpl.getCurrentUserFromSession().getId());

	}

	public void updateUserPendingPayments(Long paymentId, Long taskId, HttpServletRequest request) {
		// TODO Auto-generated method stub
		Payments payment = paymentsRepository.findById(paymentId).orElse(null);
		if (null != payment) {
			payment.setAmountPaid(payment.getAmountPaid() + payment.getAmountToBePaidPerUser());
			payment.setAmountToBePaid(payment.getAmountToBePaid() - payment.getAmountToBePaidPerUser());
			payment.getUsersPaymentPending()
					.removeIf(user -> user.getId() == userServiceImpl.getCurrentUserFromSession().getId());
			payment.getUsersPaymentReceived().add(userServiceImpl.getCurrentUserFromSession());

			paymentsRepository.save(payment);
		}
		// return
		// paymentsRepository.getAllPaymentsPendingToUser(userServiceImpl.getCurrentUserFromSession(request).getId());

	}

	public List<TaskImpl> getAllTaskForCurrentGroup() {
		List<TaskImpl> taskList = new ArrayList<>();
		taskList = taskRepository.findAllTaskByGroupAndType(userServiceImpl.getCurrentUserFromSession().getGroupInfo(),
				TaskType.TO_DO_TASK);
		return taskList;
	}
}
