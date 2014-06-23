# -*- coding: utf-8 -*-

##########################################################################################
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

##########################################################################################
#
##########################################################################################

class FunctionMap

  attr_reader :short_name      # short name of the function
  attr_reader :long_name       # long name of the function
  attr_reader :package         # package where the function was implemented
  attr_reader :function        # function to be applied to elmts
  attr_reader :return_type
  attr_reader :input1_type
  attr_reader :input2_type
  attr_reader :arity            # arity of the function: 1 or 2
  attr_reader :helper           # Helper method to perform the function
  attr_reader :is_global        # set to true if function applies to all elmts of the
                                # array.  By default set to false
  attr_reader :elmtwise         # works elementwise
  attr_accessor :description

  #------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------

  def initialize(short_name, long_name, package, function, return_type, input1_type,
                 input2_type, arity, helper, elmtwise = true, is_global = false)

    @short_name = short_name
    @long_name = long_name
    @package = package
    @function = function
    @return_type = return_type
    @input1_type = input1_type
    @input2_type = input2_type
    @arity = arity
    @helper = helper
    @elmtwise = elmtwise
    @is_global = is_global

  end # initialize

end # FunctionMap

