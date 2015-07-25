require 'scenes'

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

  end

  def update

  end

  def draw

  end
end