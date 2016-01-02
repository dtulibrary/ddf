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

// Prevent default
// (Maybe change visual state of this button)
// Get the source list item's class
// Fetch the target list item with that class
// slideToggle that item
$(document).ready(function() {
  $("ul.data-provider-logos-list li a").click(function(event) {
    event.preventDefault();

    // $(this).parent().toggleClass("logo-clicked"); // not working very well
    console.log( $(this).parent() );

    // remove visibility from previously chosen item (for when list.length > 1)
    previous = $("ul.data-provider-cards-list li[style^='display: list-item']")
    // klass = $("ul.data-provider-logos-list li").attr("class")
    klass = $(this).parent().attr("class") // alternative to above
    item = $("ul.data-provider-cards-list li[class^=" +klass+ "]")

    if (!previous.is(item)) { previous.slideToggle("fast"); }
    item.slideToggle("slow");
    //console.log(item);
  });

});
