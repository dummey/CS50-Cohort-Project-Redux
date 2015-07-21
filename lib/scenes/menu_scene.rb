require 'gosu'

require 'scene'
require 'scenes/game_scene'
require 'game_objects/background'
require 'game_objects/pulsing_star'
require 'game_objects/ui_components/button'

class MenuScene < Scene
  def _defaults(params)
    {
      :max_stars => 100,
      :scale => 1,
      :background_image_path => $MEDIA_ROOT + "/Backgrounds/purple.png",
      :background_music_path => $MEDIA_ROOT + "/Music/Digital-Fallout_v001.ogg",
      :cursor_image_path => $MEDIA_ROOT + "/PNG/UI/cursor.png",
      :title_text => "ASTEROIDSSS!",
    }.merge(params)
  end

  def initialize(window)
    super(window)

    @background = Background.new(self, {
                                   :image => @background_image_path,
                                   :music => @background_music_path,
    })
    @game_objects.push(@background)

    @cursor = Gosu::Image.new(@cursor_image_path)

    @start_button = Button.new(self)
    @game_objects.push(@start_button)

    @title = Gosu::Font.new(128, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")
  end

  def update
    super

    #check for start game action: spacebar and left click on start
    if (@window.button_down?(Gosu::KbSpace) || 
       (@window.button_down?(Gosu::MsLeft) && @start_button.intersect?(@window.mouse_x, @window.mouse_y))
      )
      return [self, GameScene.new(@window)]
    end

    #spawn up to @max_stars number of stars
    if (@game_objects.count{|o| o.is_a?(PulsingStar)} < @max_stars)
      @game_objects.push(PulsingStar.new(self))
    end

    self
  end

  def draw
    super
    @title.draw_rel(@title_text, @window.width / 2 + 2, @window.height * 1/3 + 2, 10, 0.5, 0.5, @scale, @scale, 0x40_000000)
    @title.draw_rel(@title_text, @window.width / 2, @window.height * 1/3, 10, 0.5, 0.5)

    @cursor.draw(@window.mouse_x, @window.mouse_y, 100)
    self
  end

end