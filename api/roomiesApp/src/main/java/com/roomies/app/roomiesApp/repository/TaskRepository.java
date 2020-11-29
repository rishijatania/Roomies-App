package com.roomies.app.roomiesApp.repository;

import javax.transaction.Transactional;

import com.roomies.app.roomiesApp.models.TaskImpl;

@Transactional
public interface TaskRepository extends TaskBaseRepository<TaskImpl> {
	TaskImpl save(TaskImpl task);

}
