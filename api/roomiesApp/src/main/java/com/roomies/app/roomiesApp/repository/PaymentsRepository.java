package com.roomies.app.roomiesApp.repository;

import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import com.roomies.app.roomiesApp.models.Group;
import com.roomies.app.roomiesApp.models.Payments;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
@Transactional
public interface PaymentsRepository extends JpaRepository<Payments, Long> {

	Payments save(Group group);

	Optional<Payments> findById(Long id);

	@Query(value = "Select * from payments as p inner join PaymentsPending as pp on p.id=pp.Payments_id where pp.usersPaymentPending_id=?1", nativeQuery = true)
	List<Payments> getAllPendingPaymentsByUser(Long id);

	@Query(value = "Select * from payments as p inner join PaymentsReceived as pr on p.id=pr.Payments_id where pr.usersPaymentReceived_id=?1", nativeQuery = true)
	List<Payments> getAllPaidPaymentsByUser(Long id);

	@Query(value = "Select * from payments as p  where item_id in (select taskId from item where boughtBy_id=?1)", nativeQuery = true)
	List<Payments> getAllUserBoughtItems(Long id);

}
