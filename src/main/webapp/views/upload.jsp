<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<script src="/resources/js/jquery.min.js"></script>
<script src="/resources/js/jquery.Jcrop.js"></script>
<script src="/resources/js/script.js"></script>

<link rel="stylesheet" href="/resources/demo_files/main.css" type="text/css"/>
<link rel="stylesheet" href="/resources/demo_files/demos.css"
      type="text/css"/>
<link rel="stylesheet" href="/resources/css/jquery.Jcrop.css"
      type="text/css"/>
<link href="/resources/css/main.css" rel="stylesheet" type="text/css"/>

<script type="text/javascript">

    function loadSupervisors() {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("Suplist").innerHTML = xmlhttp.responseText;
            }
        };
        xmlhttp.open("POST", "getlist.php?q=1", true);
        xmlhttp.send();
    }
</script>

<body> onload="loadSupervisors()"
<h2>${msg}</h2>

<header>
    <h2><a href="/home">Back To Welcome page</a> Or <a href="logout.php">Log Out</a></h2>
</header>


<div class="demo">
    <div class="bheader"><h2>Select image to upload</h2></div>
    <div class="bbody">

        <!-- upload form -->
        <form id="upload_form" enctype="multipart/form-data" method="POST" action="uploadFile">

            <h2>Step 1: Please select image file</h2>
            <div><input type="file" name="image_file" id="image_file" onchange="fileSelectHandler()"/></div>

            <div class="error"></div>

            <div class="step2">
                <h2>Step 2: Please add tags for points(DoubleClick on the point)</h2>
                <h2>Step 3: Please select a region (Click and drag from a point)</h2>
                <img id="preview"/>

                <div class="info">
                    <label>File size</label> <input type="text" id="filesize" name="filesize"/>
                    <label>Type</label> <input type="text" id="filetype" name="filetype"/>
                    <label>Image dimension</label> <input type="text" id="filedim" name="filedim"/>
                </div>

                <label>Enter Description</label>
                <textarea name="description" rows="4" cols="50" placeholder="enter a description"></textarea>
                <br>

                <label>Tag the supervisor</label>
                <select id="Suplist" name="supervisor"> </select>
                <br><br>

                <input type="hidden" id="x1" name="initialX">
                <input type="hidden" id="y1" name="initialY">
                <input type="hidden" id="w" name="width">
                <input type="hidden" id="h" name="height">
                <input type="hidden" id="tags" name="tags">
                <input type="hidden" id="resolution" name="resolution">

                <input type="submit" name="submit" value="Upload"/>
            </div>
        </form>
    </div>
</div>

</body>
</html>
