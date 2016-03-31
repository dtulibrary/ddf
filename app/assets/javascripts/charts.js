Chart.defaults.global.responsive = true;

drawSegments = function(container) {
  ctx = document.getElementById(container).getContext("2d");
  data = document.getElementById(container).innerHTML;
  json = JSON.parse(data);
  return new Chart(ctx).Doughnut(json);
}

drawPlot = function(container) {
  ctx = document.getElementById(container).getContext("2d");
  data = document.getElementById(container).innerHTML;
  json = JSON.parse(data);
  return new Chart(ctx).Bar(json);
}

$(document).ready(function() {
  var reviewChart = drawSegments("review-type");
  var sciLevelChart = drawSegments("scientific-level");
  var resAreaChart = drawSegments("research-area");
  var pubStatusChart = drawSegments("publication-status");

  var pubYearChart = drawPlot("publication-year");
});

// Vary on: 1) data range; 2) interval step, i.e. 10, 50 etc years
// var lineChartData = {
//   // hashify('pub_date_tsort').sort.map { |pair| pair.first }
//   labels: ["1800", "1948", "1949", "1950", "1951", "1952", "1953", "1954", "1955", "1956", "1957", "1958", "1959", "1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"],
//   datasets: [
//     {
//       label: "My First dataset",
//       fillColor: "rgba(220,220,220,0.2)",
//       strokeColor: "rgba(220,220,220,1)",
//       pointColor: "rgba(220,220,220,1)",
//       pointStrokeColor: "#fff",
//       pointHighlightFill: "#fff",
//       pointHighlightStroke: "rgba(220,220,220,1)",
//       // hashify('pub_date_tsort').sort.map { |pair| pair.last }
//       data: [10, 2, 6, 22, 18, 16, 16, 25, 28, 51, 52, 78, 82, 66, 81, 96, 137, 169, 217, 202, 251, 277, 300, 315, 407, 433, 538, 563, 597, 664, 775, 882, 1014, 1137, 1235, 1402, 1556, 1673, 1847, 2067, 2399, 2791, 3364, 4440, 7223, 8974, 9546, 12126, 12546, 14905, 18612, 19742, 25121, 25283, 29132, 31292, 32332, 34212, 35952, 39162, 40317, 45122, 46391, 47744, 49792, 50317, 50363, 51349, 50738, 10719, 80, 15, 1]
//     }
//   ]
// };
