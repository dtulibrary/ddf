// the code here functions to display the Metrics panel if there is any content
// We keep it here because Toshokan uses several Metrics types and it is only
// relevant when we are just using one.
// See https://developer.mozilla.org/en/docs/Web/API/MutationObserver for information
// on the MutationObserver class.
$(document).ready(function(){
  // catch different implementations and no implementations
  MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
  if (!MutationObserver) return;

  // if the wrapper is not present the document does not qualify for Altmetrics
  var target = document.querySelector('.altmetric-wrapper');
  if (target == null) return;
  //construct
  var observer = new MutationObserver(function(mutations, observer) {
    // fired when a mutation occurs
    mutations.forEach(function(mutation) {
      // there are also attribute type mutations, but childList is what we need here
      if (mutation.type == 'childList'){
        $('#metrics').removeClass('hidden');
        observer.disconnect();
      }
    });
    // ...
  });

  // define what element should be observed by the observer
  // and what types of mutations trigger the callback
  observer.observe(target, {
    subtree: true,
    attributes: false,
    childList: true
    //...
  });
})
