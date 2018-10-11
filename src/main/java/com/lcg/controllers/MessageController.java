package com.lcg.controllers;

import com.lcg.jdbcTemplates.MessageJDBCTemplate;
import com.lcg.models.Message;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.List;


@Controller
public class MessageController {

    @Autowired
    Message message;
    @Autowired
    private MessageJDBCTemplate messageContext;

    @ResponseBody
    @RequestMapping(value = "/sendMessage", method = RequestMethod.POST)
    public String addMessage(HttpServletRequest request){
        message.setSender((String)request.getSession().getAttribute("name"));
        message.setReciever(request.getParameter("receiver"));
        message.setMessageBody(request.getParameter("message"));
        message.setRead(false);
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        message.setTimeStamp(timestamp);

        if (messageContext.insertMessage(message)) {
            return "ok";
        } else {
            return "error";
        }
    }

    @ResponseBody
    @RequestMapping(value = "/loadMessages", method = RequestMethod.POST)
    public String loadMessages(HttpServletRequest request){
        String sender=(String)request.getSession().getAttribute("name");
        List<Message> messages=messageContext.listMessages(sender,request.getParameter("receiver"));

        Gson gson = new GsonBuilder().disableHtmlEscaping().create();
        String jsonString = gson.toJson(messages);
        return jsonString;
    }

    @RequestMapping(value = "/alreadyRead", method = RequestMethod.POST)
    public void alreadyRead(HttpServletRequest request){
        String me=(String)request.getSession().getAttribute("name");
        messageContext.alreadyRead(me);
    }

}
