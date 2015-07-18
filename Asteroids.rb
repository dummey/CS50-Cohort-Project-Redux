$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/config')

require 'gosu'
require 'chipmunk'

require 'config'

require 'scenes/menu_scene'

class MyWindow < Gosu::Window
  attr_accessor :scenes

  def initialize
    super($CONFIG[:window_size_x],
          $CONFIG[:window_size_y],
          $CONFIG[:window_full_screen])
    self.caption = 'Asteroids!'

    @scenes = [MenuScene.new(self)]
  end

  def update
    @current_scene = @scenes.pop
    @current_scene = @current_scene.update
    @scenes.push(@current_scene)
    @scenes.flatten!
    @scenes.compact!
  end

  def draw
    @scenes.last.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    else
      @scenes.last.button_down(id)
    end
  end

  def button_up(id)
    @scenes.last.button_up(id)
  end

  def needs_cursor
    $CONFIG[:window_show_cursor]
  end
end

$WINDOW = MyWindow.new
$WINDOW.show
