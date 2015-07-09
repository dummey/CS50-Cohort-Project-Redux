$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
$MEDIA_ROOT = File.dirname(__FILE__) + '/media'

require 'gosu'
require 'scenes/game_scene'
require 'game_objects/asteroid'
require 'game_objects/background'

class MyWindow < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = 'Asteroids!'


    @background = Background.new(self.width, self.height)
    @bg_music = Gosu::Song.new($MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.mp3")
    @ui = UI.new
    @asteroid = Asteroid.new(self.width, self.height)
    @player = Player.new(self.width, self.height)
  end

  def update
    @bg_music.play(true) unless @bg_music.playing?
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

class UI
  def initialize
    @lives = 3
    @lives_icon = Gosu::Image.new($MEDIA_ROOT + "/PNG/UI/playerLife1_blue.png")
    @score = 0
    @font = Gosu::Font.new(25)

  end

  def _draw_lives
    @lives.times do |i|
      @lives_icon.draw(10 + 40 * i, 10, 1)
    end
  end

  def _draw_score

  end

  def draw
    # @font.draw("Lives: #{@lives}", 10,10,1)
    self._draw_lives
    @font.draw("Score: #{@score}", 10,40,1)
  end
end


$WINDOW = MyWindow.new
$WINDOW.show
