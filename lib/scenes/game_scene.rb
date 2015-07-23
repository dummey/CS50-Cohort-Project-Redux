require 'scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
require 'game_objects/ufo'
require 'game_objects/game_hud'

class GameScene < Scene
  attr_accessor :window, :lives, :score
  def initialize(window)
    @window = window

    @lives = $CONFIG[:initialize_lives]
    @score = $CONFIG[:initialize_score]
    @game_duration = 0.0

    @background = Background.new(self, {
                                   :image => $MEDIA_ROOT + "/Backgrounds/purple.png",
                                   :music => $MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.ogg"
    })

    @ui = GameHUD.new(self)
    @asteroid1 = Asteroid.new(self)
    @asteroid2 = Asteroid.new(self)
    @asteroid3 = Asteroid.new(self)
    @player = Player.new(self)
    @ufo = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][0])
    @ufo2 = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][1])
    @ufo3 = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][2])
    @right_is_pressed = false
    @left_is_pressed = false
  end

  def update
    @game_duration += self.update_interval
    @score = @game_duration.to_i / 1000

    @background.update
    @ui.update
    @asteroid1.update
    @asteroid2.update
    @asteroid3.update

    if @right_is_pressed
      @player.rotate(1)
    end
    if @left_is_pressed
      @player.rotate(-1)
    end
    @player.update

    @ufo.update
    @ufo2.update
    @ufo3.update

    self
  end

  def draw
    @background.draw
    @ui.draw
    @asteroid1.draw
    @asteroid2.draw
    @asteroid3.draw
    @player.draw
    @ufo.draw
    @ufo2.draw
    @ufo3.draw

    self
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
