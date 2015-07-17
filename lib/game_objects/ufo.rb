require 'game_object'

class UFO < GameObject
  def _defaults(params)
    {
      :image_path => $CONFIG[:sprite_ufo].sample,
      :x_pos => rand(0...@scene.width),
      :y_pos => rand(0...@scene.height),
      :x_vel => 0.0,
      :y_vel => 0.0,
      :x_acc => 0.0,
      :y_acc => 0.0,
      :dampening => 0.5,
      # :level => 1,
      :scale => 0.5,
      :ai_interval => 1000,
      :angle => 0,
      :z_index => 5, #$CONIFG[:z_index_ufo]
      :max_velocity => 50.0,
      :max_acceleration => 50.0,
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    #scale ship
    @image = Gosu::Image.new(@image_path)

    @time_alive = 0
    @last_ai_update = -1 * Float::INFINITY

  end

  def accelerate(x, y)
    @x_acc += x
    @x_acc = [-1 * @max_acceleration, @x_acc, @max_acceleration].sort[1]

    @y_acc += y
    @y_acc = [-1 * @max_acceleration, @y_acc, @max_acceleration].sort[1]
  end

  def _ai
    self.accelerate(Gosu::random(-@max_acceleration, @max_acceleration), 
      Gosu::random(-@max_acceleration, @max_acceleration))
  end

  def update
    #Figure out when to call the AI code 
    @time_alive += @scene.update_interval
    if (@time_alive - @last_ai_update > @ai_interval)
      self._ai 
      @last_ai_update = @time_alive
    end

    #Dampening
    @x_vel *= 1 - @dampening * @scene.update_interval / 1000.0
    @y_vel *= 1 - @dampening * @scene.update_interval / 1000.0

    #Apply acceleration to velocity
    @x_vel += @x_acc * @scene.update_interval / 1000.0
    @y_vel += @y_acc * @scene.update_interval / 1000.0

    #Apply velocity to position
    @x_pos += @x_vel * @scene.update_interval / 1000.0
    @y_pos += @y_vel * @scene.update_interval / 1000.0

    #Wrap around the field
    @x_pos = @x_pos % @scene.width
    @y_pos = @y_pos % @scene.height

    self
  end

  def draw
    #Draw main
    @image.draw_rot(@x_pos, @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    
    #Draw wrap-around 
    if (@x_pos < @image.width / 2)
      @image.draw_rot(@scene.width + @x_pos, @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    elsif (@x_pos > @scene.width + @image.width / 2)
      @image.draw_rot(@x_pos - @scene.width, @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    elsif (@y_pos < @image.height / 2)
      @image.draw_rot(@x_pos, @scene.height + @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    elsif (@y_pos > @scene.height + @image.height / 2)
      @image.draw_rot(@x_pos, @y_pos - @scene.height, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    end

    self
  end
end
