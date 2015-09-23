  dataset = [
  {"value":"dja","hits":367796,"label":"Journal article"},
  {"value":"dba","hits":88849,"label":"Book chapter"},
  {"value":"dcp","hits":85135,"label":"Conference paper"},
  {"value":"dca","hits":49126,"label":"Conference abstract"},
  {"value":"db","hits":37094,"label":"Book"},
  {"value":"dr","hits":33567,"label":"Report"},
  {"value":"dna","hits":20720,"label":"Newspaper article"},
  {"value":"dco","hits":20005,"label":"Conference poster"},
  {"value":"do","hits":17755,"label":"Other"},
  {"value":"dtp","hits":16809,"label":"Thesis PhD"},
  {"value":"dw","hits":12919,"label":"Working paper"},
  {"value":"djb","hits":10198,"label":"Journal book review"},
  {"value":"dra","hits":9340,"label":"Report chapter"},
  {"value":"dbp","hits":8311,"label":"Book preface"},
  {"value":"djr","hits":5978,"label":"Journal review article"},
  {"value":"dln","hits":2586,"label":"Lecture notes"},
  {"value":"djc","hits":2462,"label":"Journal comment"},
  {"value":"dp","hits":1487,"label":"Patent"},
  {"value":"dtd","hits":748,"label":"Thesis Doctoral"},
  {"value":"dd","hits":719,"label":"Data set"},
  {"value":"dso","hits":173,"label":"Software"}
  ];

  function draw(dataset) {

    var width          = 720;
    var height         = 720;
    var radius         = Math.min(width, height) / 2;
    var donutWidth     = 75;
    var legendRectSize = 18;
    var legendSpacing  = 6.5;

    var color = d3.scale.category20c();

    var svg = d3.select('#chart')
    .append('svg')
    .attr('width', width)
    .attr('height', height)
    .append('g')
    .attr('transform', 'translate(' + (width / 2) +',' + (height / 2) + ')');

    var arc = d3.svg.arc()
    .innerRadius(radius - donutWidth)
    .outerRadius(radius);

    var pie = d3.layout.pie()
    .value(function(d) { return d.hits; })
    .sort(null);

    var tooltip = d3.select('#chart')
    .append('div')
    .attr('class', 'tooltip');

    tooltip.append('div')
    .attr('class', 'label');

    tooltip.append('div')
    .attr('class', 'hits');

    tooltip.append('div')
    .attr('class', 'percent');

  // The rest of the code below is wrapped inside this callback:
  // d3.csv('weekdays.csv', function(error, dataset) {
  //   dataset.forEach(function(d) {
  //     d.count = +d.count;
  //   });
  //   HERE.
  // });

  //LOOP START
  $.each(dataset, function(row) {
    var path = svg.selectAll('path')
    .data(pie(dataset))
    .enter()
    .append('path')
    .attr('d', arc)
    .attr('fill', function(d, i) {
      return color(d.data.label);
    });

    path.on('mouseover', function(d) {
      // alert("Mouseover!!")

      var total = d3.sum(dataset.map(function(d) {
        return d.hits;
        alert(d.hits); //doesn't get triggered
      }));

      // var percent = Math.round(1000 * row.hits / total) / 10;
      var percent = Math.round(1000 * row.hits / 33) / 10; //FIXME
      tooltip.select('.label').html(row.label);
      tooltip.select('.hits').html(row.hits);
      tooltip.select('.percent').html(percent + '%');
      tooltip.style('display', 'block');



    });

    path.on('mouseout', function() {
      tooltip.style('display', 'none');
    });


    var legend = svg.selectAll('.legend')
    .data(color.domain())
    .enter()
    .append('g')
    .attr('class', 'legend')
    .attr('transform', function(d, i) {
      var height = legendRectSize + legendSpacing;
      var offset =  height * color.domain().length / 2;
      var horz = -2 * legendRectSize;
      var vert = i * height - offset;
      return 'translate(' + horz + ',' + vert + ')';
    });

    legend.append('rect')
    .attr('width', legendRectSize)
    .attr('height', legendRectSize)
    .style('fill', color)
    .style('stroke', color);

    legend.append('text')
    .attr('x', legendRectSize + legendSpacing)
    .attr('y', 15)
    .text(function(d) { return d; });
  });

  // INSIDE CALLBACK START
  // var path = svg.selectAll('path')
  // .data(pie(dataset))
  // .enter()
  // .append('path')
  // .attr('d', arc)
  // .attr('fill', function(d, i) {
  //   return color(d.data.label);
  // });

  // path.on('mouseover', function(d) {
  //   var total = d3.sum(dataset.map(function(d) {
  //     return d.hits;
  //     // alert(d.hits); doesn't get triggered
  //   }));
  //   var percent = Math.round(1000 * d.data.hits / total) / 10;
  //   tooltip.select('.label').html(d.data.label);
  //   tooltip.select('.hits').html(d.data.hits);
  //   tooltip.select('.percent').html(percent + '%');
  //   tooltip.style('display', 'block');
  // });

  // path.on('mouseout', function() {
  //   tooltip.style('display', 'none');
  // });


  // // OPTIONAL
  // // path.on('mousemove', function(d) {
  // //   tooltip.style('top', (d3.event.pageY + 10) + 'px')
  // //     .style('left', (d3.event.pageX + 10) + 'px');
  // // });


  // var legend = svg.selectAll('.legend')
  // .data(color.domain())
  // .enter()
  // .append('g')
  // .attr('class', 'legend')
  // .attr('transform', function(d, i) {
  //   var height = legendRectSize + legendSpacing;
  //   var offset =  height * color.domain().length / 2;
  //   var horz = -2 * legendRectSize;
  //   var vert = i * height - offset;
  //   return 'translate(' + horz + ',' + vert + ')';
  // });

  // legend.append('rect')
  // .attr('width', legendRectSize)
  // .attr('height', legendRectSize)
  // .style('fill', color)
  // .style('stroke', color);

  // legend.append('text')
  // .attr('x', legendRectSize + legendSpacing)
  // .attr('y', 15)
  // .text(function(d) { return d; });
  // INSIDE CALLBACK END
}

$(document).ready(function() { draw(dataset); });

