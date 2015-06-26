var DCDashboard = (function(){
  
  'use strict';
  // here just as example of static private var
  var static_var; //static private var
  
  var DCDashboard = function () {
    
    /*----------------------------------------------------------------------------------
     * Private variables and methods
     *--------------------------------------------------------------------------------*/

    var privateVar; //private
    var _jsdata = []

    var convert = function(dates){
      // var str = window.native_array.toString();
      // $('#help').append(str);

      // window.native_array and window.labels are set as global variables.
      // Should be improved!
      var array = window.native_array;
      var labels = window.labels;
      //$('#help').append(labels.toString());

      var shape = array.getShape();
      var rows = shape[0];
      var columns = shape[1];

      for (var i = 0; i < rows; i++) {
        var obj = {};
        for (var j = 0; j < columns; j++) {
          // setting the index is not working... needed for larger dimensions,
          // but for now 2 dimensions are enough
          // index.set(i, j);
          var val = array.get(i, j);
          if (dates.indexOf(labels.get(j)) > -1) {
            obj[labels.get(j)] = new Date(val * 1000);
          }
          else {
            obj[labels.get(j)] = val;
          }
        }
        _jsdata[i] = obj;
      }

    }; //private 
    
  /*-------------------------------------------------------------------------------------
   * Public variables and methods
   *-----------------------------------------------------------------------------------*/

    this.someProperty = 5;  //public
    this.anotherProperty = false;  //public
    
    // dates, when set, are dimensions that cotain a date field.
    this.convert = function(dates) {
      convert(dates);
    };
    
    this.getData = function () {  //public
      return _jsdata;
    };
    
  };
  
  return DCDashboard;
  
})();

