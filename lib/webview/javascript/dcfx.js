(function(window){
  
  //I recommend this
  'use strict';

  /*-------------------------------------------------------------------------------------
   *
   *-----------------------------------------------------------------------------------*/
  
  function define_dcfx(){

    var dcfx = {};
    var jarray = [];
    var ndx;
    var xDim;
    var y;
    
    /*---------------------------------------------------------------------------------
     *
     *-------------------------------------------------------------------------------*/

    dcfx.x_data = function(x_data) {

      var xDim = ndx.dimension(function(d) {return d[x_data];});
      var y = xDim.group.reduceSum(function(d) {return d["V1"];});
      
    }
    
    /*---------------------------------------------------------------------------------
     * Converts an MDArray into a javascript array appropriate for adding to
     * crossfilter.  Ideally, this step should be removed and the MDArray added
     * directly into crossfilter.
     *-------------------------------------------------------------------------------*/
    
    dcfx.convert = function() {

      // var str = window.native_array.toString();
      // $('#help').append(str);
      
      var array = window.native_array;
      var shape = array.getShape();
      var rows = shape[0];
      var columns = shape[1];
      // var index = array.getIndex();

      for (var i = 0; i < rows; i++) {
        var obj = {};
        for (var j = 0; j < columns; j++) {
          // setting the index is not working... needed for larger dimensions,
          // but for now 2 dimensions are enough
          // index.set(i, j);
          var val = array.get(i, j);
          obj["V"+j] = val;
        }
        jarray[i] = obj;
      }

      //$('#help').append(JSON.stringify(jarray));
      //$('#help').html(array.toString());

      ndx = crossfilter(jarray);
      xDim = ndx.dimension(function(d) {return d["V0"];});
      y = xDim.group().reduceSum(function(d) {return d["V1"];});

    };

    /*---------------------------------------------------------------------------------
     *
     *-------------------------------------------------------------------------------*/

    dcfx.line_chart = function(reg, w, h, dim, grp, x_min, x_max) {

      var hitslineChart  = dc.lineChart(reg); 
      
      hitslineChart
	      .width(w).height(h)
	      .dimension(dim)
	      .group(grp)
	      .x(d3.time.scale().domain([x_min,x_max])); 
      
    };
    
    /*---------------------------------------------------------------------------------
     *
     *-------------------------------------------------------------------------------*/

    dcfx.line_chart2 = function(reg, w, h) {

      var hitslineChart  = dc.lineChart(reg); 
      var min_x = xDim.bottom(1)[0]["V0"];
      var max_x = xDim.top(1)[0]["V0"];
      
      hitslineChart
	      .width(w).height(h)
	      .dimension(xDim)
        .xAxisLabel(window.columns.get(0))
        .yAxisLabel(window.columns.get(1))
	      .group(y)
	      .x(d3.time.scale().domain([min_x, max_x])); 
      
    };
    
    return dcfx;

  };


  /*-------------------------------------------------------------------------------------
   *
   *-----------------------------------------------------------------------------------*/

  //define globally if it doesn't already exist
  if(typeof(dcfx) === 'undefined'){
    window.dcfx = define_dcfx();
  }
  else{
    console.log("dcfx already defined.");
  }

})(window);

