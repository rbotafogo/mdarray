# -*- coding: utf-8 -*-

##########################################################################################
# @author Rodrigo Botafogo
#
# Copyright © 2013 Rodrigo Botafogo. All Rights Reserved. Permission to use, copy, modify, 
# and distribute this software and its documentation, without fee and without a signed 
# licensing agreement, is hereby granted, provided that the above copyright notice, this 
# paragraph and the following two paragraphs appear in all copies, modifications, and 
# distributions.
#
# IN NO EVENT SHALL RODRIGO BOTAFOGO BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, 
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF 
# THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF RODRIGO BOTAFOGO HAS BEEN ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
#
# RODRIGO BOTAFOGO SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
# SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED "AS IS". 
# RODRIGO BOTAFOGO HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, 
# OR MODIFICATIONS.
##########################################################################################

if !(defined? $ENVIR)
  $ENVIR = true
  require_relative '../env.rb'
end

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'nashorn'

class NashornTest < Test::Unit::TestCase

  context "Engine test" do

    setup do

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "access nashorn engine" do

      p J.eval("2")
      p J.eval("3.545")
      p J.eval("print('Hello world');")

      J.eval <<EOF
var fun1 = function(name) {
    print('Hi there from Javascript, ' + name);
    return "greetings from javascript";
};

var fun2 = function (object) {
    print("JS Class Definition: " + Object.prototype.toString.call(object));
};

var fun3 = function() {
    print("Function without arguments");
};

var stringFun = function() {
    return("this is a string");
};

var booleanFun = function() {
    return(true);
};

var numberFun1 = function() {
    return 42;
};

var numberFun2 = function() {
    return 3.876
};

var numberFun3 = function() {
    return 42/0;
};

var numberFun4 = function() {
    return 42/-0;
};

var objectFun = function() {
     var car = {
         type:"Fiat", 
         model:500, 
         color:"white",
         func: function() {return 10;}};

     return car;

};

car = objectFun();
print(car);

EOF

      p J.fun1("Rodrigo")
      J.fun2("2")
      J.fun3
      # J.fun4
      p J.stringFun
      p J.booleanFun
      p J.numberFun1
      p J.numberFun2
      p J.numberFun3
      p J.numberFun4
      object = J.objectFun
      p object
      p object['type']
      p object.func

    end

  end

end
