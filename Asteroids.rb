$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/config')
$MEDIA_ROOT = File.dirname(__FILE__) + '/media'

require 'gosu'

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


    @background = Background.new(self, {:image => $MEDIA_ROOT + "/Backgrounds/purple.png"})
    @bg_music = Gosu::Song.new($MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.ogg")
    @ui = GameHUD.new(self)
    @asteroid = Asteroid.new(self.width, self.height)
    @player = Player.new(self.width, self.height)
    @right_is_pressed = false
    @left_is_pressed = false
  end

  def update
    @bg_music.play(true) unless @bg_music.playing?
    @background.update
    @asteroid.update
    if @right_is_pressed
      @player.rotate(1)
    end
    if @left_is_pressed
      @player.rotate(-1)
    end
    @player.update
  end

  def draw
    @background.draw
    @ui.draw
    @asteroid.draw
    @player.draw
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
