(function($) {
  function highlight_table_row(evt) {
    var row_number = parseInt($("#highlights-data-table tr.image-data-line:last").data('row-number'));
    var row_data = $(".highlight-table-row tbody tr").clone();
    var selectInputId = 'select-input-' + (row_number+1 || 0);

    row_data.attr("data-row-number", row_number+1 || 0);
    row_data.find('.select-input').attr('id', selectInputId);

    $("#highlights-data-table").append(row_data);
    $(".delete-highlight").on("confirm:complete", delete_highlight);

    new window.noosfero.SelectInput(selectInputId);
    return false;
  }

  function delete_highlight(evt, answer) {
    if(answer) {
      var row_number = parseInt($(this).parent().parent().attr("data-row-number"));

      if(row_number != NaN) {
        $("#highlights-data-table tr[data-row-number="+row_number+"]").remove();
      }
    }

    return false;
  }

  $(document).ready(function(){
    $(".new-highlight-button").click(highlight_table_row);
    $(".delete-highlight").on("confirm:complete", delete_highlight);
  });
})(jQuery);
