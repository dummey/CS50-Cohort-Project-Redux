require 'gosu'

require 'game_object'
require 'game_objects/role/draw_helper'


class Thruster < GameObject
  include DrawHelper
  include Defaultable
  def _defaults
    {
      :image_path => "media/PNG/Effects/fire03.png",
      :mass => 1,
      :scale => 1,
      :bit_plane => 0,
    }
  end
  
  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)

    @thruster_image = Gosu::Image.new(@image_path)
  end

  def draw(x,y,z, angle)
    @thruster_image.draw_rot(x, y, z, angle, center_x = 0.5, center_y = 0.15)
  end
  

end