(function($, undefined) {
  $(document).ready(function() {
    var article_type = $('#type');
    var article_body = $('#article_body');

    var hasArticle = article_body.length !== 0;
    var hasType = article_type.length !== 0;
    var isWorkAssignment = article_type.val() === "WorkAssignmentPlugin::WorkAssignment";

    if(hasArticle && hasType && isWorkAssignment) {
      article_body.addClass('tiny_mce_simple');
    }
  });
}) (jQuery);
