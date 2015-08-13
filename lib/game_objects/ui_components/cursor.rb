require 'game_object'
require 'game_objects/role/defaultable'

class Cursor < GameObject
  include Defaultable

  def _defaults
    {
      :cursor_image_path => $MEDIA_ROOT + "/PNG/UI/cursor.png",
      :z_index => 200,
    }
  end

  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)

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