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

/*
1) Override default behavior on clicked link
2) Animate the clicked logo
3) Show corresponding card
*/
$(document).ready(function() {
  $("ul.data-provider-logos-list li a").click(function(event) {
    event.preventDefault();

    previousLogo = $("ul.data-provider-logos-list li.logo-clicked")
    // console.log(previousLogo);
    if (!previousLogo.is($(this).parent())) { previousLogo.toggleClass("logo-clicked"); }
    $(this).parent().toggleClass("logo-clicked");

    previousCard = $("ul.data-provider-cards-list li[style^='display: list-item']")
    klazz = $(this).parent().attr("class").split(" ")[0]; // we only need the first class
    clickedCard = $("ul.data-provider-cards-list li[id^=" +klazz+ "]")

    if (!previousCard.is(clickedCard)) { previousCard.slideToggle("fast"); }
    clickedCard.slideToggle("slow");
  });

});
