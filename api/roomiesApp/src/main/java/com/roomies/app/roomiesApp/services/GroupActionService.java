package com.roomies.app.roomiesApp.services;

import com.roomies.app.roomiesApp.models.Group;

public interface GroupActionService {
	Group save(Group group);

	Group findByGroupName(String groupName);

	Group getOne(Long groupId);

	Group findByGroupId(Long groupId);

	// boolean existsByGroupId(Long groupId);
}
