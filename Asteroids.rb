$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
$MEDIA_ROOT = File.dirname(__FILE__) + '/media'

require 'gosu'
require 'scenes/game_scene'

class MyWindow < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = 'Asteroids!'


    @background = Background.new(self.width, self.height)
    @bg_music = Gosu::Song.new($MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.mp3")
    @ui = UI.new
  end

  def update
    @bg_music.play(true) unless @bg_music.playing?
    @background.update
  end

  def draw
    @background.draw
    @ui.draw
  end
end

class Background
  def initialize(width, height)
    @background_image = Gosu::Image.new($MEDIA_ROOT + "/Backgrounds/purple.png", :tileable => true)

    @x_num = (width/@background_image.width).to_i
    @y_num = (height/@background_image.height).to_i

    @cycle = 0
  end

  def update
    @cycle -= 0.1
  end

  def draw
    for i in -1..@x_num
      for j in -1..@y_num
        @background_image.draw(i*@background_image.width + @cycle % @background_image.width, j*@background_image.height + @cycle % @background_image.height, 0)
      end
    end
  end
end

class Player
  def initialize

  end

  def update

  end

  def draw

  end
end

class Astroids
  def initialize

  end
end

class UI
  def initialize
    @lives = 3
    @lives_icon = Gosu::Image.new($MEDIA_ROOT + "/PNG/UI/playerLife1_blue.png")
    @score = 0
    @font = Gosu::Font.new(25)

  end

  def update

  end

  def add_score

  end

  def lose_life
    @lives -= 1
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
