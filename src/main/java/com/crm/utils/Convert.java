package com.crm.utils;

import java.lang.reflect.Field;

public class Convert {

    public static Object o2o (Object from, Object to) throws ClassNotFoundException, IllegalAccessException, InstantiationException, NoSuchFieldException {
        Class clueClass = from.getClass();//get clue class
        Class objectClass = to.getClass();

        Field[] clueFields = clueClass.getDeclaredFields();//get all fields of clue class
        Field[] objectFields = objectClass.getDeclaredFields();

        for (int i = 1; i < clueFields.length; i++) {
            String clueFieldName = clueFields[i].getName();
            for (int j = 1; j < objectFields.length; j++) {
                String objFieldName = objectFields[j].getName();
                if (objFieldName.equals(clueFieldName)) {
                    Field objField = objectClass.getDeclaredField(objFieldName);//get field of object class
                    objField.setAccessible(true);
                    Field clueField = clueClass.getDeclaredField(clueFieldName);
                    clueField.setAccessible(true);
                    objField.set(to,clueField.get(from));
                    break;
                }
            }
        }

        return to;
    }


}
