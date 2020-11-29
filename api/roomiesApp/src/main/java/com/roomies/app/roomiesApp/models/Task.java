package com.roomies.app.roomiesApp.models;

public interface Task<T> extends Comparable<T> {

	@Override
	int compareTo(T o);

}
