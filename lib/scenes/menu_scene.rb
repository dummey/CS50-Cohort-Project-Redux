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

    @text = Gosu::Font.new(50)
  end

  def update
    super

    if (@window.button_down?(Gosu::KbSpace))
      @window.scenes.push(GameScene.new(@window))
    end

    if (@game_objects.count{|o| o.is_a?(PulsingStar)} < MAX_STARS)
      @game_objects.push(PulsingStar.new(self))
    end
  end

  def draw
    super

    @text.draw_rel("Press 'Space' to Start", @window.width / 2, @window.height / 2, 5, 0.5, 0.5)
  end

end