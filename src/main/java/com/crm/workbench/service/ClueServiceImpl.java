package com.crm.workbench.service;

import com.crm.exceptions.DaoException;
import com.crm.settings.dao.UserDao;
import com.crm.utils.Convert;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.crm.vo.Pagination;
import com.crm.workbench.dao.*;
import com.crm.workbench.domain.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Resource
    private UserDao userDao;

    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;

    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;

    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    /* ========================================= clue ========================================= */

    @Override
    public Pagination<Clue> pageList(Clue clue) throws DaoException{
        int total = clueDao.total(clue);
        List<Clue> list = clueDao.clueList(clue);
        if (total!=0 && list==null) throw new DaoException("Clues query failed!");
        return new Pagination<>(total,list);
    }

    @Override
    public void save(Clue clue) throws DaoException {
        if (clueDao.insert(clue)!=1) throw new DaoException("Clue create failed!");
    }

    @Override
    public Clue detail(String id) {
        return clueDao.detail(id);
    }

    @Override
    public Map<String, Object> edit(String id) {
        Map<String,Object> map = new HashMap<>();
        map.put("list",userDao.owner());
        map.put("clue",clueDao.edit(id));
        return map;
    }

    @Override
    public void update(Clue clue) throws DaoException {
        if (clueDao.update(clue)!=1) throw new DaoException("Clue update failed!");
    }

    @Transactional
    @Override
    public void delete(String[] ids) throws DaoException {
        clueRemarkDao.deleteByClue(ids);
        clueActivityRelationDao.deleteByClue(ids);
        if (clueDao.delete(ids)!=ids.length) throw new DaoException("Clue delete failed!");
    }

    /* ========================================= remark ========================================= */

    @Override
    public List<ClueRemark> getRemarksByClueId(String clueId) {
        return clueRemarkDao.select(clueId);
    }

    @Override
    public void addRemark(ClueRemark remark) throws DaoException {
        if (clueRemarkDao.insert(remark)!=1) throw new DaoException("Save remark failed!");
    }

    @Override
    public void updateRemark(ClueRemark remark) throws DaoException {
        if (clueRemarkDao.update(remark)!=1) throw new DaoException("Update remark failed!");
    }

    @Override
    public void removeRemark(String id) throws DaoException {
        if (clueRemarkDao.delete(id)!=1) throw new DaoException("Delete remark failed!");
    }

    /* ========================================= activity ========================================= */

    @Override
    public void unbind(String id) throws DaoException {
        if (clueActivityRelationDao.delete(id)!=1) throw new DaoException("Delete clue and activity relation failed!");
    }

    @Override
    public void bind(String clueId,String[] activityIds) throws DaoException {
        List<ClueActivityRelation> list = new ArrayList<>();
        for (String activityId:activityIds) {
            list.add(new ClueActivityRelation(UUIDUtil.getUUID(),clueId,activityId));
        }
        if (clueActivityRelationDao.bind(list)!=activityIds.length) throw new DaoException("Bind activity failed!");
    }

    /* ========================== convert: customer + contacts + transaction ========================== */

    //if customer named by company doesn't exist, create one by convert clue info into new customer
    private Customer clue2Customer(Clue clue,HashMap<String,String> map) throws DaoException {
        String company = clue.getCompany();
        Customer customer = customerDao.select(company);
        if (customer==null) {
            try {
                customer = (Customer) Convert.o2o(clue,new Customer());
                customer.setId(UUIDUtil.getUUID());
                customer.setName(company);
                customer.setCreateBy(map.get("createBy"));
                customer.setCreateTime(map.get("createTime"));
            } catch (ClassNotFoundException|IllegalAccessException|InstantiationException|NoSuchFieldException e) {
                e.printStackTrace();
            }
            if (customerDao.insert(customer)!=1) throw new DaoException("Create customer failed!");
        }
        return customer;
    }

    //create contact by convert clue info into new contact
    private Contacts clue2Contact(Clue clue,HashMap<String,String> map) throws DaoException {
        Contacts contact = new Contacts();//contact can have the same name
        try {
            contact = (Contacts) Convert.o2o(clue,contact);
            contact.setId(UUIDUtil.getUUID());
            contact.setCustomerId(map.get("customerId"));
            contact.setCreateBy(map.get("createBy"));
            contact.setCreateTime(map.get("createTime"));
        } catch (ClassNotFoundException|IllegalAccessException|InstantiationException|NoSuchFieldException e) {
            e.printStackTrace();
        }
        if (contactsDao.insert(contact)!=1) throw new DaoException("Create contact failed!");
        return contact;
    }

    //get all clueRemark by clueId and convert the clueRemark into customerRemark and contactsRemark
    private void clue2Remark(String clueId,HashMap<String,String> map) throws DaoException {
        List<ClueRemark> clueRemarkList = clueRemarkDao.select(clueId);
        for(ClueRemark clueRemark:clueRemarkList) {
            String noteContent = clueRemark.getNoteContent();

            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setCreateBy(map.get("createBy"));
            customerRemark.setCreateTime(map.get("createTime"));
            customerRemark.setCustomerId(map.get("customerId"));
            if (customerRemarkDao.insert(customerRemark)!=1) throw new DaoException("Create customer remark failed!");

            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setCreateBy(map.get("createBy"));
            contactsRemark.setCreateTime(map.get("createTime"));
            contactsRemark.setContactsId(map.get("contactsId"));
            if (contactsRemarkDao.insert(contactsRemark)!=1) throw new DaoException("Create contact remark failed!");
        }
        //delete clue remark by clueId
        if (clueRemarkDao.deleteByClue(new String[] {clueId})!=clueRemarkList.size()) throw new DaoException("Delete clue remark failed!");
    }

    //convert clue_activity_relation into contacts_activity_relation
    private void clueRel2contactRel(String clueId,HashMap<String,String> map) throws DaoException {
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getActiviesByclueId(clueId);
        for (ClueActivityRelation clueActivityRelation:clueActivityRelationList) {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(map.get("contactsId"));
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            if (contactsActivityRelationDao.insert(contactsActivityRelation)!=1) throw new DaoException("Create relation between contact and activity failed!");
        }
        if (clueActivityRelationDao.deleteByClue(new String[] {clueId})!=clueActivityRelationList.size()) throw new DaoException("Delete relation between clue and activity failed!");
    }

    //create transaction and transaction history
    private void tran(Clue clue,Tran tran,HashMap<String,String> map) throws DaoException {
        if (tran.getMoney()!=null) {
            try {
                tran = (Tran) Convert.o2o(clue,tran);
                tran.setId(UUIDUtil.getUUID());
                tran.setCustomerId(map.get("customerId"));
                tran.setContactsId(map.get("contactsId"));
                tran.setCreateBy(map.get("createBy"));
                tran.setCreateTime(map.get("createTime"));
            } catch (ClassNotFoundException|IllegalAccessException|InstantiationException|NoSuchFieldException e) {
                e.printStackTrace();
            }
            if (tranDao.insert(tran)!=1) throw new DaoException("Create transaction failed!");

            TranHistory tranHistory = new TranHistory();
            try {
                tranHistory = (TranHistory) Convert.o2o(tran,tranHistory);
                tranHistory.setId(UUIDUtil.getUUID());
                tranHistory.setCreateBy(map.get("createBy"));
                tranHistory.setCreateTime(map.get("createTime"));
                tranHistory.setTranId(tran.getId());
            } catch (ClassNotFoundException|IllegalAccessException|InstantiationException|NoSuchFieldException e) {
                e.printStackTrace();
            }
            if (tranHistoryDao.insert(tranHistory)!=1) throw new DaoException("Create transaction history failed!");
        }
    }

    @Transactional
    @Override
    public void convert(String clueId, Tran tran) throws DaoException {

        Clue clue = clueDao.getClueById(clueId);

        HashMap<String,String> map = new HashMap<>();
        map.put("createBy",tran.getCreateBy());
        map.put("createTime",DateTimeUtil.getSysTime());

        Customer customer = clue2Customer(clue,map);
        map.put("customerId",customer.getId());

        Contacts contact = clue2Contact(clue,map);
        map.put("contactsId",contact.getId());

        clue2Remark(clueId,map);

        clueRel2contactRel(clueId,map);

        tran(clue,tran,map);

        //if (clueDao.delete(new String[] {clueId})!=1) throw new DaoException("Delete clue failed!");
    }






}
