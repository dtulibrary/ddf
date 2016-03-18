// Make responsive:
// http://www.chartjs.org/docs/#polar-area-chart-introduction
Chart.defaults.global.responsive = true;

var data = [
  {
    value: 300,
    color:"#F7464A",
    highlight: "#FF5A5E",
    label: "Red"
  },
  {
    value: 50,
    color: "#46BFBD",
    highlight: "#5AD3D1",
    label: "Green"
  },
  {
    value: 100,
    color: "#FDB45C",
    highlight: "#FFC870",
    label: "Yellow"
  },
  {
    value: 40,
    color: "#949FB1",
    highlight: "#A8B3C5",
    label: "Grey"
  },
  {
    value: 120,
    color: "#4D5360",
    highlight: "#616774",
    label: "Dark Grey"
  }
];

// http://stackoverflow.com/questions/18831426/rails-charts-js-how-to-fill-out-the-javascript-array-with-value-from-database
// https://www.quora.com/How-do-I-pass-a-Ruby-variable-to-JavaScript

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Basic_usage
$(document).ready(function() {
 var ctx = document.getElementById("chartjs-test").getContext("2d");
 var testChart = new Chart(ctx).PolarArea(data);
  // console.log(ctx);
 var liveChart = new Chart(ctx).PolarArea(data);
});


$(document).ready(function() {
  var con = document.getElementById("live-test").getContext("2d");
  var str = document.getElementById("live-test").innerHTML;
  var live = JSON.parse(str);
  // console.log(live);
  var liveChart = new Chart(con).Pie(live);
});
