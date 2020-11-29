package com.roomies.app.roomiesApp.repository;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.roomies.app.roomiesApp.models.Group;

@Repository
@Transactional
public interface GroupRepository extends JpaRepository<Group, Long> {
	Group save(Group group);

	Group findByGroupName(String groupName);

	Group getOne(Long id);

	Group findByGroupId(Long groupId);

	// @Query("SELECT CASE WHEN COUNT(g) > 0 THEN true ELSE false END FROM
	// Grouptable g WHERE g.groupId = :groupId")
	// boolean existsByGroupId(@Param("groupId") Long groupId);
}
