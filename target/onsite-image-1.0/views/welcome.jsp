<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>Welcome </title>
</head>

<script type="text/javascript">
    function loadInquiries() {
        modal1 = document.getElementById('myModal');
        span = document.getElementsByClassName("close")[0];
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                if (xmlhttp.responseText != '0') {
                    document.getElementById("notification").innerHTML = " (" + xmlhttp.responseText + ")";
                }
                setTimeout(loadInquiries, 1000);
            }
        };
        xmlhttp.open("POST", "/getList", true);
        xmlhttp.send();
    }
</script>

<body <% if(request.getSession().getAttribute("category").equals("sup")){%>onload='loadInquiries()'<%}%>>
<h2>${msg}</h2>
<h1>Welcome Back <%=request.getSession().getAttribute("name")%>
</h1>
<h2><a href="/inquiry"><% if (request.getSession().getAttribute("category").equals("emp")) {%>My inquiries<%
    } else {

    }
%></a></h2>

<h2><a <% if(request.getSession().getAttribute("category").equals("emp")){%>href='/upload' <%}else{%>href='/inquiry'
       }<%}%>>
    <% if (request.getSession().getAttribute("category").equals("emp")) {%>Post a inquiry<%} else {%>See
    inquiries<%}%></a>
    <span style="color:red;" id="notification"></span></h2>

<h2><a href="/message">Message</a></h2>

<h2><a href="/logout">Log Out</a></h2>
</body>

</html>