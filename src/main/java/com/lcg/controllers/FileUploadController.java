package com.lcg.controllers;


import com.lcg.models.Image;
import com.lcg.models.Tag;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.util.Arrays;

@Controller
public class FileUploadController {
    /**
     * Upload single file using Spring Controller
     */
    @RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
    String uploadFileHandler(@RequestParam("image_file") MultipartFile file, HttpServletRequest request, ModelMap model) {
        if(request.getSession().getAttribute("name")!=null) {
            if (!file.isEmpty()) {
                try {
                    byte[] bytes = file.getBytes();
                    // Creating the directory to store file
                    String folderPath = "c:/onsiteImages/";
                    File dir = new File(folderPath);
                    if (!dir.exists())
                        dir.mkdirs();

                    // Create the file on server
                    String fileName = IDGenerator.idGenarator("I", getLastId(folderPath + File.separator + "images"));
                    fileName = fileName + ".jpeg";
                    File serverFile = new File(folderPath + File.separator + "images" + File.separator + fileName);
                    BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(serverFile));
                    stream.write(bytes);
                    stream.close();

                    try {
                        Image current = new Image();
                        int x1 = Integer.parseInt(request.getParameter("initialX"));
                        int y1 = Integer.parseInt(request.getParameter("initialY"));
                        int w = Integer.parseInt(request.getParameter("width"));
                        int h = Integer.parseInt(request.getParameter("height"));
                        String description = request.getParameter("description");
                        String resolution = request.getParameter("resolution");
                        String author = (String) request.getSession().getAttribute("name");
                        String tags = request.getParameter("tags");


                        String[] tag = tags.trim().split("/");
                        Tag[] tagArr = new Tag[tag.length / 3];

                        int pointer = 0;
                        for (int i = 0; i < tagArr.length; i++) {
                            Tag newTag = new Tag();
                            newTag.setX(Integer.parseInt(tag[pointer++]) + 2);
                            newTag.setY(Integer.parseInt(tag[pointer++]) + 2);
                            newTag.setDescription(tag[pointer++]);
                            tagArr[i] = newTag;

                        }

                        current.setName(fileName);
                        if (w != 2 && h != 2) {
                            current.setInitialX(x1);
                            current.setInitialY(y1);
                            current.setWidth(w);
                            current.setHeight(h);
                        }
                        current.setDescription(description);
                        current.setAuthor(author);
                        current.setTags(tagArr);
                        current.setResolution(resolution);

                        Gson gson = new GsonBuilder().setPrettyPrinting().create();
                        String jsonInString = gson.toJson(current);

                        FileWriter fileWriter = new FileWriter(folderPath + File.separator + "json" + File.separator + fileName + ".json");
                        fileWriter.write(jsonInString);
                        fileWriter.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    model.put("msg", "You successfully uploaded file=" + fileName);
                    return "welcome";

                } catch (Exception e) {
                    model.put("msg", "You failed to upload => " + e.getMessage());
                    return "upload";
                }
            } else {
                model.put("msg", "You failed to upload  because the file was empty.");
                return "upload";
            }
        }else {
            model.put("msg", "You failed to upload  session timed out.");
            return "upload";
        }
    }


    public String getLastId(String path) {
        File folder = new File(path);
        File[] listOfFiles = folder.listFiles();
        if (listOfFiles.length > 0) {
            Arrays.sort(listOfFiles);
            return listOfFiles[listOfFiles.length - 1].getName().substring(0, 10);
        } else {
            return "I000000000";
        }

    }

}
