// CHARTS on /index
$(document).ready(function() {
  rest = $(".chartlist.types li")
  .filter(function(index) {
    return index >= 12;
  })

  rest.hide();

  $("button.list-toggle").click(function() {
    $(this).toggleClass("show");
    rest.slideToggle("medium");
  });
});

// CARDS ON about/data/providers
$(document).ready(function() {
  $("button.card-toggle").click(function() {
    $(this).parent().parent().next().slideToggle("medium");
  });
});


// CARDS ON SERP PAGE
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
    klass = $(this).parent().attr("class").split(" ")[0]; // we only need the first class
    clickedCard = $("ul.data-provider-cards-list li[id^=" +klass+ "]")

    if (!previousCard.is(clickedCard)) { previousCard.slideToggle("fast"); }
    clickedCard.slideToggle("slow");
  });

});

$(document).ready(function() {
  $('#print-selected').click(function()
  {
    window.print();
  });
});
