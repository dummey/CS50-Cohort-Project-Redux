require 'gosu'

require 'scene'
require 'scenes/game_scene'
require 'game_objects/background'
require 'game_objects/pulsing_star'
require 'game_objects/ui_components/button'
require 'game_objects/ui_components/cursor'
require 'game_objects/ui_components/title'
require 'game_objects/ui_components/subtitle'

class MenuScene < Scene
  def _defaults(params)
    {
      :max_stars => 100,
      :scale => 1,
      :background_image_path => $MEDIA_ROOT + "/Backgrounds/purple.png",
      :background_music_path => $MEDIA_ROOT + "/Music/Digital-Fallout_v001.ogg",
      :cursor_image_path => $MEDIA_ROOT + "/PNG/UI/cursor.png",
    }.merge(params)
  end

  def initialize(window, params={})
    super(window)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @background = Background.new(self, {
                                   :image => @background_image_path,
                                   :music => @background_music_path,
    })
    @game_objects.push(@background)

    @cursor = Cursor.new(self, cursor_image_path: @cursor_image_path)
    @game_objects.push(@cursor)

    @start_button = Button.new(self)
    @game_objects.push(@start_button)

    # @title = 
    @title = Title.new(self, text: "ASTEROIDSSS!")
    @game_objects.push(@title)

    @subtitle = Subtitle.new(self)
    @game_objects.push(@subtitle)

    #@spaceship = Gosu::Image.new("media/PNG/playerShip3_green.png")

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
    #@spaceship.draw(800, 325, 1, 0.5, 0.5)
    self
  end

end