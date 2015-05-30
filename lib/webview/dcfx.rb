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

class DCFX < JRubyFX::Application
  include_package "javax.script"

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  class << self

    attr_accessor :dashboard
    attr_accessor :width
    attr_accessor :height
    attr_reader :web_engine

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def plot

    DCFX.dashboard.run(@web_engine)

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------

  def start(stage)

    browser = WebView.new
    @web_engine = browser.getEngine()
    
    # Load configuration file
    f = Java::JavaIo.File.new("#{File.dirname(__FILE__)}/config.html")
    fil = f.toURI().toURL().toString()
    @web_engine.load(fil)


    #--------------------------------------------------------------------------------------
    # User Interface
    #--------------------------------------------------------------------------------------

    # Add button to run the script. Later should be removed as the graph is supposed to 
    # run when the window is loaded
    script_button = build(Button, "Run script")
    script_button.set_on_action { |e| plot }

    # Add a menu bar
    menu_bar = build(MenuBar)
    menu_filters = build(Menu, "Filters")
    # add filters to the filter menu
    # add_filters
    menu_bar.get_menus.add_all(menu_filters)

    with(stage, title: "Image Viewer") do
      layout_scene(DCFX.width, DCFX.height, :oldlace) do
        pane = border_pane do
          top menu_bar 
          center browser
          right script_button
        end
      end
      show
    end

  end

  #----------------------------------------------------------------------------------------
  #
  #----------------------------------------------------------------------------------------
  
  def self.launch(dashboard, width, height)

    DCFX.dashboard = dashboard
    DCFX.width = width
    DCFX.height = height
    super()

  end

end

