$(function() {
  var bar = $('.bar');
  var percent = $('.percent');
  var resp = $('.main-content');

  $('.action-cms-upload_files form').ajaxForm({
    beforeSend: function() {
      var percentVal = '0%';
      bar.width(percentVal);
      percent.html(percentVal);
      $('.progress').css('display', 'block');
    },
    uploadProgress: function(event, position, total, percentComplete) {
      var percentVal = percentComplete + '%';
      bar.width(percentVal);
      percent.html(percentVal);
    },
    complete: function(xhr) {
      resp.html(xhr.responseText);
    }
  });
});
