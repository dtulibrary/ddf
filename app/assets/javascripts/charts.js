Chart.defaults.global.responsive = true;

drawSegments = function(container) {
  ctx = document.getElementById(container).getContext("2d");
  data = document.getElementById(container).innerHTML;
  json = JSON.parse(data);
  return new Chart(ctx).Doughnut(json);
}

// makeSegmentsClickable = function(chart, container) {
//   var DOMElement = "#"+container;
//   $("#review-type").click(
//     function(evt) {

//       var locale = window.location.pathname.split('/')[1];
//       var canvas = document.getElementById(container);
//       var facet_frag = canvas.dataset.facet;
//       var activePoints = chart.getSegmentsAtEvent(evt);
//       var segment = translations[activePoints[0].label];

//       var url = "/" +locale+ "/catalog?f[" +facet_frag+ "][]=" +segment+ "&q=*:*";
//       window.location = url;
//     }
//   );
// }

drawPlot = function(container) {
  ctx = document.getElementById(container).getContext("2d");
  data = document.getElementById(container).innerHTML;
  json = JSON.parse(data);
  return new Chart(ctx).Bar(json);
}

var translations = {}
translations['Peer Review']  = 'peer_review';
translations['Undetermined'] = 'undetermined';
translations['Ubestemt']     = 'undetermined';

translations['Scientific']  = 'scientific';
translations['Popular']     = 'popular';
translations['Educational'] = 'educational';

translations['Videnskabelig']        = 'scientific';
translations['Populærvidenskabelig'] = 'popular';
translations['Undervisningsrettet']  = 'educational';

$(document).ready(function() {
  var reviewChart = drawSegments("review-type");
  // makeSegmentsClickable(reviewChart, "review-type");

  // TODO
  $("#review-type").click(
    function(evt) {

      var locale = window.location.pathname.split('/')[1];
      var canvas = document.getElementById("review-type");
      var facet_frag = canvas.dataset.facet;
      var activePoints = reviewChart.getSegmentsAtEvent(evt);
      var segment = translations[activePoints[0].label];

      var url = "/" +locale+ "/catalog?f[" +facet_frag+ "][]=" +segment+ "&q=*:*";
      window.location = url;
    }
  );
  // TODO

  var sciLevelChart = drawSegments("scientific-level");
  // makeSegmentsClickable(sciLevelChart, "scientific-level");

    $("#scientific-level").click(
    function(evt) {

      var locale = window.location.pathname.split('/')[1];
      var canvas = document.getElementById("scientific-level");
      var facet_frag = canvas.dataset.facet;
      var activePoints = sciLevelChart.getSegmentsAtEvent(evt);
      var segment = translations[activePoints[0].label];

      var url = "/" +locale+ "/catalog?f[" +facet_frag+ "][]=" +segment+ "&q=*:*";
      window.location = url;
    }
  );


  var resAreaChart = drawSegments("research-area");
  var pubStatusChart = drawSegments("publication-status");

  var pubYearChart = drawPlot("publication-year");
});

//
// http://stackoverflow.com/questions/26257268/click-events-on-pie-charts-in-chart-js
//
// $("#myChart").click(
//     function(evt){
//         var activePoints = myNewChart.getSegmentsAtEvent(evt);
//         var url = "http://example.com/?label=" + activePoints[0].label + "&value=" + activePoints[0].value;
//         alert(url);
//     }
// );
//
