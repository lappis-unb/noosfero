jQuery('#file').fileupload({
  add: function(e, data){
    data.context = jQuery(tmpl("template-upload", data.files[0]));
    jQuery('#media-upload-form').append(data.context);
    data.submit();
  },
  progress: function (e, data) {
    if (data.context) {
      progress = parseInt(data.loaded / data.total * 100, 10);
      data.context.find('.bar').css('width', progress + '%');
      data.context.find('.percentage').text(progress + '%');
    }
  }
});

function loadPublishedMedia() {
  var parent_id = jQuery('#published-media #parent_id').val();
  var q = jQuery('#published-media #q').val();
  var url = jQuery('#published-media').data('url');

  jQuery('#published-media').addClass('fetching');
  jQuery.ajax({
    url: url,
    data: {'parent_id': parent_id, 'q': q},
    dataType: 'html',
    success: function(response) {
      jQuery("#published-media .items").html(response);
      jQuery('#published-media').removeClass('fetching');
      updateViewAllLinks();
    },
    error: function(response, textStatus, xhr) {
      console.log(response);
      console.log(textStatus);
    }
  });
}

function updateViewAllLinks() {
  var parent_id = jQuery('#published-media #parent_id').val();
  var q = jQuery('#published-media #q').val();
  jQuery('#published-media .view-all').each(function(){
    var key = jQuery(this).data('key');
    var params = {parent_id: parent_id, q: q, key: key}
    var href = jQuery(this).attr('href');
    href = href.replace(/\?.*/, '?'+jQuery.param(params));
    jQuery(this).attr('href', href);
  });
}

jQuery('#published-media #parent_id').change(function(){ loadPublishedMedia() });

jQuery("#published-media #q").typeWatch({
  callback: function (value) { loadPublishedMedia() },
  wait: 750,
  highlight: true,
  captureLength: 2
});

jQuery("#published-media #q").bind('notext', function(){ loadPublishedMedia() });
