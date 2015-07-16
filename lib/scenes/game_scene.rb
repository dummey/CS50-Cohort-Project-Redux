require 'scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
require 'game_objects/game_hud'

class GameScene < Scene
  attr_accessor :window, :lives, :score
  def initialize(window)
    super(window)

    self.lives = $CONFIG[:initialize_lives]
    self.score = $CONFIG[:initialize_score]

    @background = Background.new(self, {
                                   :image => $MEDIA_ROOT + "/Backgrounds/purple.png",
                                   :music => $MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.ogg"
    })

    @ui = GameHUD.new(self)
    @asteroid = Asteroid.new(self)
    @player = Player.new(self)
    @right_is_pressed = false
    @left_is_pressed = false
  end

  def update
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
