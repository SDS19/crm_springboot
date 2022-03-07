package com.crm.settings.service;

import com.crm.exceptions.LoginException;
import com.crm.settings.domain.User;

import java.util.List;

public interface UserService {

    User login(User user) throws LoginException;

    List<User> owner();

}
