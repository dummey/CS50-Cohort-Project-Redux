require 'gosu'

require 'scene'
require 'scenes/game_scene'
require 'game_objects/background'
require 'game_objects/pulsing_star'

MAX_STARS = 100

class MenuScene < Scene
  def initialize(window)
    super(window)

    @background = Background.new(self, {
                                   :image => $MEDIA_ROOT + "/Backgrounds/purple.png",
                                   :music => $MEDIA_ROOT + "/Music/Digital-Fallout_v001.ogg"
    })
    @game_objects.push(@background)
    @cursor = Gosu::Image.new($MEDIA_ROOT + "/PNG/UI/cursor.png")

    @text = Gosu::Font.new(50, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")
  end

  def update
    super

    if (@window.button_down?(Gosu::KbSpace))
      return [self, GameScene.new(@window)]
    end

    if (@game_objects.count{|o| o.is_a?(PulsingStar)} < MAX_STARS)
      @game_objects.push(PulsingStar.new(self))
    end

    self
  end

  def draw
    super
    @cursor.draw(@window.mouse_x, @window.mouse_y, 100)
    @text.draw_rel("Press 'Space' to Start", @window.width / 2, @window.height * 2/3, 5, 0.5, 0.5)

    self
  end

end