module ChipmunkObject

  def setup_chipmunk
    body = CP::Body.new(@mass, @moment_of_inertia)
    body.p.x = @init_x_pos
    body.p.y = @init_y_pos

    body.v_limit = @max_velocity if @max_velocity


    @shape = CP::Shape::Circle.new(body, image.width / 2 * @scale, CP::Vec2::ZERO)
    @shape.e = 0.5
    @shape.collision_type = @collision_type
    @shape.sensor = @collision_sensor
  end

  def body
    @shape.body
  end

end