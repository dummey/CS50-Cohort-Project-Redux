require 'gosu'

require 'game_object'
require 'game_objects/role/draw_helper'
require 'game_objects/role/chipmunk_object'
require 'game_objects/player'

class Thruster < GameObject
  include DrawHelper
  include ChipmunkObject
  include Defaultable
  def _defaults
    {
      :image_path => "media/PNG/Effects/fire03.png",
      :mass => 1,
      :moment_of_inertia => 1,
      :init_x_pos => 100,
      :init_y_pos => 100,
      :duration => 2000,
      :scale => 1,
      :bit_plane => 129,
      :angle => 0
    }
  end
  
  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)
    setup_chipmunk
    @time_alive = 0
    @timed_out = false

    @thruster_image = Gosu::Image.new(@image_path)
  end

  def animate(position, velocity)
    self.body.p = position
    self.body.v = velocity
    self.body.activate
  
  end
  
  def update
    @time_alive += @scene.update_interval
    @timed_out = (@time_alive.to_i > @duration)
    if (@time_alive.to_i > @duration)
      return nil
    end
    self
  end

  def draw
    @thruster_image.draw_rot(@init_x_pos, @init_y_pos, 100, @angle)
  end
  

end