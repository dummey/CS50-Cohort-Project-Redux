require 'game_object'
require 'game_objects/ui_components/character_dialog'
require 'game_objects/role/draw_helper'
require 'game_objects/role/defaultable'
require 'game_objects/role/chipmunk_object'

class UFO < GameObject
  include DrawHelper

  include Defaultable
  def _defaults
    {
      :ai_interval => 100,
      :follow => nil,
      :image_path => $CONFIG[:sprite_ufo].sample,
      :init_x_pos => rand(0...@scene.width),
      :init_y_pos => rand(0...@scene.height),
      :mass => 4,
      :max_acceleration => 100.0,
      :max_velocity => 50.0,
      :moment_of_inertia => 150,
      :scale => 0.5,
      :spin_rate => Math::PI/20.0,
      :z_index => 5, #$CONIFG[:z_index_ufo]
    }
  end

  include ChipmunkObject

  attr_reader :shape

  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)

    setup_chipmunk

    @time_alive = 0
    @last_ai_update = -1 * Float::INFINITY
  end

  def accelerate(x, y)
    @shape.body.reset_forces
    @shape.body.apply_force(
      CP::Vec2.new(x, y),
      CP::Vec2::ZERO
    )
  end

  def _ai
    @time_alive += @scene.update_interval
    if (@time_alive - @last_ai_update > @ai_interval)
      if @follow
        x_pos = @follow.shape.body.p.x - @shape.body.p.x
        y_pos = @follow.shape.body.p.y - @shape.body.p.y

        self.accelerate(x_pos * 100, y_pos * 100)
      else
        self.accelerate(Gosu::random(-@max_acceleration, @max_acceleration),
                        Gosu::random(-@max_acceleration, @max_acceleration))
      end
      @last_ai_update = @time_alive
    end
  end

  def spawn_baby
    UFO.new(@scene, :scale => @scale / 2,
            :mase => @mass / 4,
            :init_x_pos => self.body.p.x,
            :init_y_pos => self.body.p.y,
            :follow => self,
            :max_velocity => @max_velocity * 10)
  end

  def update
    _ai

    #Spinnnn!
    @shape.body.a += @spin_rate

    #Wrap around the field
    @shape.body.p.x = @shape.body.p.x % @scene.width
    @shape.body.p.y = @shape.body.p.y % @scene.height

    self
  end

  def draw
    #Draw main
    draw_centered(self.body.p.x, self.body.p.y)

    if (self.body.p.y < image.height / 2)
      draw_centered(self.body.p.x, @scene.height + self.body.p.y)
    elsif (self.body.p.y > @scene.height + image.height / 2)
      draw_centered(self.body.p.x, self.body.p.y - @scene.height)
    elsif (self.body.p.x < image.width / 2)
      draw_centered(@scene.width + self.body.p.x, self.body.p.y)
    elsif (self.body.p.x > @scene.width + image.width / 2)
      draw_centered(self.body.p.x - @scene.width, self.body.p.y)
    end

    self
  end
end
