<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>Message</title>
    <link rel="stylesheet" href="/resources/bootstrap-3.3.7/css/bootstrap.min.css">
    <script src="/resources/js/jquery.min.js"></script>
    <script src="/resources/bootstrap-3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        function loadMessages() {
            var receiver = $('#to').val();
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    var messageList = xmlhttp.responseText;
                    messageList = $.parseJSON(messageList);
                    var html = "";
                    $.each(messageList, function (i, index) {
                        if (index.sender != receiver) {
                            html += '<li style="width:100%">' +
                                '<div class="msj macro">' +
                                '<div class="avatar"><b style="color: #002a80"><i>You</i></b></div>' +
                                '<div class="text text-l">' +
                                '<p><b>' + index.messageBody + '</b></p>' +
                                '<p><small>' + index.timeStamp + '</small></p>' +
                                '</div>' +
                                '</div>' +
                                '</li>';
                        } else {
                            if (index.isRead == 0) {
                                html += '<li style="width:100%;">' +
                                    '<div class="msj-rta macro">' +
                                    '<div class="text text-r">' +
                                    '<p style="color:red;"><b>' + index.messageBody + '</b></p>' +
                                    '<p><small>' + index.timeStamp + '</small></p>' +
                                    '</div>' +
                                    '<div class="avatar" style="padding:0px 0px 0px 10px !important"><b style="color: #002a80"><i>' + index.sender + '</i></b></div>' +
                                    '</li>';
                            } else {
                                html += '<li style="width:100%;">' +
                                    '<div class="msj-rta macro">' +
                                    '<div class="text text-r">' +
                                    '<p><b>' + index.messageBody + '</b></p>' +
                                    '<p><small>' + index.timeStamp + '</small></p>' +
                                    '</div>' +
                                    '<div class="avatar" style="padding:0px 0px 0px 10px !important"><b style="color: #002a80"><i>' + index.sender + '</i></b></div>' +
                                    '</li>';
                            }
                        }
                    });
                    $("ul").html(html);
                    setTimeout(loadMessages, 750);
                }
            };
            xmlhttp.open("POST", "/loadMessages?receiver=" + receiver, true);
            xmlhttp.send();
        }

        function sendMessage(event) {
            var message = $("#messageBox").val();
            if (message != "") {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    var receiver = $('#to').val();
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function () {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            if (xmlhttp.responseText == "ok") {
                                $("#messageBox").val("");
                                loadMessages();
                            }
                        }
                    };
                    xmlhttp.open("POST", "/sendMessage?receiver=" + receiver + "&message=" + message, true);
                    xmlhttp.send();
                }
            }
        }

        function alreadyRead() {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    loadMessages();
                }
            };
            xmlhttp.open("POST", "/alreadyRead", true);
            xmlhttp.send();
        }

    </script>

    <style type="text/css">
        .mytext {
            border: 0;
            padding: 10px;
            background: whitesmoke;
        }

        .text {
            width: 75%;
            display: flex;
            flex-direction: column;
        }

        .text > p:first-of-type {
            width: 100%;
            margin-top: 0;
            margin-bottom: auto;
            line-height: 13px;
            font-size: 12px;
        }

        .text > p:last-of-type {
            width: 100%;
            text-align: right;
            color: silver;
            margin-bottom: -7px;
            margin-top: auto;
        }

        .text-l {
            float: left;
            padding-right: 10px;
        }

        .text-r {
            float: right;
            padding-left: 10px;
        }

        .avatar {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 25%;
            float: left;
            padding-right: 10px;
        }

        .macro {
            margin-top: 5px;
            width: 85%;
            border-radius: 5px;
            padding: 5px;
            display: flex;
        }

        .msj-rta {
            float: right;
            background: whitesmoke;
        }

        .msj {
            float: left;
            background: white;
        }

        .frame {
            background: #e0e0de;
            height: 450px;
            overflow: hidden;
            padding: 0;
        }

        .frame > div:last-of-type {
            position: absolute;
            bottom: 5px;
            width: 100%;
            display: flex;
        }

        ul {
            width: 100%;
            list-style-type: none;
            padding: 18px;
            position: absolute;
            bottom: 32px;
            display: flex;
            flex-direction: column;

        }

        .msj:before {
            width: 0;
            height: 0;
            content: "";
            top: -5px;
            left: -14px;
            position: relative;
            border-style: solid;
            border-width: 0 13px 13px 0;
            border-color: transparent #ffffff transparent transparent;
        }

        .msj-rta:after {
            width: 0;
            height: 0;
            content: "";
            top: -5px;
            left: 14px;
            position: relative;
            border-style: solid;
            border-width: 13px 13px 0 0;
            border-color: whitesmoke transparent transparent transparent;
        }

        input:focus {
            outline: none;
        }

        ::-webkit-input-placeholder { /* Chrome/Opera/Safari */
            color: #d4d4d4;
        }

        ::-moz-placeholder { /* Firefox 19+ */
            color: #d4d4d4;
        }

        :-ms-input-placeholder { /* IE 10+ */
            color: #d4d4d4;
        }

        :-moz-placeholder { /* Firefox 18- */
            color: #d4d4d4;
        }
    </style>
</head>

<body onload="loadMessages()">
<h1>Message Page</h1>
<input type="text" id="to" placeholder="Enter receiver"/>

<div class="col-sm-4 col-sm-offset-4 frame">
    <ul></ul>
    <div>
        <div class="msj-rta macro" style="margin:auto">
            <div class="text text-r" style="background:#a6e1ec !important">
                <input class="mytext" id="messageBox" onkeypress="sendMessage(event)" onfocus="alreadyRead()"
                       placeholder="Type a message"/>
            </div>
        </div>
    </div>
</div>

</body>
</html>
