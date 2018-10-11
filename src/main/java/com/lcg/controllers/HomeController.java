package com.lcg.controllers;

import com.lcg.models.Image;
import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

@Controller
public class HomeController {

    @RequestMapping(value = "/welcome", method = RequestMethod.GET)
    public String home() {
        return "welcome";
    }

    @RequestMapping(value = "/upload", method = RequestMethod.GET)
    public String showUpload() {
        return "upload";
    }


    @RequestMapping(value = "/getList", method = RequestMethod.GET)
    public String list() {
        return "upload";
    }

    @RequestMapping(value = {"/login", "/"}, method = RequestMethod.GET)
    public String showLogin() {
        return "login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(HttpServletRequest request) {
        if (request.getParameter("username").equals("lcg") && request.getParameter("password").equals("1234")) {
            request.getSession().setAttribute("category", "sup");
            request.getSession().setAttribute("name", "Chathura");
            return "welcome";
        } else if (request.getParameter("username").equals("chinthika") && request.getParameter("password").equals("12345")) {
            request.getSession().setAttribute("category", "emp");
            request.getSession().setAttribute("name", "Chinthika");
            return "welcome";
        } else
            return "login";
    }

    @RequestMapping(value = "/signUp", method = RequestMethod.GET)
    public String showSignup() {
        return "signup";
    }

    @RequestMapping(value = "/signUp", method = RequestMethod.POST)
    public String signup() {
        return "upload";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return "login";
    }

    @RequestMapping(value = "/inquiry", method = RequestMethod.GET)
    public String showInquiry(ModelMap modelMap) {
        File folder = new File("c:/onsiteImages/images/");
        ArrayList<Image> imageList = new ArrayList<>();
        File[] listOfFiles = folder.listFiles();
        Arrays.sort(listOfFiles);

        for (int i = 0; i < listOfFiles.length; i++) {
            if (listOfFiles[i].isFile()) {
                try {
                    Gson gson = new Gson();
                    FileReader fr = new FileReader("c:/onsiteImages/json/" + listOfFiles[i].getName() + ".json");
                    Image image = gson.fromJson(fr, Image.class);
                    imageList.add(image);
                    fr.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        modelMap.put("imageList", imageList);
        return "inquiry";
    }

    @RequestMapping(value = "/removeNotification", method = RequestMethod.GET)
    public void removeNotification() {

    }

    @RequestMapping(value = "/message", method = RequestMethod.GET)
    public String showMessage() {
       return "message";
    }

}
