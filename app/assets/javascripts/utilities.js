// CHARTS on /index
$(document).ready(function() {
  rest = $(".chartlist.types li")
  .filter(function(index) {
    return index >= 13;
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

// responsive subnavs
$(function() {
  // alert("Shout on DOM ready from mobile submenu!");
  // Create the dropdown base
  // $("<select />").appendTo("nav");

  // // Create default option "Go to..."
  // $("<option />", {
  //  "selected": "selected",
  //  "value"   : "",
  //  "text"    : "Go to..."
  // }).appendTo("nav select");

  // // Populate dropdown with menu items
  // $("nav a").each(function() {
  // var el = $(this);
  // $("<option />", {
  //    "value"   : el.attr("href"),
  //    "text"    : el.text()
  // }).appendTo("nav select");
  // });

  // To make dropdown actually work
  // To make more unobtrusive: http://css-tricks.com/4064-unobtrusive-page-changer/
  $("nav.mobile select").change(function() {
    window.location = $(this).find("option:selected").val();
  });
});

// $(document).ready(function() { alert("Shout on DOM ready!"); });
// $(function() { alert("Shout on DOM ready from alias!"); });

