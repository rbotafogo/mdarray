require_relative '../../config'
require 'mdarray'

morley = MDArray.double("morley.csv", true)
dimensions_labels = MDArray.string([3], ["Expt", "Run", "Speed"])
db = MDArray::Dashboard.new(1300, 600)
db.add_data(morley, dimensions_labels)
grid = db.new_grid([1])
grid[1] = "RunSpeed"
db.add_grid(grid)

chart = db.chart(:line_chart, "Run", "Speed", "RunSpeed").width(768)
.height(480)
.x(:linear, [1, 20])
.margins({left: 50, top: 10, right: 10, bottom: 20})
.y_axis_label("This is the Y Axis!")
.group("Speed", :reduce_sum);

db.plot


