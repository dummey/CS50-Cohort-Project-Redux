require 'gosu'
require 'scene'
require 'scenes/menu_scene'
require 'game_object'
require 'game_objects/background'
require 'game_objects/ui_components/cursor'
require 'game_objects/ui_components/button'
require 'game_objects/ui_components/credits_text'
require 'game_objects/role/defaultable'

class CreditScreen < Scene
  include Defaultable
  
  def _defaults(params)
    {
      :scale => 1,
      :background_image_path => $MEDIA_ROOT + "/Backgrounds/purple.png",
      :background_music_path => $MEDIA_ROOT + "/Music/Digital-Fallout_v001.ogg",
      :cursor_image_path => $MEDIA_ROOT + "/PNG/UI/cursor.png",
    }.merge(params)
  end

  def initialize(window, params={})
    super(window)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    add_game_object Background.new(self, {
                                   :image => @background_image_path,
                                   :music => @background_music_path,
    })

    @cursor = Cursor.new(self, cursor_image_path: @cursor_image_path)

    @title = Title.new(self, text: "Credits", y_pos: 100)

    @credits_text = CreditsText.new(self)
    
    @return_button = Button.new(self, text: "Return", y_pos: self.height * 11 / 12)
    add_game_object @return_button


  end

  def update
    super
    
    if (@window.button_down?(Gosu::MsLeft) && @return_button.intersect?(@window.mouse_x, @window.mouse_y))
      return [self, MenuScene.new(@window)]
    end
    
    self
  end

  def draw
    super
    
    @cursor.draw()
    @title.draw()
    @credits_text.draw()


    self
  end
end