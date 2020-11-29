package com.roomies.app.roomiesApp.repository;

import java.util.List;

import javax.transaction.Transactional;

import com.roomies.app.roomiesApp.models.Group;
import com.roomies.app.roomiesApp.models.TaskImpl;
import com.roomies.app.roomiesApp.models.TaskType;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.NoRepositoryBean;

@NoRepositoryBean
@Transactional
public interface TaskBaseRepository<T extends TaskImpl> extends JpaRepository<T, Long> {

	T getOne(Long id);

	List<T> findAll();

	List<T> findAll(Sort sort);

	Page<T> findAll(Pageable pageable);

	// @Query(value = "Select * from Taskimpl where userInChargeId= ?1",nativeQuery
	// = true)
	// List<T> findAllTaskOfUser(Long userId);

	// @Query(value="select t from #{#entityName} t where t.userInCharge = ?1 and
	// t.groupInfo= ?2")
	// List<T> findAllByUserInCharge(User userInCharge,Group groupinfo);

	void deleteByTaskId(Long id);

	@Query(value = "select t from #{#entityName} t where t.groupInfo = ?1 and t.taskType = ?2")
	List<T> findAllTaskByGroupAndType(Group groupInfo, TaskType Type);

	// @Query(value="select t from #{#entityName} t where t.groupInfo = ?1 and
	// t.taskType = ?2")
	// List<T> findAllToDoTaskBYGroup(Group groupInfo);
}
