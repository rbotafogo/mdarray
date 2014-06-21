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

require 'rubygems'
require "test/unit"
require 'shoulda'

require 'mdarray'


class MDArrayTest < Test::Unit::TestCase

  context "Lazy operations" do

    setup do

      @a = MDArray.int([2, 3], [1, 2, 3, 4, 5, 6])
      @b = MDArray.int([2, 3], [10, 20, 30, 40, 50, 60])
      @c = MDArray.double([2, 3], [100, 200, 300, 400, 500, 600])
      @d = MDArray.init_with("int", [2, 3], 4)
      @e = MDArray.init_with("int", [2, 3], 5)
      @f = MDArray.init_with("int", [2, 3], 6)
      @g = MDArray.init_with("int", [2, 3], 7)

      @h = MDArray.init_with("int", [3, 3], 7)
      @i = MDArray.init_with("int", [3, 3], 7)

      @float = MDArray.init_with("float", [2, 3], 10.5)
      @long = MDArray.init_with("long", [2, 3], 10)
      @byte = MDArray.init_with("byte", [2, 3], 10)

      MDArray.lazy = true

    end


    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "execute lazy operations" do

      p "2 a"
      a_2 = (@a + @a)[]
      a_2.print

      c = 2 * @a

      lazy_c = @a + @b
      # calculate the value of the lazy array with []
      c = lazy_c[]
      c.print

      c = (@c + @a)[]
      c = (@a + @c)[]

      c = (@c + @byte)[]
      c = (@byte + @c)[]
     
      lazy_c = (@a * @d - @e) - (@b + @c)
      lazy_c[].print

      # evaluate the lazy expression with [] on the same line
      d = ((@a * @d - @e) - (@b + @c))[]
      d.print

      # evaluate lazy expression with [] anywhere in the expression. (@a * @d - @e) is 
      # done lazyly then evaluated then operated with a lazy (@b + @c).  The final 
      # result is lazy
      d = ((@a * @d - @e)[] - (@b + @c))
      d.print

      MDArray.lazy = false

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "check that lazy is contagious" do

      # this is done lazyly as we have "MDArray.lazy = true" defined in the setup
      l_c = @a + @b

      # now operations are done eagerly
      MDArray.lazy = false
      e_e = @c + @b
      # note that we do not require [] before printing e_e
      e_e.print

      # now operating a lazy array with an eager array... should be lazy even when 
      # MDArray.lazy is false
      l_f = l_c + e_e
      l_f.print
      # request the calculation and print
      l_f[].print

      MDArray.lazy = false

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "execute operations eagerly" do

      MDArray.lazy = false

      c = @a + @b
      c.print

      c = (@a * @d - @e) - (@b + @c)
      c.print

      MDArray.lazy = false

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "show that lazy is really lazy" do

      # MDArray lazy operations are really lazy, i.e., there is not checking of any sort
      # when parsing the expression.  Validation is only done when values are required.

      a = MDArray.int([2, 3], [1, 2, 3, 4, 5, 6])
      b = MDArray.double([3, 1], [1, 2, 3])


      # arrays a and b are of different shape and cannot work together. Yet, there will
      # be no error while parsing
      l_c = a + b

      # now we get an error
      assert_raise ( RuntimeError ) { l_c[].print }

      # now lets add correctly
      p "calculating lazy c"
      l_c = @a + @b
      l_c[].print

      # now lets change @b
      @b[0, 0] = 1000
      # and calculate again lazy c
      p "calculating lazy c again"
      l_c[].print

      p "calculating expression"
      @b[1, 0] = 2000
      p1 = (@a * @d - @e)[]
      p2 = (@b + @c)[]
      (p1 - p2)[].print
      p "@b is"
      @b.print

      # evaluate lazy expression with [] anywhere in the expression. (@a * @d - @e) is 
      # done lazyly then evaluated then operated with a lazy (@b + @c).  The final 
      # result is lazy
      p "calculating lazy d"
      d = ((@a * @d - @e)[] - (@b + @c))
      d[].print
      # lets now change the value of @a
      @a[0, 0] = 1000
      # no change in d... @a has being eagerly calculated
      p "lazy d again after changing @a"
      d[].print
      # lets now change @b
      @b[0, 0] = 1
      @b[0, 1] = 150
      @b[1, 1] = 1000
      p "b is now:"
      @b.print
      # @b is still lazy on d calculation, so changing @b will change the value 
      # of d[].
      p "lazy d again after changing @b"
      d[].print

      p "calculating new expression"
      p3 = (@b + @c)
      (p1 - p3)[].print

      MDArray.lazy = false

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "work with Numeric" do

      l_c = @a + 2
      l_c[].print

      l_c = 2 + @a
      l_c[].print

      l_c = 2 - @a
      l_c[].print

      MDArray.lazy = false

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------
    should "work with unary operators" do

      # MDArray.lazy = false

      arr = MDArray.linspace("double", 0, 1, 100)
      l_a = arr.sin
      l_a.print

      b = l_a[]
      b.print

      ((@a * @d - @e).sin - (@b + @c))[].print

      sinh = (arr.sinh)[]
      
      MDArray.lazy = false

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

=begin
    should "convert expressions involving only arrays to RPN" do

      lazy_c = @a + @b
      assert_equal("int int add ", lazy_c.rpn)

      lazy_d = @a * @b
      assert_equal("int int mul ", lazy_d.rpn)

      lazy_e = lazy_c / lazy_d
      assert_equal("int int add int int mul div ", lazy_e.rpn)

      lazy_c = @a - @b + (@c * @d / (@f + @g))
      assert_equal("int int sub int int mul int int add div add ", lazy_c.rpn)

      lazy_f = @a - @b + (@c * @d - @f / (@f + @g))
      assert_equal("int int sub int int mul int int int add div sub add ", lazy_f.rpn)

    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "validate operations" do

      lazy_c = @a + @b
      lazy_c.validate

      # does not validate as shapes are different
      lazy_e = @h + @a
      assert_raise ( RuntimeError ) { lazy_e.validate }

      lazy_f = @h + @i - @a + @b
      assert_raise ( RuntimeError ) { lazy_f.validate }

      lazy_g = @h + @i

      lazy_k = lazy_g + lazy_c
      assert_raise ( RuntimeError ) { lazy_k.validate }
      
    end

    #-------------------------------------------------------------------------------------
    #
    #-------------------------------------------------------------------------------------

    should "convert expressions involving numeric to RPN" do

    end
=end
  end
  
end
