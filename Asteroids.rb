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
  end

  def update
    @bg_music.play(true) unless @bg_music.playing?
    @background.update
  end

  def draw
    @background.draw
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
    @cycle -= 1
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

window = MyWindow.new
window.show
