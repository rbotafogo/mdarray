if !(defined? $ENVIR)
  $ENVIR = true
  require_relative '../../config'
end

require 'mdarray'

scrpt = <<EOS

// Add bootstrap containers
container = d3.select("body")
  .append("div").attr("class", "container")
  .attr("style", "font: 12px sans-serif;");

row0 = container.append("div").attr("class", "row");
row0.append("div").attr("class", "col-sm-12").attr("id", "test");

var chart = dc.lineChart("#test");
  
runDimension        = facts.dimension(function(d) {return +d.Run;}),
speedSumGroup       = runDimension.group().reduce(function(p, v) {
  p[v.Expt] = (p[v.Expt] || 0) + v.Speed;
  return p;
}, function(p, v) {
  p[v.Expt] = (p[v.Expt] || 0) - v.Speed;
  return p;
}, function() {
  return {};
});

function sel_stack(i) {
  return function(d) {
    return d.value[i];
  };
}

chart
  .width(768)
  .height(480)
  .x(d3.scale.linear().domain([1,20]))
  .margins({left: 50, top: 10, right: 10, bottom: 20})
  .renderArea(true)
  .brushOn(false)
  .renderDataPoints(true)
  .clipPadding(10)
  .yAxisLabel("This is the Y Axis!")
  .dimension(runDimension)
  .group(speedSumGroup, "1", sel_stack('1'));

for(var i = 2; i<6; ++i)
  chart.stack(speedSumGroup, ''+i, sel_stack(i));
chart.render();

EOS

# Read the data
ndx = MDArray.double("morley.csv", true)

# Assign heading to the columns.  We cannot read the header from the file as 
# we are storing in an MDArray double.  Could maybe add headers to MDArrays, but
# it might be better to let Datasets be done in SciCom only.
dimensions_labels = 
  MDArray.string([3], ["Expt", "Run", "Speed"])

db = MDArray.dashboard(1300, 600)
db.add_data(ndx, dimensions_labels, [])
db.set_demo_script(scrpt)
db.plot

