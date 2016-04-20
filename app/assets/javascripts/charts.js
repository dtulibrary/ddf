Chart.defaults.global.responsive = true;

drawSegments = function(container) {
  ctx = document.getElementById(container).getContext("2d");
  data = document.getElementById(container).innerHTML;
  json = JSON.parse(data);
  return new Chart(ctx).Doughnut(json);
}

// makeSegmentsClickable = function(chart, container) {
//   var DOMElement = "#"+container;
//   $("DOMElement").click(
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
// REVIEW TYPE
translations['Peer Review']  = 'peer_review';
translations['Undetermined'] = 'undetermined';
translations['Ubestemt']     = 'undetermined';

// SCIENTIFIC LEVEL
translations['Scientific']  = 'scientific';
translations['Popular']     = 'popular';
translations['Educational'] = 'educational';

translations['Videnskabelig']        = 'scientific';
translations['Populærvidenskabelig'] = 'popular';
translations['Undervisningsrettet']  = 'educational';

// RESEARCH AREA
translations['Humanities']         = 'Humanities';
translations['Science/technology'] = 'Science/technology';
translations['Medical science']    = 'Medical+science';
translations['Social science']     = 'Social+science';

translations['Humaniora']             = 'Humanities';
translations['Teknik/naturvidenskab'] = 'Science/technology';
translations['Sundhedsvidenskab']     = 'Medical+science';
translations['Samfundsvidenskab']     = 'Social+science';

// PUBLICATION STATUS
translations['Published']   = 'published'
translations['Unknown']     = 'unknown'
translations['Submitted']   = 'submitted'
translations['Accepted']    = 'accepted'
translations['In Press']    = 'in_press'
translations['Unpublished'] = 'unpublished'

translations['Publiceret']  = 'published'
translations['Ukendt']      = 'unknown'
translations['Indsendt']    = 'submitted'
translations['Accepteret']  = 'accepted'
translations['I trykken']   = 'in_press'
translations['Upubliceret'] = 'unpublished'


$(document).ready(function() {
  var reviewChart = drawSegments("review-type");
  var sciLevelChart = drawSegments("scientific-level");
  var resAreaChart = drawSegments("research-area");
  var pubStatusChart = drawSegments("publication-status");
  var publicationTimelineChart = drawPlot("publication-timeline");

  var charts = {}
  charts["review_status_s"]    = reviewChart;
  charts["scientific_level_s"] = sciLevelChart;
  charts["research_area_ss"]   = resAreaChart;
  charts["access_condition_s"] = pubStatusChart;

  // Make pie / dougnut charts behave like facets when clicked
  $("canvas.segments").click(function(evt) {
    // console.log(this);
    var locale = window.location.pathname.split('/')[1];
    var facet_frag = this.dataset.facet;
    var chart = charts[facet_frag];
    var activePoints = chart.getSegmentsAtEvent(evt);
    var segment = translations[activePoints[0].label];

    var url = "/" +locale+ "/catalog?f[" +facet_frag+ "][]=" +segment+ "&q=*:*";
    window.location = url;
  });

  // Make bar charts behave like facets when clicked
  $("canvas.plot").click(function(evt) {
    var locale = window.location.pathname.split('/')[1];
    var activePoints = publicationTimelineChart.getBarsAtEvent(evt);
    var label = activePoints[0].label;
    years = label.split("-");
    if (years.length == 1) {
      var startYear = label;
      var endYear   = label;
    } else {
      var startYear = years[0];
      var endYear   = years[1];
    }
    // We create an URL containing both datasets, not the clicked one
    var pubYearParams = "range[pub_date_tsort][begin]=" +startYear+ "&range[pub_date_tsort][end]=" +endYear
    var subYearParams = "range[submission_year_tis][begin]=" +startYear+ "&range[submission_year_tis][end]=" +endYear
    var url = "/" +locale+ "/catalog?" +pubYearParams+ "&" +subYearParams+ "&q=*:*";
    window.location = url;
  });

});

//
// HOW TO ADD CLICK EVENTS:
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
//
// OLD, HARD-CODED PER-CHART CLICK HANDLER:
// $("#review-type").click(
//   function(evt) {

//     var locale = window.location.pathname.split('/')[1];
//     var canvas = document.getElementById("review-type");
//     var facet_frag = canvas.dataset.facet;
//     var activePoints = reviewChart.getSegmentsAtEvent(evt);
//     var segment = translations[activePoints[0].label];

//     var url = "/" +locale+ "/catalog?f[" +facet_frag+ "][]=" +segment+ "&q=*:*";
//     window.location = url;
//   }
// );
//

// Target URL structure for the Plot chart:
// http://localhost:3000/en/catalog?range[pub_date_tsort][begin]=1960&range[pub_date_tsort][end]=1964&q=*%3A*
// For both datasets at once:
// http://localhost:3000/en/catalog?range[pub_date_tsort][begin]=1960&range[pub_date_tsort][end]=1964&range[submission_year_tis][begin]=1960&range[submission_year_tis][end]=1964&q=*%3A*

