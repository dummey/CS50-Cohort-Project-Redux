$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/config')
$MEDIA_ROOT = File.dirname(__FILE__) + '/media'

require 'gosu'
require 'chipmunk'

require 'config'

require 'scenes/game_scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
require 'game_objects/game_hud'

class MyWindow < Gosu::Window
  def initialize
    super($CONFIG[:window_size_x],
          $CONFIG[:window_size_y],
          $CONFIG[:window_full_screen])
    self.caption = 'Asteroids!'

    @scenes = [GameScene.new(self)]
    
    @right_is_pressed = false
    @left_is_pressed = false
  end

  def update
    @scenes.last.update
  end

  def draw
    @scenes.last.draw
  end

  def button_down(id)
    case id
    when Gosu::KbRight
      @right_is_pressed = true
    when Gosu::KbLeft
      @left_is_pressed = true
    end
  end

  def button_up(id)
    case id
    when Gosu::KbRight
      @right_is_pressed = false
    when Gosu::KbLeft
      @left_is_pressed = false
    end

  end
end

$WINDOW = MyWindow.new
$WINDOW.show
