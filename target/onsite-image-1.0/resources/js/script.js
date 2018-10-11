var tagText = "";

// convert bytes into friendly format
function bytesToSize(bytes) {
    var sizes = ['Bytes', 'KB', 'MB'];
    if (bytes == 0) return 'n/a';
    var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
    return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
};

// check for selected crop region
function checkForm() {
    if (parseInt($('#w').val())) return true;
    $('.error').html('Please select a crop region and then press Upload').show();
    return false;
};

// update info by cropping (onChange and onSelect events handler)
function updateInfo(e) {
    $('#x1').val(e.x);
    $('#y1').val(e.y);
    $('#x2').val(e.x2);
    $('#y2').val(e.y2);
    $('#w').val(e.w);
    $('#h').val(e.h);
};

// clear info by cropping (onRelease event handler)
function clearInfo(e) {
    //$('.info #w').val('');
    //$('.info #h').val('');
    var tag = prompt("Please enter a tag to location X:" + e.x + " & Y: " + e.y);
    if (tag !== null) {
        tagText += e.x + "/" + e.y + "/" + tag + "/";
        $('#tags').val(tagText);
    } else {

    }
};

// Create variables (in this scope) to hold the Jcrop API and image size
var jcrop_api, boundx, boundy;

function fileSelectHandler() {

    // get selected file
    var oFile = $('#image_file')[0].files[0];

    // hide all errors
    $('.error').hide();

    // check for image type (jpg and png are allowed)
    var rFilter = /^(image\/jpeg|image\/png|image\/jpg)$/i;
    if (!rFilter.test(oFile.type)) {
        $('.error').html('Please select a valid image file (jpg and png are allowed)').show();
        return;
    }

    // check for file size
    if (oFile.size > 2048 * 1024) {
        $('.error').html('You have selected too big file, please select a one smaller image file').show();
        return;
    }

    // preview element
    var oImage = document.getElementById('preview');

    // if (oImage.naturalWidth > 1280 && oImage.naturalHeight > 720) {
    //     $('.error').html('You have selected an image with very high resolution(>720P), please select a one smaller image file').show();
    //     return;
    // }

    // prepare HTML5 FileReader
    var oReader = new FileReader();
    oReader.onload = function (e) {

        // e.target.result contains the DataURL which we can use as a source of the image
        oImage.src = e.target.result;

        
        var windowHeight = $(window).height() * (5 / 6);
        var windowWidth = $(window).width() * (5 / 6);
        var widthRatio = 1;
        var heightRatio = 1;
        if (oImage.width > windowWidth) {
            widthRatio = windowWidth / oImage.width;
        }
        if (oImage.height > windowHeight) {
            heightRatio = windowHeight / oImage.width;
        }
        oImage.width =oImage.width*widthRatio;
        oImage.height = oImage.height * heightRatio;


        oImage.onload = function () { // onload event handler
            // display step 2

            $('.step2').fadeIn(500);

            // display some basic image info
            var sResultFileSize = bytesToSize(oFile.size);
            $('#filesize').val(sResultFileSize);
            $('#filetype').val(oFile.type);
            $('#filedim').val(oImage.naturalWidth + ' x ' + oImage.naturalHeight);
            $('#resolution').val(oImage.naturalWidth + 'x' + oImage.naturalHeight);

            // destroy Jcrop if it is existed
            if (typeof jcrop_api != 'undefined') {
                jcrop_api.destroy();
                jcrop_api = null;
                $('#preview').width(oImage.naturalWidth);//oImage.naturalWidth
                $('#preview').height(oImage.naturalHeight);//oImage.naturalHeight
            }

            setTimeout(function () {
                // initialize Jcrop
                $('#preview').Jcrop({
                    minSize: [2, 2], // min crop size
                    // aspectRatio : 1, // keep aspect ratio 1:1
                    bgFade: true, // use fade effect
                    bgOpacity: .7, // fade opacity
                    onChange: updateInfo,
                    onSelect: updateInfo,
                    onDblClick: clearInfo
                }, function () {

                    // use the Jcrop API to get the real image size
                    var bounds = this.getBounds();
                    boundx = bounds[0];
                    boundy = bounds[1];

                    // Store the Jcrop API in the jcrop_api variable
                    jcrop_api = this;
                });
            }, 1000);

        };
    };

    // read selected file as DataURL
    oReader.readAsDataURL(oFile);
}