if !(defined? $ENVIR)
  $ENVIR = true
  require_relative '../env.rb'
end

require 'mdarray'

scrpt = <<EOS

var timeFormat = d3.time.format("%d/%m/%Y");

// Add bootstrap containers
container = d3.select("body")
  .append("div").attr("class", "container")
  .attr("style", "font: 12px sans-serif;");

row0 = container.append("div").attr("class", "row");
row0.append("div").attr("class", "col-sm-6").attr("id", "blank");
row0.append("div").attr("class", "col-sm-6").attr("id", "DateOpenChart");

row1 = container.append("div").attr("class", "row");
row1.append("div").attr("class", "col-sm-6").attr("id", "DateHighChart");
row1.append("div").attr("class", "col-sm-6").attr("id", "DateVolumeChart");

var dateDimension = facts.dimension(function(d) {return d["Date"];});
var timeDimension = facts.dimension(function(d) {return d["Date"];});

var dateopen = dc.lineChart("#DateOpenChart"); 
var datevolume = dc.lineChart("#DateVolumeChart");
var datehigh = dc.lineChart("#DateHighChart");

var dateopenGroup = dateDimension.group().reduceSum(function(d) {return d["Open"];});
var datevolumeGroup = timeDimension.group().reduceSum(function(d) {return d["Volume"];});
var datehighGroup = timeDimension.group().reduceSum(function(d) {return d["High"];});

// find data range
var xMin = d3.min(data, function(d){ return Math.min(d["Date"]); });
var xMax = d3.max(data, function(d){ return Math.max(d["Date"]); });

// DateOpenChart
dateopen
  .width(400).height(200)
  .dimension(dateDimension)
  .group(dateopenGroup)
  .elasticY(true)
  .elasticX(true)
  .x(d3.time.scale().domain([xMin, xMax]));

// DateVolumeChart
datevolume
  .width(400).height(200)
  .dimension(dateDimension)
  .group(datevolumeGroup)
  .elasticY(true)
  .elasticX(true)
  .x(d3.time.scale().domain([xMin, xMax]));

// DateHighChart
datehigh
  .width(400).height(200)
  .dimension(dateDimension)
  .group(datehighGroup)
  .elasticY(true)
  .elasticX(true)
  .x(d3.time.scale().domain([xMin, xMax]));

dc.renderAll();

EOS

# Read the data
ndx = MDArray.double("short.csv", true)

# Assign heading to the columns.  We cannot read the header from the file as 
# we are storing in an MDArray double.  Could maybe add headers to MDArrays, but
# it might be better to let Datasets be done in SciCom only.
dimensions_labels = 
  MDArray.string([7], ["Date", "Open", "High", "Low", "Close", "Volume", 
                       "Adj Close"])

db = MDArray::Dashboard.new(1300, 600)
db.add_data(ndx, dimensions_labels, ["Date"])
db.set_demo_script(scrpt)
db.plot
