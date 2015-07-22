require 'game_object'

class Cursor < GameObject
  def _defaults(params)
    {
      :cursor_image_path => $MEDIA_ROOT + "/PNG/UI/cursor.png",
      :z_index => 200,
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @cursor_image = Gosu::Image.new(@cursor_image_path)
  end

  def update

    self
  end

  def draw
    @cursor_image.draw(@scene.mouse_x, @scene.mouse_y, @z_index)

    self
  end
end