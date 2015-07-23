require 'scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
require 'game_objects/ufo'
require 'game_objects/game_hud'

class GameScene < Scene
  attr_accessor :window, :lives, :score, :space
  def initialize(window)
    @window = window
    
    @space = CP::Space.new()

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
  end

  def update
    @space.step(1)
    @game_duration += self.update_interval
    @score = @game_duration.to_i / 1000

    @background.update
    @ui.update
    @asteroid1.update
    @asteroid2.update
    @asteroid3.update

    if Gosu::button_down? Gosu::KbRight
      @player.rotate(1)
    end
    if Gosu::button_down? Gosu::KbLeft
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
    
  end

  def button_up(id)
  
  end
end
