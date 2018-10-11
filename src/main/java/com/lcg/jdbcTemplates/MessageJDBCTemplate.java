package com.lcg.jdbcTemplates;

import com.lcg.dao.MessageDAO;
import com.lcg.mappers.MessageMapper;
import com.lcg.models.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.util.List;


public class MessageJDBCTemplate implements MessageDAO {
    @Autowired
    MessageMapper messageMapper;

    private DataSource dataSource;
    private JdbcTemplate jdbcTemplateObject;

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
        this.jdbcTemplateObject = new JdbcTemplate(dataSource);
    }

    public boolean insertMessage(Message message) {
        try {
            String SQL = "insert into message (sender,receiver,messageBody,timeStamp,isRead) values (?,?,?,?,?)";
            jdbcTemplateObject.update(SQL, message.getSender(), message.getReciever(), message.getMessageBody(), message.getTimeStamp(), message.isRead());
            return true;
        } catch (Exception e) {
            System.out.println(e);
            return false;
        }
    }

    public List<Message> listMessages(String sender, String receiver) {
        List<Message> messages;
        String SQL;
        SQL = "select * from message where (sender='" + sender + "' AND receiver='" + receiver + "') OR (sender='" + receiver + "' AND receiver='" + sender + "')  ORDER BY messageID";
        messages = jdbcTemplateObject.query(SQL, messageMapper);
        return messages;
    }

    @Override
    public void alreadyRead(String receiver) {
        String SQL = "update message set isRead=1 where receiver='"+receiver+"'";
        jdbcTemplateObject.update(SQL);
    }

}