(function($) {
  "use strict";

  function tree_toggle_link(e) {
    var parent_div = jQuery(this).parent().parent();
    var child_div = parent_div.children("div");
    console.log(child_div);
    if(child_div.css("display") == "none") {
      $(this).find( 'img' ).attr('src', $(this).find('img').attr('src').replace("plus", "minus") );
      $(this).find( 'img' ).attr('alt', $(this).find('img').attr('alt').replace("+", "-") );
    } else {
      $(this).find( 'img' ).attr('src', $(this).find('img').attr('src').replace("minus", "plus") );
      $(this).find( 'img' ).attr('alt', $(this).find('img').attr('alt').replace("-", "+") );
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
