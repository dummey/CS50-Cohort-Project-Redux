$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/config')
$MEDIA_ROOT = File.dirname(__FILE__) + '/media'

require 'gosu'
require 'chipmunk'

require 'config'

require 'scenes/game_scene'

class MyWindow < Gosu::Window
  attr_accessor :scenes

  def initialize
    super($CONFIG[:window_size_x],
          $CONFIG[:window_size_y],
          $CONFIG[:window_full_screen])
    self.caption = 'Asteroids!'

    @scenes = [GameScene.new(self)]
  end

  def update
    @scenes.last.update
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
end

$WINDOW = MyWindow.new
$WINDOW.show
