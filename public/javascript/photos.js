var fileUploadErrors = {
    maxFileSize: 'File is too big',
    minFileSize: 'File is too small',
    acceptFileTypes: 'Filetype not allowed',
    maxNumberOfFiles: 'Max number of files exceeded',
    uploadedBytes: 'Uploaded bytes exceed file size',
    emptyResult: 'Empty file upload result'
};

$(document).ready(function () {
        // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload();
        // 
        // Load existing files:
    $.getJSON($('#fileupload').prop('action'), function (files) {
	alert('thurk');

        var fu = $('#fileupload').data('fileupload'), 
	template;
        fu._adjustMaxNumberOfFiles(-files.length);
        template = fu._renderDownload(files)
            .appendTo($('#fileupload .files'));
          // Force reflow:
          fu._reflow = fu._transition && template.length &&
            template[0].offsetWidth;
        template.addClass('in');
        $('#loading').remove();
    });
});
