package com.crm.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {
	//get current system time
	public static String getSysTime(){
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
	}
	//validate user expired or not
	public static boolean expire(String expireTime){
		return expireTime.compareTo(getSysTime()) < 0;
	}
}
