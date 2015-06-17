require_relative '../../config'
require 'mdarray'

morley = MDArray.double("morley.csv", true)
dimensions_labels = MDArray.string([3], ["Expt", "Run", "Speed"])
# Create a new dashboard
db = MDArray.dashboard(1300, 600)
db.add_data(morley, dimensions_labels, [])

chart = db.chart(:line_chart, "Run", "Speed", "RunSpeed")
  .width(768)
  .height(480)
  .x(:linear, [1, 20])
  .margins("{left: 50, top: 10, right: 10, bottom: 20}")
  .y_axis_label("This is the Y Axis!")
  .group("Run", :reduce_sum);

db.plot


