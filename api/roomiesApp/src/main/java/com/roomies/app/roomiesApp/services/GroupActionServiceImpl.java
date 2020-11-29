package com.roomies.app.roomiesApp.services;

import java.util.HashSet;
import java.util.Random;
import java.util.Set;

import javax.transaction.Transactional;

import com.roomies.app.roomiesApp.DTO.request.GroupFormRequest;
import com.roomies.app.roomiesApp.DTO.request.GroupJoinRequest;
import com.roomies.app.roomiesApp.models.ERole;
import com.roomies.app.roomiesApp.models.Group;
import com.roomies.app.roomiesApp.models.Role;
import com.roomies.app.roomiesApp.models.User;
import com.roomies.app.roomiesApp.repository.GroupRepository;
import com.roomies.app.roomiesApp.repository.RoleRepository;
import com.roomies.app.roomiesApp.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class GroupActionServiceImpl implements GroupActionService {

	@Autowired
	GroupRepository groupRepository;

	@Autowired
	UserDetailsServiceImpl userServiceImpl;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	UserRepository userRepository;

	@Override
	@Transactional
	public Group save(Group group) {
		return groupRepository.save(group);
	}

	@Override
	@Transactional
	public Group findByGroupName(String groupName) {
		return groupRepository.findByGroupName(groupName);
	}

	@Transactional
	public String saveGroupInfo(GroupFormRequest groupForm) {
		User user = userServiceImpl.getCurrentUserFromSession();

		Role userRole = roleRepository.findByName(ERole.ROLE_GRADMIN)
				.orElseThrow(() -> new RuntimeException("Error: Role is not found."));
		user.addRole(userRole);
		Group group = new Group();
		group.setGroupDescription(groupForm.getGroupDescription());
		group.setGroupName(groupForm.getGroupName());
		Random random = new Random(10000);
		Long groupId;
		do {
			groupId = (long) (random.nextInt(9000000) + 1000000);
		} while (null != findByGroupId(groupId));

		group.setGroupId(groupId);
		Set<User> users = new HashSet<User>();
		try {

			users.add(user);
			group.setUsers(users);
			group = save(group);
			user.setGroupInfo(group);
			userRepository.save(user);
			log.debug("Group with group id {} created Successfully ", groupId);

		} catch (Exception e) {
			log.error(e.getMessage());

			return e.getMessage();
		}
		return "success";
	}

	@Transactional
	public String addUserToGroup(GroupJoinRequest groupForm) {
		User user = userServiceImpl.getCurrentUserFromSession();
		Group group = findByGroupId(groupForm.getGroupId());
		try {
			group.getUsers().add(user);
			group = save(group);
			user.setGroupInfo(group);
			log.debug("Group with group id {} created Successfully ", group.getGroupId());
		} catch (Exception e) {
			log.error(e.getMessage());
			return e.getMessage();
		}

		return "success";
	}

	@Override
	@Transactional
	public Group getOne(Long id) {
		return groupRepository.getOne(id);
	}

	@Override
	@Transactional
	public Group findByGroupId(Long groupId) {
		return groupRepository.findByGroupId(groupId);
	}

	public String updateGroupDescription(Group group) {
		try {
			groupRepository.save(group);
		} catch (Exception e) {
			log.error(e.getMessage());
			return e.getMessage();
		}
		return "success";
	}
}
