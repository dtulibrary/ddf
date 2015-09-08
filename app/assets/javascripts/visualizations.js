$.ajax({
   type: "GET",
   contentType: "application/json; charset=utf-8",
   url: 'pages/data',
   dataType: 'json',
   success: function (data) {
     draw(data);
   },
   error: function (result) {
     error();
   }
});

function draw(data) {
  var color = d3.scale.category20b();
  var width = 420,
  barHeight = 20;

  var x = d3.scale.linear()
    .range([0, width])
    .domain([0, d3.max(data)]);

  var chart = d3.select("#graph")
    .attr("width", width)
    .attr("height", barHeight * data.length);

  var bar = chart.selectAll("g")
    .data(data)
    .enter().append("g")
    .attr("transform", function (d, i) {
      return "translate(0," + i * barHeight + ")";
  });

  bar.append("rect")
    .attr("width", x)
    .attr("height", barHeight - 1)
    .style("fill", function (d) {
      return color(d)
 })

  bar.append("text")
    .attr("x", function (d) {
      return x(d) - 10;
  })
    .attr("y", barHeight / 2)
    .attr("dy", ".35em")
    .style("fill", "white")
    .text(function (d) {
      return d;
  });
}

function error() {
  console.log("error")
}

// http://localhost:3000/en/catalog.json?utf8=%E2%9C%93&locale=en&q=*:*

// /catalog.json?utf8=%E2%9C%93&locale=en&q=*:*&rows=1

// "facets":[ -> the parent
// response.facets ->
// [].each.find_name==format_orig_s ->
// {}.get_all_items ->
//  [].each.exract_key_value_pairs

// {
//   "items":
//     [
//       {"value":"dja","hits":367796,"label":"dja"},
//       {"value":"dba","hits":88849,"label":"dba"},
//       {"value":"dcp","hits":85135,"label":"dcp"},
//       {"value":"dca","hits":49126,"label":"dca"},
//       {"value":"db","hits":37094,"label":"db"},
//       {"value":"dr","hits":33567,"label":"dr"},
//       {"value":"dna","hits":20720,"label":"dna"},
//       {"value":"dco","hits":20005,"label":"dco"},
//       {"value":"do","hits":17755,"label":"do"},
//       {"value":"dtp","hits":16809,"label":"dtp"},
//       {"value":"dw","hits":12919,"label":"dw"},
//       {"value":"djb","hits":10198,"label":"djb"},
//       {"value":"dra","hits":9340,"label":"dra"},
//       {"value":"dbp","hits":8311,"label":"dbp"},
//       {"value":"djr","hits":5978,"label":"djr"},
//       {"value":"dln","hits":2586,"label":"dln"},
//       {"value":"djc","hits":2462,"label":"djc"},
//       {"value":"dp","hits":1487,"label":"dp"},
//       {"value":"dtd","hits":748,"label":"dtd"},
//       {"value":"dd","hits":719,"label":"dd"},
//       {"value":"dso","hits":173,"label":"dso"}
//     ],
//   "name": "format_orig_s",
//   "label": "translation missing: en.blacklight.search.fields.facet.format_orig_s"
// }
