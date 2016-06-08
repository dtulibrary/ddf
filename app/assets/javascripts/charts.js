Chart.defaults.global.responsive = true;

drawSegments = function(container) {
  if (document.getElementById(container)) {
    var ctx = document.getElementById(container).getContext("2d");
    var data = document.getElementById(container).innerHTML;
    var json = JSON.parse(data);
    return new Chart(ctx).Doughnut(json);
  }
}

/*
  A function to manually format numbers in JS, as in:
  https://github.com/chartjs/Chart.js/issues/68#issuecomment-20918194
*/
function thousandSeparator(input) {
  var number = input.split('.');
  num = number[0];
  num = num.split("").reverse().join("");
  var numpoint = '';
  for (var i = 0; i < num.length; i++) {
    numpoint += num.substr(i,1);
    if (((i+1)%3 == 0) && i != num.length-1) {
      numpoint += ',';
    }
  }
  num = numpoint.split("").reverse().join("");
  if (number[1] != undefined) {
    num = num+'.'+number[1];
  }
  return num;
}

var plotOptions = { scaleLabel : "<%= thousandSeparator(value) %>" };

// Uses tooltips to show Y-values on bars
drawPlot = function(container) {
  if (document.getElementById(container)) {
    var ctx = document.getElementById(container).getContext("2d");
    var data = document.getElementById(container).innerHTML;
    var json = JSON.parse(data);
    return new Chart(ctx).Bar(json, plotOptions);
  }
}

/*
  Displays Y-values above bars, instead of inside tooltips.
  This variation allows to format the Y-values with decimal points, as in:
  http://stackoverflow.com/questions/35366513/adding-decimal-points-to-data-values-chartjs
*/
drawPlotWithValues = function(container) {
  if (document.getElementById(container)) {

    var ctx = document.getElementById(container).getContext("2d");
    var data = document.getElementById(container).innerHTML;
    var json = JSON.parse(data);

    var plot = new Chart(ctx).Bar(json, {
      scaleLabel : "<%= thousandSeparator(value) %>",
      showTooltips: false,
      onAnimationComplete: function () {

        var ctx = this.chart.ctx;
        ctx.font = this.scale.font;
        ctx.fillStyle = this.scale.textColor
        ctx.textAlign = "center";
        ctx.textBaseline = "bottom";

        this.datasets.forEach(function (dataset) {
          dataset.bars.forEach(function (bar) {
            bar.value = numberWithCommas(bar.value);
            ctx.fillText(bar.value, bar.x, bar.y - 5);
          });
        })
      }
    });
    return plot;
  }
}

var numberWithCommas = function(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
};

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
translations['In press']    = 'in_press'
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
  var publicationYearChart = drawPlot("publication-year");
  var submissionYearChart = drawPlot("submission-year");
  // var publicationYearChart = drawPlotWithValues("publication-year");
  // var submissionYearChart = drawPlotWithValues("submission-year");

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
  $.each([publicationYearChart, submissionYearChart], function() {
    if (typeof this.chart != "undefined") {
      var chart = this;
      var canvas = this.chart.canvas;
      var facet_frag = canvas.dataset.facet;

      $(canvas).click(function(evt) {
        var locale = window.location.pathname.split('/')[1];
        var activePoints = chart.getBarsAtEvent(evt);
        var label = activePoints[0].label;
        years = label.split("-");
        if (years.length == 1) {
          var startYear = label;
          var endYear   = label;
        } else {
          var startYear = years[0];
          var endYear   = years[1];
        }
        // Create an URL from all the fragments
        var queryParams = "range[" +facet_frag+ "][begin]=" +startYear+ "&range[" +facet_frag+ "][end]=" +endYear
        var url = "/" +locale+ "/catalog?" +queryParams+ "&q=*:*";
        window.location = url;
      });
    }
  });

// doc ready end
});
