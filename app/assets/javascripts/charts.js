Chart.defaults.global.responsive = true;

drawPie = function(container, chartType) {
  ctx = document.getElementById(container).getContext("2d");
  data = document.getElementById(container).innerHTML;
  json = JSON.parse(data);
  return new Chart(ctx).Pie(json);
}

$(document).ready(function() {
  var reviewChart = drawPie("review-type");
  var sciLevelChart = drawPie("scientific-level");
  var resAreaChart = drawPie("research-area");
  var pubStatusChart = drawPie("publication-status");
});
