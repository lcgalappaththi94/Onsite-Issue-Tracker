package com.lcg.mappers;

import com.lcg.models.Message;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class MessageMapper implements RowMapper<Message> {
    @Override
    public Message mapRow(ResultSet resultSet, int i) throws SQLException {
        Message message = new Message();
        message.setMessageId(resultSet.getInt("messageId"));
        message.setMessageBody(resultSet.getString("messageBody"));
        message.setSender(resultSet.getString("sender"));
        message.setReciever(resultSet.getString("receiver"));
        message.setRead(resultSet.getBoolean("isRead"));
        message.setTimeStamp(resultSet.getTimestamp("timeStamp"));
        return message;
    }
}
