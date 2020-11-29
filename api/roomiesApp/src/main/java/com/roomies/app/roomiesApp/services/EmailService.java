package com.roomies.app.roomiesApp.services;

import java.util.Date;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.roomies.app.roomiesApp.models.Group;
import com.roomies.app.roomiesApp.models.User;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
	private static final Logger log = LoggerFactory.getLogger(EmailService.class);

	@Autowired
	UserDetailsServiceImpl userDetailsServiceImpl;

	private JavaMailSender mailSender;
	public static final Pattern VALID_EMAIL_ADDRESS_REGEX = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$",
			Pattern.CASE_INSENSITIVE);

	@Autowired
	public EmailService(JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}

	@Async
	public void sendEmail(SimpleMailMessage email) {
		mailSender.send(email);
	}

	public static boolean validate(String emailStr) {
		Matcher matcher = VALID_EMAIL_ADDRESS_REGEX.matcher(emailStr);
		return matcher.find();
	}

	public String sendEmailToUsers(User user, Set<String> recipentList) {
		Group group = userDetailsServiceImpl.getCurrentUserFromSession().getGroupInfo();
		try {
			for (String recipent : recipentList) {
				if (validate(recipent)) {
					SimpleMailMessage registrationEmail = new SimpleMailMessage();
					registrationEmail.setTo(recipent);
					registrationEmail.setSubject("Invited to Join Group On Roomies APP");
					registrationEmail.setText("Your invited to join the Group " + group.getGroupName() + " by "
							+ user.getFirstName() + " " + user.getLastName() + " on Roomies App"
							+ "You can join the group using the follwong Group-ID " + group.getGroupId());
					registrationEmail.setFrom("noreply@roomiesApp.com");
					registrationEmail.setSentDate(new Date());

					sendEmail(registrationEmail);
				}
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			return e.getMessage();
		}
		return "success";
	}
}
