(function($) {
  "use strict";


  function tree_toggle_link(e) {
    var parent_div = jQuery(this).parent().parent();
    var child_div = parent_div.children("div");

    if(child_div.css("display") == "none") {
      $(this).html("-");
    } else {
      $(this).html("+");
    }

    child_div.slideToggle('fast');
    e.preventDefault();
  }


  function set_events() {
    jQuery('.expand-all').click(tree_toggle_link);
  }


  $(document).ready(function() {
    set_events();
  });
}) (jQuery);
