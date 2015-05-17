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


#==========================================================================================
#
#==========================================================================================

class Nashorn < JRubyFX::Application
  include_package "javax.script"

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  attr_reader :engine

  # When view is true the following variables will be set
  attr_reader :browser
  attr_reader :window
  attr_reader :document

  def start(stage)

    # Create a WebView and get a web_engine
    @browser = WebView.new
    @window = browser.engine.executeScript("window")
    @web_engine = browser.getEngine()
    @web_engine.setJavaScriptEnabled(true)

    # Create a Nashorn engine
    factory = Java::JavaxScript.ScriptEngineManager.new()
    @engine = factory.getEngineByName("nashorn")

    # JSAdapter.new

  end

=begin
  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def initialize(view = false)

    if view
      @browser = WebView.new
      @engine = browser.getEngine()
    else
      factory = Java::JavaxScript.ScriptEngineManager.new()
      @engine = factory.getEngineByName("nashorn")
      super()
    end

  end
=end


  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def method_missing(symbol, *args)

    name = symbol.id2name

    if name =~ /(.*)=$/
      super if args.length != 1
      ret = assign($1,args[0])
    else
      params = parse(*args)
      # p "#{name}(#{params})"
      # ret = eval("#{name}(#{params})")
      begin
        ret = @engine.invokeFunction(name, params)
      rescue Java::JavaLang::NoSuchMethodException => e
        p e.message
        raise NoMethodError.new("Method #{name} is not defined.", name, params)
      end
    end

    ret

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def eval(expression)
    begin
      ret = @engine.eval(expression)
    rescue Java::JavaxScript::ScriptException => e 
      p e.message
=begin
    rescue Java::OrgRenjinParser::ParseException => e
      p e.message
=end
    end

    ret

  end

  #----------------------------------------------------------------------------------------
  # Evaluates an expression but does not wrap the return in a RubySexp.  Needed for 
  # intermediate evaluation done by internal methods.  In principle, should not be
  # called by users.
  #----------------------------------------------------------------------------------------

  def direct_eval(expression)
    begin
      ret = @engine.eval(expression)
    rescue Java::OrgRenjinEval::EvalException => e 
      p e.message
    ensure
=begin
      Renjin.stack.each do |sexp|
        sexp.destroy
      end
=end
    end

    ret

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def parse(*args)

    params = Array.new
    
    args.each do |arg|
      if (arg.is_a? Numeric)
        params << arg
      elsif(arg.is_a? String)
        params << "\"#{arg}\""
      elsif (arg.is_a? Symbol)
        var = eval("#{arg.to_s}")
        params << var.r
      elsif (arg.is_a? TrueClass)
        params << "TRUE"
      elsif (arg.is_a? FalseClass)
        params << "FALSE"
      elsif (arg == nil)
        params << "NULL"
      elsif (arg.is_a? NegRange)
        final_value = (arg.exclude_end?)? (arg.end - 1) : arg.end
        params << "-(#{arg.begin}:#{final_value})"
      elsif (arg.is_a? Range)
        final_value = (arg.exclude_end?)? (arg.end - 1) : arg.end
        params << "(#{arg.begin}:#{final_value})"
      elsif (arg.is_a? Hash)
        arg.each_pair do |key, value|
          params << "#{key.to_s} = #{parse(value)}"
        end
      elsif ((arg.is_a? Renjin::RubySexp) || (arg.is_a? Array) || (arg.is_a? MDArray))
        params << arg.r
      # elsif 
      #  params << arg.inspect
      else
        raise "Unknown parameter type for R: #{arg}"
      end
      
    end

    params.join(",")
      
  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def assign(name, value)

    original_value = value

    if ((value.is_a? MDArray) || (value.is_a? RubySexp))
      if (value.sexp != nil)
        # MDArray already represented in R
        value = value.sexp
      else
        value = build_vector(value)
      end
    elsif (value == nil)
      value = NULL
    end

    @engine.put(name, value)
    original_value
    
  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def pull(name)
    eval(name)
  end
  
  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def install__package(name)

    pm = PackageManager.new
    pm.load_package(name)

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def library(package)

    Dir.chdir(SciCom.cran_dir)
    filename = SciCom.cran_dir + "/#{package}.jar"

    require filename
    eval("library(#{package})")

  end

  #----------------------------------------------------------------------------------------
  # Builds a Renjin vector from an MDArray. Should be private, but public for testing.
  #----------------------------------------------------------------------------------------

  # private

  #----------------------------------------------------------------------------------------
  # Builds a Renjin vector from an MDArray. Should be private, but public for testing.
  #----------------------------------------------------------------------------------------
  
  def build_vector(mdarray)
    
    shape = mdarray.shape
    # index = mdarray.nc_array.getIndex()
    # index = MDArray.index_factory(shape)
    # representation of shape in R is different from shape in MDArray.  Convert MDArray
    # shape to R shape.
    if (shape.size > 2)
      shape.reverse!
      shape[0], shape[1] = shape[1], shape[0]
    end

    # AttributeMap attributes = AttributeMap.builder().setDim(new IntVector(dim)).build();
    attributes = Java::OrgRenjinSexp::AttributeMap.builder()
      .setDim(Java::OrgRenjinSexp::IntArrayVector.new(*(shape))).build()

    # vector = Java::RbScicom::MDDoubleVector.new(mdarray.nc_array, attributes, index,
    #   index.stride)
    
    case mdarray.type
    when "int"
      vector = Java::RbScicom::MDIntVector.factory(mdarray.nc_array, attributes)
    when "double"
      vector = Java::RbScicom::MDDoubleVector.factory(mdarray.nc_array, attributes)
    when "byte"
      vector = Java::RbScicom::MDLogicalVector.factory(mdarray.nc_array, attributes)
    when "string"
      vector = Java::RbScicom::MDStringVector.factory(mdarray.nc_array, attributes)
    when "boolean"
      raise "Boolean vectors cannot be converted to R vectors.  If you are trying to \
convert to an R Logical object, use a :byte MDArray"
    else
      raise "Cannot convert MDArray #{mdarray.type} to R vector"
    end

  end


end

#==========================================================================================
#
#==========================================================================================

# J = Nashorn.new(true)
J = Nashorn
J.launch
