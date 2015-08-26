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
  end

  def update
    #Wrap around the field
    @shape.body.p.x = @shape.body.p.x % @scene.width
    @shape.body.p.y = @shape.body.p.y % @scene.height

    if destroyed?
      return nil if @tier == 3

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