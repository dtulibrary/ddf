function plotOAI(resp, targetDivId) {
    var data = resp.oa_indicator;
    var chartData = [];
    var title = data.request.command;
    var body = data.response.body;

    var colors = {
        realized: 'green',
        unclear: 'red',
        unused: 'orange'
    };

    for (var key in body) {
        if (!body.hasOwnProperty(key)) continue;
        var value_obj = data.response.body[key];
        var x_vals = [], y_vals = [];
        if (typeof value_obj == 'object') {
            for (var k in value_obj) {
                if (!value_obj.hasOwnProperty(k)) continue;
                x_vals.push(k);
                y_vals.push(value_obj[k])
            }
        } else if (typeof value_obj == 'number') {
            x_vals.push(title);
            y_vals.push(key);
        }
        chartData.push({
            x: x_vals, // e.g. hum, soc, sci, med
            y: y_vals, // e.g. 12, 35, 11
            name: key, //e.g. realised, unused
            type: 'bar'
            , marker: { color: colors[key] }
        });
    }

    var layout = { barmode: 'stack', title: title };
    Plotly.newPlot(targetDivId, chartData, layout);
}

$(document).ready(function(){
    $('[data-function="oai-chart"]').each(function(x){
        var link = $(this).data('link');
        var target = this.id;
        Plotly.d3.json(link, function(error, resp){
            if (error) return console.warn(error);
            plotOAI(resp, target);
        });
    });
});
