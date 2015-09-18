require 'gosu'

require 'scene'
require 'scenes/game_scene'
require 'scenes/credits_scene'
require 'game_objects/background'
require 'game_objects/pulsing_star'
require 'game_objects/laser_beam'
require 'game_objects/ui_components/button'
require 'game_objects/ui_components/cursor'
require 'game_objects/ui_components/title'
require 'game_objects/ui_components/subtitle'
require 'game_objects/role/edge_collision'
require 'game_objects/role/defaultable'

class MenuScene < Scene
  include Defaultable
  attr_accessor :space

  def _defaults
    {
      :max_stars => 100,
      :background_image_path => $MEDIA_ROOT + "/Backgrounds/purple.png",
      :background_music_path => $MEDIA_ROOT + "/Music/Digital-Fallout_v001.ogg",
      :cursor_image_path => $MEDIA_ROOT + "/PNG/UI/cursor.png",
    }
  end

  def initialize(window, params={})
    super(window)
    setup_defaults(params)
    
    @space = CP::Space.new()
    @space.damping = 0.8

    add_game_object Background.new(self, {
                                   :image => @background_image_path,
                                   :music => @background_music_path,
    })

    add_game_object Cursor.new(self, cursor_image_path: @cursor_image_path)
    @start_button = Button.new(self, text: "Start!", y_pos: self.height * 10 / 12)
    add_game_object @start_button
    add_game_object Title.new(self, text: "ASTEROIDSSS!")
    add_game_object Subtitle.new(self)
    @credits_button = Button.new(self, text: "Credits", y_pos: self.height * 11 / 12)
    add_game_object @credits_button
    
    @player = Player.new(self, :init_x_pos => self.width / 2, :init_y_pos => self.height / 2 - 50, :invulnerability_duration => 0)
    add_game_object @player
    @lasers = []
    
    EdgeCollision.create_universe_boundary(self.width, self.height, @space, [:player_sensor, :laser])

  end

  def update
    super

    #check for start game action: enter key or left click on start
    if (@window.button_down?(Gosu::KbEnter) || 
        @window.button_down?(Gosu::KbReturn) ||
       (@window.button_down?(Gosu::MsLeft) && @start_button.intersect?(@window.mouse_x, @window.mouse_y))
      )
      return [self, GameScene.new(@window)]
    end

    #enable credits button
    if (@window.button_down?(Gosu::MsLeft) && @credits_button.intersect?(@window.mouse_x, @window.mouse_y))
      return [self, CreditScreen.new(@window)]
    end

    #spawn up to @max_stars number of stars
    if (game_objects.count{|o| o.is_a?(PulsingStar)} < @max_stars)
      add_game_object PulsingStar.new(self)
    end
    
    if Gosu::button_down? Gosu::KbRight
      @player.rotate(3)
    end
    if Gosu::button_down? Gosu::KbLeft
      @player.rotate(-3)
    end
    if Gosu::button_down? Gosu::KbUp
      @player.thrust(50)
    end
    
    if ((Gosu::button_down? Gosu::KbRightShift) || (Gosu::button_down? Gosu::KbLeftShift)) && !@shift_down
      @player.jump
      @shift_down = true
    end

    if !(Gosu::button_down? Gosu::KbRightShift) && !(Gosu::button_down? Gosu::KbLeftShift)
      @shift_down = false
    end

    if (Gosu::button_down? Gosu::KbSpace) && !@space_down
      laser = Laser_Beam.new(self)
      @player.fire(laser)
      
      @lasers << laser
      @space_down = true
    end
  
    if !Gosu::button_down? Gosu::KbSpace
      @space_down = false
    end

    @space.step(1.0/60.0)

    @lasers.each(&:update)
    @lasers.each { |laser|
      if laser.reached_range?
        @lasers.delete(laser)
        laser.remove_from_game
      end
    }

    
    self
  end

  def draw
    super
    
    @player.draw
    @lasers.each(&:draw)
    
    self
  end

end