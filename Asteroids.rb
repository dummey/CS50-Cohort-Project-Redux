$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
$MEDIA_ROOT = File.dirname(__FILE__) + '/media'

require 'gosu'

require_relative 'config/config'

require 'scenes/game_scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
require 'game_objects/ui'

class MyWindow < Gosu::Window
  def initialize
    super($CONFIG[:window_size_x],
          $CONFIG[:window_size_y],
          $CONFIG[:window_full_screen])
    self.caption = 'Asteroids!'


    @background = Background.new(self.width, self.height)
    #@bg_music = Gosu::Song.new($MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.mp3")
    @ui = UI.new
    @asteroid = Asteroid.new(self.width, self.height)
    @player = Player.new(self.width, self.height)
  end

  def update
    #@bg_music.play(true) unless @bg_music.playing?
    @background.update
    @asteroid.update
    @player.update
  end

  def draw
    @background.draw
    @ui.draw
    @asteroid.draw
    @player.draw
  end
end

$WINDOW = MyWindow.new
$WINDOW.show
