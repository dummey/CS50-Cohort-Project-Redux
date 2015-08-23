require 'gosu'
require 'scene'
require 'game_object'
require 'game_objects/ui_components/cursor'
require 'game_objects/ui_components/credits_text'

class CreditScreen < Scene
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

    @background = Background.new(self, {
                                   :image => @background_image_path,
                                   :music => @background_music_path,
    })

    @cursor = Cursor.new(self, cursor_image_path: @cursor_image_path)

    @title = Title.new(self, text: "Credits", y_pos: 100)

    @credits_text = CreditsText.new(self)


  end

  def update
    super
    self
  end

  def draw
    super

    @background.draw()
    @cursor.draw()
    @title.draw()
    @credits_text.draw()


    self
  end
end