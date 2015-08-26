require 'game_object'
require 'game_objects/role/draw_helper'
require 'game_objects/role/defaultable'
require 'game_objects/role/chipmunk_object'
require 'game_objects/role/destroyable'

class Asteroid < GameObject
  include DrawHelper
  include ChipmunkObject
  include Defaultable
  include Destroyable

  def _defaults
    {
      :image_path => "media/PNG/Meteors/meteorGrey_big1.png",
      :init_x_pos => rand(0...@scene.width),
      :init_y_pos => rand(0...@scene.height),
      :mass => 10,
      :max_velocity => 500.0,
      :moment_of_inertia => 150,
      :scale => 1,
      :z_index => 1,
      :collision_type => :asteroid,
      :collision_sensor => true,
      :init_rotate => 0,
      :tier => 1,

    }
  end

  def initialize(scene, params = {})
    super(scene)

    setup_defaults(params)
    setup_chipmunk

    @shape_collide = CP::Shape::Circle.new(self.body, self.image.width/4, CP::Vec2::ZERO)
    @shape_collide.collision_type = @collision_type
    scene.space.add_body(self.body)
    scene.space.add_shape(@shape)
    scene.space.add_shape(@shape_collide)
    
    setup_boundary

    # if tier == 1 
    #   @image_path="media/PNG/Meteors/meteorGrey_big1.png"
    # elsif tier == 2
    #   @image_path="media/PNG/Meteors/meteorGrey_med1.png"
    # elsif tier == 3
    #   @image_path="media/PNG/Meteors/meteorGrey_small1.png"
    # end
  
    # @tier=tier

    # @x_velocity = rand(-100...100)
    # @y_velocity = rand(-100...100)
    # if(x_position)
    #   @x_position = x_position
    # else
    #   @x_position = rand(0...@scene.width)
    # end
    # if(y_position)
    #   @y_position = y_position
    # else
    #   @y_position = rand(0...@scene.height)
    # end
    # @rotation_momentum = rand(-10...10)
    # @rotation_angular = rand(-10...10)
  end

  def update
    # update_in_seconds = @scene.update_interval / 1000.0
    # @x_position = @x_position + @x_velocity * update_in_seconds
    # @y_position = @y_position + @y_velocity * update_in_seconds
    # @x_position=@x_position.modulo(@scene.width)
    # @y_position=@y_position.modulo(@scene.height)
    # @rotation_angular = (@rotation_angular + @rotation_momentum * @scene.update_interval / 1000.0)
    if destroyed?
      return [] if @tier == 3

      @new_asteroids = []
      3.times do 
        @new_asteroids << Asteroid.new(@scene, init_x_pos: body.p.x, init_y_pos: body.p.y, tier: @tier+1)
      end
      @new_asteroids
    else
      self
    end
  end

  def draw
    draw_with_boundary

    self
  end

end