// Make responsive:
// http://www.chartjs.org/docs/#polar-area-chart-introduction
Chart.defaults.global.responsive = true;

$(document).ready(function() {
  var reviewContainer = document.getElementById("review-type").getContext("2d");
  var reviewStr = document.getElementById("review-type").innerHTML;
  var reviewData = JSON.parse(reviewStr);
  var reviewChart = new Chart(reviewContainer).Pie(reviewData);

  var sciLevelContainer = document.getElementById("scientific-level").getContext("2d");
  var sciLevelStr = document.getElementById("scientific-level").innerHTML;
  var sciLevelData = JSON.parse(sciLevelStr);
  var sciLevelChart = new Chart(sciLevelContainer).Pie(sciLevelData);

  var resAreaContainer = document.getElementById("research-area").getContext("2d");
  var resAreaStr = document.getElementById("research-area").innerHTML;
  var resAreaData = JSON.parse(resAreaStr);
  var resAreaChart = new Chart(resAreaContainer).Pie(resAreaData);
});
