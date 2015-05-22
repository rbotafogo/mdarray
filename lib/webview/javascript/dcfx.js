(function(window){
  
  //I recommend this
  'use strict';
  
  /*-------------------------------------------------------------------------------------
   *
   *-----------------------------------------------------------------------------------*/
  
  function define_dcfx(){
    var dcfx = {};
    
    /*---------------------------------------------------------------------------------
     *
     *-------------------------------------------------------------------------------*/

    dcfx.line_chart = function(reg, w, h, dim, grp, x_min, x_max){
      var hitslineChart  = dc.lineChart(reg); 
      
      hitslineChart
	      .width(w).height(h)
	      .dimension(dim)
	      .group(grp)
	      .x(d3.time.scale().domain([x_min,x_max])); 
      
    }
    
    /*---------------------------------------------------------------------------------
     *
     *-------------------------------------------------------------------------------*/
    
    dcfx.convert = function() {
      var str = window.nc_array.toString();
      //$('#help').append(str);

      var array = window.nc_array;
      var shape = array.getShape();
      var rows = shape[0];
      var columns = shape[1];
      var index = array.getIndex();
      var jarray = [];

      //$('#help').append(rows);
      //$('#help').append(columns);
      
      for (var i = 0; i < rows; i++) {
        var obj = {};
        for (var j = 0; j < columns; j++) {
          index.set(i, j);
          var val = array.getDouble(index);
          //$('#help').append(val);
          obj["V"+j] = val;
        }
        jarray[i] = obj;
      }

      $('#help').append(JSON.stringify(jarray));
      //$('#help').html(array.toString());

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

