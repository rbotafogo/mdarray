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

class MDArray

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def stdev
    return Math.sqrt(variance)
  end

  alias standard_deviation :stdev

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def error_estimate
    Math.sqrt(variance/size)
  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def skewness

    n = size

    if (n <= 2)
      raise "Cannot calculate skewness on array with less than 3 elements"
    end

    x = expectation_value(MDArray.method(:cube).to_proc * 
                          MDArray.method(:sub).to_proc.bind2nd(mean),
                          Proc.everywhere)[0]
    sigma = stdev

    return (x/(sigma*sigma*sigma)) * (n/(n-1)) * (n/(n-2))

  end

  #---------------------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------------------

  def kurtosis

    n = size

    if (n <= 3)
      raise "Cannot calculate kurtosis on array with less than 4 elements"
    end

    x = expectation_value(MDArray.method(:fourth).to_proc * 
                          MDArray.method(:sub).to_proc.bind2nd(mean),
                          Proc.everywhere)[0]

    sigma2 = variance
    c1 = (n/(n-1)) * (n/(n-2)) * ((n+1)/(n-3))
    c2 = 3 * ((n-1)/(n-2)) * ((n-1)/(n-3))
    return c1 * (x/(sigma2*sigma2)) - c2

  end
        
end
