package com.crm.settings.dao;

import com.crm.settings.domain.User;
import java.util.List;

public interface UserDao {

    User login(User user);

    List<User> owner();
}
