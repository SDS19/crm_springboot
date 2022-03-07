package com.crm.vo;

import java.util.List;

public class Pagination<E> {
    private int total;
    private List<E> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<E> getDataList() {
        return dataList;
    }

    public void setDataList(List<E> dataList) {
        this.dataList = dataList;
    }

    public Pagination() {
    }

    public Pagination(int total, List<E> dataList) {
        this.total = total;
        this.dataList = dataList;
    }
}
