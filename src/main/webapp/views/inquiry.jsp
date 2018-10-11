<%@ page import="com.lcg.models.Image" %>
<%@ page import="com.lcg.models.Tag" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Inquiries</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/resources/bootstrap-3.3.7/css/bootstrap.min.css">
    <script src="/resources/js/jquery.min.js"></script>
    <script src="/resources/bootstrap-3.3.7/js/bootstrap.min.js"></script>
</head>


<style type="text/css">
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    .map {
        /*margin: 10px;*/
        /*border: 1px solid red;*/
        position: relative;
        display: inline-block;

    }

    .map img {
        max-width: 100%;
        display: block;
    }

    .box {
        width: 5%;
        height: 5%;
        background: url(/resources/images/navigation.svg) no-repeat top center;
        background-size: contain;
        position: absolute;
    }

    .pin-text {
        position: absolute;
        top: 50%;
        transform: translateY(-55%);
        left: 50%;
        white-space: nowrap;
        display: none;
        background: black;
    }

    .pin-text h3 {
        color: white;
        text-shadow: 1px 1px 1px #000;
    }

    .box:hover > .pin-text {
        display: block;
    }
</style>


<script type="text/javascript">
    var currentImg;
    $(window).resize(function () {
        runthis(currentImg);
    });

    function init() {
        $("#display").hide();
        $('.pin-text').hide();
        $("#mapList").html(" ");
        $('input[type=checkbox]').attr('checked', false);
        $("html, body").animate({scrollTop: 0}, "slow");
        currentImg = null;
    }

    function removeNotification(entry) {
        // $.ajax({
        //     url: '/getImageList',
        //     type: "POST",
        //     dataType: "json",
        //     success: function (data) {
        //         alert(data);
        //     }
        // });

        // var xmlhttp = new XMLHttpRequest();
        // xmlhttp.onreadystatechange = function () {
        //     if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        //         document.getElementById("list").innerHTML = xmlhttp.responseText;
        //     }
        // };
        // xmlhttp.open("POST", "/removeNotification?entry=" + entry, true);
        // xmlhttp.send();
    }


    function showTagText() {
        if ($('input[type=checkbox]').prop('checked')) {
            $('.pin-text').show();
        } else {
            $('.pin-text').hide();
        }
    }

    function runthis(data) {
        currentImg = data;
        var windowHeight = $(window).height() * (5 / 6);
        var windowWidth = $(window).width() * (5 / 6);
        var startX = data.getAttribute("startX");
        var startY = data.getAttribute("startY");
        var width = data.getAttribute("width");
        var height = data.getAttribute("height");
        var resolution = data.getAttribute("resolution").split("x");
        var naturalWidth = resolution[0];
        var naturalHeight = resolution[1];
        var widthRatio = 1;
        var heightRatio = 1;
        if (naturalWidth > windowWidth) {
            widthRatio = windowWidth / naturalWidth;
        }
        if (naturalHeight > windowHeight) {
            heightRatio = windowHeight / naturalHeight;
        }

        $("#display").show();
        $('input[type=checkbox]').attr('checked', false);
        $('.pin-text').hide();
        $('html,body').animate({scrollTop: $("#display").offset().top}, 'slow');
        $("#mapList").html(" ");

        var count = 1;
        while (data.getAttribute("tag" + count + "") != null) {
            var currentTag = data.getAttribute("tag" + count + "");
            var arr = currentTag.split(",");
            $("#mapList").append("<div style='top:" + arr[1] * heightRatio + "px ;left:" + (arr[0] * widthRatio - arr[3]) + "px ;' class='box'><div class='pin-text'><h3>&nbsp;" + arr[2] + "&nbsp;</h3></div></div>");
            count++;
        }

        document.getElementById("des").innerHTML = data.getAttribute("Description");
        document.getElementById("imge").src = "/files/images/" + data.getAttribute("source");

        if (data.getAttribute("category") == "sup") {
            document.getElementById("person").innerHTML = data.getAttribute("emp");
            document.getElementById("category").innerHTML = "Employee";
        } else {
            document.getElementById("person").innerHTML = data.getAttribute("sup");
            document.getElementById("category").innerHTML = "Supervisor";
        }

        var c = document.getElementById("myCanvas");
        var ctx = c.getContext("2d");
        var img = document.getElementById("imge");
        c.width = img.width;
        c.height = img.height;

        ctx.clearRect(0, 0, c.width, c.height);
        ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, img.width * widthRatio, img.height * heightRatio);
        ctx.lineWidth = 5;
        ctx.strokeRect(startX * widthRatio, startY * heightRatio, width * widthRatio, height * heightRatio);
        var entry = data.getAttribute("entry");
        removeNotification(entry);
    }

    function goBack() {
        $("#display").hide();
        $('.pin-text').hide();
        $("#mapList").html(" ");
        $("html, body").animate({scrollTop: 0}, "slow");
        $('input[type=checkbox]').attr('checked', false);
        currentImg = null;
    }
</script>

<body onload="init()">
<div class="container">
    <h1>Inquiry List</h1>
    <div id="list">
        <%
            ArrayList<Image> imageList = (ArrayList<Image>) request.getAttribute("imageList");
            if (imageList.size() == 0) {
                out.print("<h3>Nothing Found!!!</h3>");
            } else {
                for (Image current : imageList) {
                    String tagText = "<div class='col-sm-4 col-lg-4 col-md-4'>" +
                            "<div class='thumbnail'>" +
                            "<img height='100px' src='/files/images/" + current.getName() + "' hidden>" +
                            "<div class='caption'>" +
                            "<h4 class='pull-right'></h4>" +
                            "<h3>Employee: " + current.getAuthor() + " </h3>" +
                            "<h5> Description: " + current.getDescription() + "</h5>" +
                            "<button type='button' class='btn btn-success' onclick='runthis(this)' resolution='" + current.getResolution() + "' startX='" + current.getInitialX() + "' startY='" + current.getInitialY() + "' height='" + current.getHeight() + "' width='" + current.getWidth() + "' emp='" + current.getAuthor() + "' description='" + current.getDescription() + "' category='sup' source='" + current.getName() + "' entry='" + "12" + "' ";

                    int i = 0;
                    for (Tag tag : current.getTags()) {

                        int naturalWidth = Integer.parseInt(current.getResolution().split("x")[0]);  //fine tuning
                        int adjust = (int) (7.0 * naturalWidth / 765);

                        tagText += "tag" + (++i) + "='" + (tag.getX()) + "," + (tag.getY()) + "," + tag.getDescription() + "," + adjust + "' ";
                    }
                    tagText += ">Show More</button></div></div></div>";
                    out.print(tagText);
                }
            }
        %>
    </div>
</div>

<hr>

<div class="container-fluid" id="display">
    <button onclick="goBack()" type="button" class="btn btn-success" style="float: right">Go Back</button>&nbsp;
    <h2><span id="category"></span>: <span id="person"></span></h2>
    <h2>Description: <span id="des"></span></h2>

    <div class="checkbox">
        <label><input type="checkbox" onchange="showTagText()" value="">Show All Tag Text</label>
    </div>

    <img id="imge" hidden>
    <div class="map">
        <canvas id="myCanvas"></canvas>
        <div id="mapList"></div>
    </div>
</div>
<hr>

<h2><a href="/welcome">Back To Welcome page</a></h2>
<h2><a href="/logout">Log Out</a></h2>
</body>

</html>
