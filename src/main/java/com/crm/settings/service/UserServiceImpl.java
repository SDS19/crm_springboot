package com.crm.settings.service;

import com.crm.exceptions.LoginException;
import com.crm.settings.dao.UserDao;
import com.crm.settings.domain.User;
import com.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;

@Service
public class UserServiceImpl implements UserService{

    @Resource
    private UserDao userDao;

    @Override
    public User login(User user) throws LoginException {
        User result = userDao.login(user);
        if (result==null) throw new LoginException("Account or password wrong!");
        if (DateTimeUtil.expire(result.getExpireTime())) throw new LoginException("Account expire!");
        if ("0".equals(result.getLockState())) throw new LoginException("Account is locked!");
        String allowIps = result.getAllowIps();
        if ("".equals(allowIps) && allowIps!=null && !allowIps.contains(user.getAllowIps())) throw new LoginException("This IP is restricted to login!");
        return result;
    }

    @Override
    public List<User> userList() {
        return null;
    }
}
