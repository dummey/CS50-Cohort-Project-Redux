require 'gosu'

require 'scene'
require 'scenes/game_scene'
require 'game_objects/background'
require 'game_objects/pulsing_star'
require 'game_objects/ui_components/button'

MAX_STARS = 100

class MenuScene < Scene
  def initialize(window)
    super(window)

    @scale = 1
    @angle = 0

    @background = Background.new(self, {
                                   :image => $MEDIA_ROOT + "/Backgrounds/purple.png",
                                   :music => $MEDIA_ROOT + "/Music/Digital-Fallout_v001.ogg"
    })
    @game_objects.push(@background)
    @cursor = Gosu::Image.new($MEDIA_ROOT + "/PNG/UI/cursor.png")

    # @dialog = Gosu::Image.new($MEDIA_ROOT + "/custom/start_dialog.png")
    # @text = Gosu::Font.new(24, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")

    @start_button = Button.new(self)
    @game_objects.push(@start_button)

    @title = Gosu::Font.new(128, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")
  end

  def update
    super

    if (@window.button_down?(Gosu::KbSpace) || 
       (@window.button_down?(Gosu::MsLeft) && @start_button.intersect?(@window.mouse_x, @window.mouse_y))
      )
      return [self, GameScene.new(@window)]
    end

    if (@game_objects.count{|o| o.is_a?(PulsingStar)} < MAX_STARS)
      @game_objects.push(PulsingStar.new(self))
    end

    self
  end

  def draw
    super
    # @dialog.draw_rot(@window.width / 2 + 2, @window.height * 2/3 + 2, 5, @angle, 0.5, 0.5, @scale, @scale, ((0x8F) << 24) + 0xFFFFFF)
    # @dialog.draw_rot(@window.width / 2, @window.height * 2/3, 5, @angle, 0.5, 0.5, @scale, @scale)

    @title.draw_rel("ASTEROIDSSS!", @window.width / 2 + 2, @window.height * 1/3 + 2, 10, 0.5, 0.5, @scale, @scale, 0x40_000000)
    @title.draw_rel("ASTEROIDSSS!", @window.width / 2, @window.height * 1/3, 10, 0.5, 0.5)

    @cursor.draw(@window.mouse_x, @window.mouse_y, 100)
    self
  end

end