$(function(){

  // Add the toggle link to the html after the third li element and hide
  // subsequent lis. Use the link to toggle their display thereafter.
  $('dd.affiliations').each(function(){
    var $container = $(this);
    var $moreLink = $('[data-link-for="#' + this.id +'"]');
    $container.find('li:nth-child(1n+3)').toggle();
    $moreLink.insertAfter('dd#' + this.id +  ' li:nth-child(3)').show();
    $moreLink.children('a').click(function(){
      // Hide or show depending on current status
      $container.find('li:nth-child(1n+3)').fadeToggle();
      // swap texts around
      var currentText = $(this).text();
      var clickText = $(this).data('clickText');
      $(this).text(clickText);
      $(this).data('clickText', currentText);
      return false; // don't go anywhere with the link
    })

  });
})
