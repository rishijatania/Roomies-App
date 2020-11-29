package com.roomies.app.roomiesApp.controllers;

import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import com.roomies.app.roomiesApp.DTO.request.GroupFormRequest;
import com.roomies.app.roomiesApp.DTO.request.GroupJoinRequest;
import com.roomies.app.roomiesApp.DTO.request.ItemsRequest;
import com.roomies.app.roomiesApp.DTO.request.ToDoTaskRequest;
import com.roomies.app.roomiesApp.DTO.request.UserProfileRequest;
import com.roomies.app.roomiesApp.DTO.response.ErrorMessageResponse;
import com.roomies.app.roomiesApp.DTO.response.GroupFormResponse;
import com.roomies.app.roomiesApp.DTO.response.ItemsResponse;
import com.roomies.app.roomiesApp.DTO.response.MessageResponse;
import com.roomies.app.roomiesApp.DTO.response.ToDoTaskResponse;
import com.roomies.app.roomiesApp.DTO.response.UserResponse;
import com.roomies.app.roomiesApp.models.ERole;
import com.roomies.app.roomiesApp.models.Group;
import com.roomies.app.roomiesApp.models.Item;
import com.roomies.app.roomiesApp.models.Payments;
import com.roomies.app.roomiesApp.models.TaskForm;
import com.roomies.app.roomiesApp.models.TaskImpl;
import com.roomies.app.roomiesApp.models.TaskType;
import com.roomies.app.roomiesApp.models.User;
import com.roomies.app.roomiesApp.repository.ShoppingItemRepository;
import com.roomies.app.roomiesApp.repository.TaskRepository;
import com.roomies.app.roomiesApp.repository.UserRepository;
import com.roomies.app.roomiesApp.services.EmailService;
import com.roomies.app.roomiesApp.services.GroupActionServiceImpl;
import com.roomies.app.roomiesApp.services.TaskService;
import com.roomies.app.roomiesApp.services.UserDetailsServiceImpl;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Controller
@RestController
@RequestMapping("/api/home")
public class UserActionController {

	@Autowired
	GroupActionServiceImpl groupActionServiceImpl;

	@Autowired
	UserDetailsServiceImpl userServiceImpl;

	@Autowired
	private ModelMapper modelMapper;

	@Autowired
	EmailService emailService;

	@Autowired
	TaskService taskService;

	@Autowired
	UserRepository userRepository;

	@Autowired
	TaskRepository taskRepository;

	@Autowired
	ShoppingItemRepository shoppingItemRepository;

	@PostMapping("/createGroup")
	@PreAuthorize("hasRole('USER')")
	public ResponseEntity<?> createGroup(@Valid @RequestBody GroupFormRequest groupForm) {
		if (userServiceImpl.getCurrentUserFromSession().getGroupInfo() != null) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User can be part of only 1 group!",400,"","/createGroup"),
					HttpStatus.BAD_REQUEST);
		}
		if (groupActionServiceImpl.findByGroupName(groupForm.getGroupName()) != null) {
			return new ResponseEntity<>(
					new ErrorMessageResponse(taskService.DateToString(),"Group with name " + groupForm.getGroupName() + " already exist!",400,"","/createGroup"),
					HttpStatus.BAD_REQUEST);
		}

		String status = groupActionServiceImpl.saveGroupInfo(groupForm);
		if (status != "success") {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Group registration failed!",400,"","/createGroup"), HttpStatus.BAD_REQUEST);
		}
		return ResponseEntity.ok(new MessageResponse("Group registered successfully!"));
	}

	@PostMapping("/inviteUsers")
	@PreAuthorize("hasRole('GRADMIN')")
	public ResponseEntity<?> inviteUsers(@Valid @RequestBody GroupFormRequest groupForm) {
		if (!userServiceImpl.getCurrentUserFromSession().getGroupInfo().getGroupName()
				.equals(groupForm.getGroupName())) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Group admin not part of the group!",400,"","/inviteUsers"),
					HttpStatus.BAD_REQUEST);
		}

		if (null == groupForm.getUsers() || groupForm.getUsers().isEmpty()) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Users List Empty!",400,"","/inviteUsers"), HttpStatus.BAD_REQUEST);
		}
		Set<String> users = groupForm.getUsers();

		for (String item : users) {
			if (!EmailService.validate(item)) {
				return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Invalid User Email: " + item,400,"","/inviteUsers"), HttpStatus.BAD_REQUEST);
			}
			if (userRepository.existsByEmail(item)) {
				User u = userRepository.findByEmail(item);
				if (null != u.getGroupInfo()) {
					return new ResponseEntity<>(
							new ErrorMessageResponse(taskService.DateToString(),"User with email " + item + " already part of another Group",400,"","/inviteUsers"),
							HttpStatus.BAD_REQUEST);
				}
			}
		}
		if (null == groupForm.getUsers() || groupForm.getUsers().isEmpty()) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Users List Empty!",400,"","/inviteUsers"), HttpStatus.BAD_REQUEST);
		}
		String status = emailService.sendEmailToUsers(userServiceImpl.getCurrentUserFromSession(),
				groupForm.getUsers());
		if (status != "success") {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Email failed!",400,"","/inviteUsers"), HttpStatus.BAD_REQUEST);
		}
		return ResponseEntity.ok(new MessageResponse("Invited Users successfully!"));
	}

	@PostMapping("/joinGroup")
	@PreAuthorize("hasRole('USER')")
	public ResponseEntity<?> joinGroup(@Valid @RequestBody GroupJoinRequest groupJoin) {
		if (userServiceImpl.getCurrentUserFromSession().getGroupInfo() != null) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User can be part of only 1 group!",400,"","/joinGroup"),
					HttpStatus.BAD_REQUEST);
		}
		if (groupActionServiceImpl.findByGroupId(groupJoin.getGroupId()) == null) {
			return new ResponseEntity<>(
					new ErrorMessageResponse(taskService.DateToString(),"Group with ID " + groupJoin.getGroupId() + " does not exist!",400,"","/joinGroup"),
					HttpStatus.BAD_REQUEST);
		}

		String status = groupActionServiceImpl.addUserToGroup(groupJoin);
		if (status != "success") {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User is Unable to Join the Group!",400,"","/joinGroup"),
					HttpStatus.BAD_REQUEST);
		}
		return ResponseEntity.ok(new MessageResponse("Group joined successfully!"));
	}

	@PutMapping("/updateGroupInfo")
	@PreAuthorize("hasRole('GRADMIN')")
	public ResponseEntity<?> joinGroup(@Valid @RequestBody GroupFormRequest groupForm) {
		if (userServiceImpl.getCurrentUserFromSession().getGroupInfo() == null) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User should be should be part of the group to update it!",400,"","/updateGroupInfo"),
					HttpStatus.BAD_REQUEST);
		}
		Group group = groupActionServiceImpl.findByGroupName(groupForm.getGroupName());
		if (group == null) {
			return new ResponseEntity<>(
					new ErrorMessageResponse(taskService.DateToString(),"Group with name " + groupForm.getGroupName() + " does not exist!",400,"","/updateGroupInfo"),
					HttpStatus.BAD_REQUEST);
		}
		group.setGroupDescription(groupForm.getGroupDescription());
		groupActionServiceImpl.updateGroupDescription(group);
		return ResponseEntity.ok(new MessageResponse("Group Description updated successfully!"));
	}

	@GetMapping("/groupInfo")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> groupInfo() {
		if (userServiceImpl.getCurrentUserFromSession().getGroupInfo() == null) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User not part of any group!",404,"","/groupInfo"), HttpStatus.NOT_FOUND);
		}

		Group group = groupActionServiceImpl
				.findByGroupId(userServiceImpl.getCurrentUserFromSession().getGroupInfo().getGroupId());

		return ResponseEntity.ok(modelMapper.map(group, GroupFormResponse.class));
	}

	@GetMapping("/tasks/self")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> getAllCurrentUserTasks() {
		return ResponseEntity.ok(userServiceImpl.getCurrentUserFromSession().getToDoTasks().stream()
				.map(item -> modelMapper.map(item, ToDoTaskResponse.class)).collect(Collectors.toList()));
	}

	@GetMapping("/tasks")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> getAllGroupTasks() {

		return ResponseEntity.ok(taskService.getAllTaskForCurrentGroup().stream()
				.map(item -> modelMapper.map(item, ToDoTaskResponse.class)).collect(Collectors.toList()));
	}

	@PostMapping("/task")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> createToDoTask(@Valid @RequestBody ToDoTaskRequest taskForm) {
		User user = userRepository.findByUsername(taskForm.getUserInCharge());
		if (user == null || !userServiceImpl.getCurrentUserFromSession().getGroupInfo().equals(user.getGroupInfo())) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User not found!",404,"","/task"), HttpStatus.NOT_FOUND);
		}
		if (taskService.stringTODate(taskForm.getCompletionDate()).compareTo(new Date()) < 0) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Completion Date should be in future!",400,"","/task"),
					HttpStatus.BAD_REQUEST);
		}

		return taskService.createTask(taskForm);
	}

	@DeleteMapping(value = "/task/{id}", produces = { MediaType.APPLICATION_JSON_VALUE })
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> deleteToDoTask(@PathVariable(value = "id") long id) {
		TaskImpl task = taskRepository.getOne(id);
		if (task == null || !userServiceImpl.getCurrentUserFromSession().getGroupInfo().equals(task.getGroupInfo())) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Task not found!",404,"","/task"), HttpStatus.NOT_FOUND);
		}
		if(TaskType.SHOPPING_LIST_ITEM.equals(task.getTaskType())){
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User not Found!",400,"","/task"), HttpStatus.BAD_REQUEST);
		}
		if(!userServiceImpl.getCurrentUserFromSession().getRoles().stream()
						.anyMatch(role->ERole.ROLE_GRADMIN.equals(role.getName()))  &&
						!userServiceImpl.getCurrentUserFromSession().equals(task.getUserInCharge())){
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User is forbidden from Deleteing this Task!",402,"","/task"), HttpStatus.BAD_REQUEST);	
		}
		taskService.deleteScheduleTask(id);
		return ResponseEntity.ok(new MessageResponse("Task Deleted successfully!"));
	}

	@PutMapping(value = "/task/{id}")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> updateScheduleTask(@PathVariable(value = "id") long id,
			@Valid @RequestBody ToDoTaskRequest task) {
		Optional<TaskImpl> taskInfo = taskRepository.findById(id);
		Group group = userServiceImpl.getCurrentUserFromSession().getGroupInfo();
		if (!taskInfo.isPresent() || !group.equals(taskInfo.get().getGroupInfo())) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Task not found!",404,"","/task"), HttpStatus.NOT_FOUND);
		}
		User userinCharge = userRepository.findByUsername(task.getUserInCharge());
		if (null == userinCharge || !group.getUsers().contains(userinCharge)) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Bad Request!",404,"","/task"), HttpStatus.NOT_FOUND);
		}

		return taskService.updateScheduleTask(taskInfo.get(), task, userinCharge);
	}

	@GetMapping("/items")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> getAllShoppingItems() {

		return ResponseEntity.ok(taskService.viewShoppingAllItems().stream()
				.map(item -> modelMapper.map(item, ItemsResponse.class)).collect(Collectors.toList()));
	}

	@PostMapping("/item")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> createShoppingItem(@Valid @RequestBody ItemsRequest itemForm) {
		if (taskService.stringTODate(itemForm.getCompletionDate()).compareTo(new Date()) < 0) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Completion Date should be in future!",400,"","/item"),
					HttpStatus.BAD_REQUEST);
		}

		return taskService.createItem(itemForm);
	}

	@DeleteMapping(value = "/item/{id}", produces = { MediaType.APPLICATION_JSON_VALUE })
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> deleteShoppingItems(@PathVariable(value = "id") long id) {
		Optional<Item> item = shoppingItemRepository.findById(id);
		if (!item.isPresent() || !userServiceImpl.getCurrentUserFromSession().getGroupInfo().equals(item.get().getGroupInfo())) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Item not found!",404,"","/item"), HttpStatus.NOT_FOUND);
		}
		if(TaskType.TO_DO_TASK.equals(item.get().getTaskType())){
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Bad Request!",400,"","/item"), HttpStatus.BAD_REQUEST);
		}
		taskService.deleteShoppingItems(id);
		return ResponseEntity.ok(new MessageResponse("Item Deleted successfully!"));
	}

	@PutMapping(value = "/item/{id}")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN')")
	public ResponseEntity<?> updateShoppingItems(@PathVariable("id") Long id,@Valid @RequestBody ItemsRequest itemForm) {
		Optional<Item> item = shoppingItemRepository.findById(id);
		Group group = userServiceImpl.getCurrentUserFromSession().getGroupInfo();
		if (!item.isPresent() || !group.equals(item.get().getGroupInfo())) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Item not found!",404,"","/item"), HttpStatus.NOT_FOUND);
		}
		User itemBoughtBy = new User();
		Set<User> sharedUsers=new HashSet<User>();
		if(itemForm.getIsTaskComplete()){
			if(null == itemForm.getSharedUsers() || itemForm.getSharedUsers().isEmpty() || null==itemForm.getBoughtBy() || itemForm.getBoughtBy().isEmpty()){
				return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Bad Request!",400,"","/item"), HttpStatus.BAD_REQUEST);
			}
			else{
				itemBoughtBy = userRepository.findByUsername(itemForm.getBoughtBy());
				if (null == itemBoughtBy || !group.getUsers().contains(itemBoughtBy)) {
					return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Bad Request!",404,"","/item"), HttpStatus.NOT_FOUND);
				}
				
				for(String user: itemForm.getSharedUsers()){
					User u = userRepository.findByUsername(user);	
					if(null == u){
						return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"Bad Request!",404,"","/item"), HttpStatus.NOT_FOUND);
					}
					sharedUsers.add(u);				
				}
			}
		}

		return taskService.updateShoppingItems(item.get(), itemForm, itemBoughtBy,sharedUsers);
	}


	@GetMapping("/payments")
	public String viewPayments(Model model, HttpServletRequest request) {
		List<Payments> pendingPaymentsList = taskService.viewAllUserPendingPayments(request);
		List<Payments> paidPaymentsList = taskService.getAllPaidPaymentsByUser(request);
		List<Payments> boughtByUsersList = taskService.getAllUserBoughtItems(request);
		model.addAttribute("pendingPaymentsList", pendingPaymentsList);
		model.addAttribute("paidPaymentsList", paidPaymentsList);
		model.addAttribute("boughtByUsersList", boughtByUsersList);
		return "payments";
	}

	@PostMapping("/payments")
	public String addPayments(Model model, HttpServletRequest request) {
		taskService.updateUserPendingPayments(Long.valueOf((String) request.getParameter("paymentId")),
				Long.valueOf((String) request.getParameter("taskId")), request);

		List<Payments> pendingPaymentsList = taskService.viewAllUserPendingPayments(request);
		List<Payments> paidPaymentsList = taskService.getAllPaidPaymentsByUser(request);
		List<Payments> boughtByUsersList = taskService.getAllUserBoughtItems(request);
		model.addAttribute("pendingPaymentsList", pendingPaymentsList);
		model.addAttribute("paidPaymentsList", paidPaymentsList);
		model.addAttribute("boughtByUsersList", boughtByUsersList);
		return "payments";
	}

	@GetMapping("/profile")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN') or hasRole('ADMIN')")
	public ResponseEntity<?> viewProfile() {
		User user = userServiceImpl.getCurrentUserFromSession();
		return ResponseEntity.ok(modelMapper.map(user, UserResponse.class));
	}

	@PutMapping("/profile")
	@PreAuthorize("hasRole('USER') or hasRole('GRADMIN') or hasRole('ADMIN')")
	public ResponseEntity<?> updateProfile(@Valid @RequestBody UserProfileRequest userForm) {

		User user = userServiceImpl.getCurrentUserFromSession();
		user.setFirstName(userForm.getFirstName());
		user.setLastName(userForm.getLastName());
		user.setPhoneNo(userForm.getPhoneNo());
		try {
			userRepository.save(user);
		} catch (Exception e) {
			return new ResponseEntity<>(new ErrorMessageResponse(taskService.DateToString(),"User update failed!",400,"","/profile"), HttpStatus.BAD_REQUEST);
		}

		return ResponseEntity.ok(modelMapper.map(user, UserResponse.class));
	}
}
