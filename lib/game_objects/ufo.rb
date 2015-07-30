require 'game_object'
require 'game_objects/ui_components/character_dialog'

class UFO < GameObject
  attr_reader :shape

  def _defaults(params)
    {
      :image_path => $CONFIG[:sprite_ufo].sample,
      :init_x_pos => rand(0...@scene.width),
      :init_y_pos => rand(0...@scene.height),
      :scale => 0.5,
      :spin_rate => Math::PI/20.0,
      :ai_interval => 1000,
      :angle => 0,
      :z_index => 5, #$CONIFG[:z_index_ufo]
      :max_acceleration => 100.0,
      :num_mini_me => 3,
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @image = Gosu::Image.new(@image_path)
    body = CP::Body.new(10.0, 150.0)
    body.p.x = @init_x_pos
    body.p.y = @init_y_pos
    @shape = CP::Shape::Circle.new(body, @image.width, CP::Vec2::ZERO)

    @time_alive = 0
    @last_ai_update = -1 * Float::INFINITY

    # @mini_mes = []
    # @num_mini_me.times {
    #   @mini_mes.push(UFO.new(@scene,
    #                          :scale => @scale / 2,
    #                          :num_mini_me => 0,
    #                          :ai_interval => Float::INFINITY,
    #                          :max_velocity => 25,
    #                          :max_acceleration => 25,
    #                          :image_path => @image_path,
    #                          ))
    # }
  end

  def accelerate(x, y)
    @shape.body.apply_force(CP::Vec2.new(x, y), CP::Vec2.new(0.0, 0.0))
  end

  #deals with wrap around logic
  # def accelerate_towards(x, y, magnitude = @max_acceleration / 2)
  #   # horizontal
  #   right_distance = 0
  #   left_distance = 0
  #   if (@x_pos < x)
  #     right_distance = x - @x_pos
  #     left_distance =  @scene.width - x + x_pos
  #   else
  #     right_distance = @scene.width - @x_pos + x
  #     left_distance = @x_pos - x
  #   end

  #   if (right_distance < left_distance)
  #     self.accelerate(magnitude, 0)
  #   else
  #     self.accelerate(-magnitude, 0)
  #   end

  #   #vertical
  #   bottom_distance = 0
  #   top_distance = 0
  #   if (@y_pos < y)
  #     bottom_distance = y - @y_pos
  #     top_distance =  @scene.height - y + y_pos
  #   else
  #     bottom_distance = @scene.height - @y_pos + y
  #     top_distance = @y_pos - y
  #   end

  #   if (bottom_distance < top_distance)
  #     self.accelerate(0, magnitude)
  #   else
  #     self.accelerate(0, -magnitude)
  #   end
  # end

  def _ai
    @time_alive += @scene.update_interval
    if (@time_alive - @last_ai_update > @ai_interval)
      self.accelerate(Gosu::random(-@max_acceleration, @max_acceleration),
                      Gosu::random(-@max_acceleration, @max_acceleration))
      @last_ai_update = @time_alive
    end
  end

  def update
    self._ai

    #Spinnnn!
    @shape.body.a += @spin_rate

    #Wrap around the field
    @shape.body.p.x = @shape.body.p.x % @scene.width
    @shape.body.p.y = @shape.body.p.y % @scene.height

    # #Update children
    # @mini_mes.map! {|o|
    #   o.accelerate_towards(@x_pos, @y_pos, 20)
    #   @mini_mes.each {|oo|
    #     next if oo == o
    #     next unless Gosu::distance(o.x_pos, o.y_pos, oo.x_pos, oo.y_pos) < o.image.width * o.scale * 2
    #     o.accelerate_towards(oo.x_pos, oo.y_pos, -@max_acceleration)
    #   }
    #   o.update
    # }
    # @mini_mes.flatten!
    # @mini_mes.compact!

    self
  end

  def draw
    #Draw main

    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, @z_index, @shape.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)

    #Draw wrap-around
    if (@shape.body.p.x < @image.width / 2)
      @image.draw_rot(@scene.width + @shape.body.p.x, @shape.body.p.y, @z_index, @shape.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    elsif (@shape.body.p.x > @scene.width + @image.width / 2)
      @image.draw_rot(@shape.body.p.x - @scene.width, @shape.body.p.y, @z_index, @shape.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    elsif (@shape.body.p.y < @image.height / 2)
      @image.draw_rot(@shape.body.p.x, @scene.height + @shape.body.p.y, @z_index, @shape.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    elsif (@shape.body.p.y > @scene.height + @image.height / 2)
      @image.draw_rot(@shape.body.p.x, @shape.body.p.y - @scene.height, @z_index, @shape.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    end

    # #Draw children
    # @mini_mes.each {|o| o.draw}

    self
  end
end
