(function ($) {
  // Attach Mendeley functionality to "Save to Mendeley" buttons
  $(function () {
    $('body').on('click', '.save-to-mendeley', function () {
      var script = document.createElement('script');
      var closestDoc = $(this).closest('.document');

      // Reset any hidden COInS elements
      $('.Z3988-hidden').removeClass('Z3988-hidden').addClass('Z3988');

      if (closestDoc.length > 0) {
        /* Clicked from inside a document which means this is a single document action.
         * XXX: Hide all but this document's COInS element from Mendeley to enable saving
         *      of single document on index and show pages.
         */
        $('.Z3988').addClass('Z3988-hidden').removeClass('Z3988');
        closestDoc.addClass('Z3988').removeClass('Z3988-hidden');
      }

      // Append Mendeley script which triggers the web importer to open
      script.setAttribute('src','https://www.mendeley.com/minified/bookmarklet.js');
      $('body').append(script);

      // Abort link action
      return false;
    });
  });
})(jQuery);
