
$(document).ready(function() {

  rest = $(".chartlist.types li")
  .filter(function(index) {
    return index >= 12;
  })

  rest.hide();

  $(".show_hide").show();

  $('.show_hide').click(function() {
    rest.toggle(function() {
      //$("#plus").text("+");
    },
    function() {
      //$("#plus").text("-");
    });
  });

});
