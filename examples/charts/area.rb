require_relative '../../config'
require 'mdarray'

morley = MDArray.double("morley.csv", true)
dimensions_labels = MDArray.string([3], ["Expt", "Run", "Speed"])

# Create a new dashboard
db = Sol.dashboard("Morley", morley, dimensions_labels)

chart = db.chart(:line_chart, "Run", "Speed", "RunSpeed")
  .width(768).height(480)
  .x(:linear, [1, 20])
  .margins(left: 50, top: 10, right: 10, bottom: 50)
  .y_axis_label("This is the Y Axis!")
  .render_area(true)
  .render_data_points(true)
  .clip_padding(10)
  .brush_on(false)
  .group(:reduce_sum)

# chart.stack("Run", :reduce_count)

db.plot


