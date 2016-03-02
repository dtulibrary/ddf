/**
* Activate jQuery autocomplete
**/
$(function() {
  $("[data-autocomplete-enabled='true']").autocomplete({
    source: function(request, response){
      $.ajax({
        url: $("[data-autocomplete-enabled='true']").data('autocompletePath'),
        data: { q: request.term },
        dataType: 'json',
        success: function(data){
          response($.map(data,function(item){
            return {
              label: item.term,
              value: item.term
            }
          }));
        },
        error: function(){
          console.log("error");
          response([]);
        }
      });
    },
    minLength: 2
  });
});
