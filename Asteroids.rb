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
  def initialize(width, height)
    #scale ship
    @player = Gosu::Image.new("media/PNG/playerShip3_green.png")
  end

  def update

  end

  def draw
    @player.draw(69, 69, 1)
  end
end

class Asteroid
  def initialize(width, height)
    @asteroid_image = Gosu::Image.new("media/PNG/Meteors/meteorGrey_big1.png", :tileable => true)
    @x_velocity = rand(0...4)
    @y_velocity = rand(0...4)
    @x_position = 100
    @y_position = 100
  end

  def update
@x_position = @x_position + @x_velocity
@y_position = @y_position + @y_velocity
  end

  def draw
    @asteroid_image.draw(@x_position, @y_position, 1)
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
