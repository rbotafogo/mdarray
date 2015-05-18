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
            d3.select("body").append("p").text("New paragraph!");
            $('#demo').html(str)
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

