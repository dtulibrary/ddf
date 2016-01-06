$(document).ready(function() {
  rest = $(".chartlist.types li")
  .filter(function(index) {
    return index >= 12;
  })

  rest.hide();

  $("button.toggle-rest").click(function() {
    $(this).toggleClass("show");
    rest.slideToggle("medium");
  });
});

$(document).ready(function() {
  $('#print-selected').click(function()
  {
    window.print();
  });
});

