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
# This class executes on a backgroud thread, not the GUI thread.
#==========================================================================================

class Sol
  
  class Dashboard

    private
    
    class MyTask < javafx.concurrent.Task
      
      def initialize
        @bridge = Bridge.instance
      end

      #----------------------------------------------------------------------------------------
      #
      #----------------------------------------------------------------------------------------
      
      def call
        begin
          msg = @bridge.take
          # p msg
          return msg                             # this is the returned message to the handle
        rescue java.lang.InterruptedException => e
          if (is_cancelled)
            updateMessage("Cancelled")
          end
        end

      end

    end

    #==========================================================================================
    # This class executes in the GUI thread.
    #==========================================================================================

    class MyHandle
      include javafx.event.EventHandler

      #----------------------------------------------------------------------------------------
      #
      #----------------------------------------------------------------------------------------

      def initialize(web_engine, service)
        
        @web_engine = web_engine
        @service = service

        @window = @web_engine.executeScript("window")
        @document = @window.eval("document")
        @web_engine.setJavaScriptEnabled(true)
        @bridge = Bridge.instance
        
      end

      #----------------------------------------------------------------------------------------
      #
      #----------------------------------------------------------------------------------------
      
      def handle(event)
        
        # method, scrpt = event.getSource().getValue()
        receiver, method, *args = event.getSource().getValue()
        
        case receiver
        when :gui
          receiver = @web_engine
        when :window
          receiver = @window
        end
        
        receiver.send(method, *args)

        @bridge.mutex.synchronize {
          @bridge.cv.signal
        }
        @service.restart()
        
      end

    end

    #==========================================================================================
    #
    #==========================================================================================

    class MyService < javafx.concurrent.Service

      def createTask
        MyTask.new
      end

    end

    #==========================================================================================
    #
    #==========================================================================================

    class DCFX < JRubyFX::Application
      
      #----------------------------------------------------------------------------------------
      #
      #----------------------------------------------------------------------------------------

      class << self

        attr_accessor :dashboard
        attr_accessor :width
        attr_accessor :height
        attr_accessor :launched

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

        service = MyService.new
        service.set_on_succeeded(MyHandle.new(@web_engine, service))

        #--------------------------------------------------------------------------------------
        # User Interface
        #--------------------------------------------------------------------------------------

        # Add button to run the script. Later should be removed as the graph is supposed to 
        # run when the window is loaded
        # script_button = build(Button, "Run script")
        # script_button.set_on_action { |e| plot }


        # Example on how to: Add a menu bar -- do not delete (yet!)
        # menu_bar = build(MenuBar)
        # menu_filters = build(Menu, "Filters")
        # add filters to the filter menu
        # add_filters
        # menu_bar.get_menus.add_all(menu_filters)

        @web_engine.getLoadWorker().stateProperty().
          addListener(ChangeListener.impl do |ov, old_state, new_state|
                        service.start()
                      end)

        with(stage, title: "Sol Charting Library (based on DC.js)") do
          Platform.set_implicit_exit(false)
          layout_scene(DCFX.width, DCFX.height, :oldlace) do
            pane = border_pane do
              top menu_bar 
              center browser
              # right script_button
            end
          end
          set_on_close_request do
            stage.close
          end
          show
        end

=begin
        @web_engine.set_on_status_changed { |e| p e.toString() }
        @web_engine.set_on_alert { |e| p e.toString() }
        @web_engine.set_on_resized { |e| p e.toString() }
        @web_engine.set_on_visibility_changed { |e| p e.toString() }
        browser.set_on_mouse_entered { |e| p e.toString() }
=end

      end

      #----------------------------------------------------------------------------------------
      #
      #----------------------------------------------------------------------------------------

      def self.launched?
        (DCFX.launched)? true : false
      end

      #----------------------------------------------------------------------------------------
      #
      #----------------------------------------------------------------------------------------
      
      def self.launch(dashboard, width, height)
        DCFX.launched = true
        DCFX.dashboard = dashboard
        DCFX.width = width
        DCFX.height = height
        super()
      end

    end

  end
  
end

=begin
class MyClass
  include javafx.beans.value.ChangeListener

  def changed(ov, old_state, new_state)
    p "I'm now changed"
  end
end
=end
