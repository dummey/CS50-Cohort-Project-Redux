module ChipmunkObject
  def setup_chipmunk
    @body = CP::Body.new(@mass, @moment_of_inertia)
    @body.p.x = @init_x_pos
    @body.p.y = @init_y_pos

    @body.a = @init_rotate.gosu_to_radians if @init_rotate
    @body.v_limit = @max_velocity if @max_velocity
    @body.object = self


    @shape = CP::Shape::Circle.new(@body, image.width / 2 * @scale, CP::Vec2::ZERO)
    @shape.e = 0.5
    @shape.collision_type = @collision_type
    @shape.sensor = @collision_sensor
    #object is a place to store refs to be accessable at collisions
    @shape.object = self
    @shape.layers = @bit_plane    
  end

  def body
    @body
  end

  def shape
    @shape
  end

  def shapes
    return [@shape]
  end
  def bodies
    return [@body]
  end

  def intersect?(x, y)
    if (x < (@body.p.x - image.width / 2))
      return false
    elsif (x > (@body.p.x + image.width / 2))
      return false
    end

    if (y < (@body.p.y - image.height / 2))
      return false
    elsif (y > (@body.p.y + image.height / 2))
      return false
    end

    return true
  end
end