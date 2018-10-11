package com.lcg.dao;

import com.lcg.models.Message;

import javax.sql.DataSource;
import java.util.List;

public interface MessageDAO {
    void setDataSource(DataSource ds);

    boolean insertMessage(Message hotel);

    List<Message> listMessages(String sender, String receiver);

    void alreadyRead(String receiver);
}
