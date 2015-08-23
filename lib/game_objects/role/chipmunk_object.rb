module ChipmunkObject

  def setup_chipmunk
    body = CP::Body.new(@mass, @moment_of_inertia)
    body.p.x = @init_x_pos
    body.p.y = @init_y_pos
    
    body.a = @init_rotate.gosu_to_radians if @init_rotate
    body.v_limit = @max_velocity if @max_velocity
    body.object = self


    @shape = CP::Shape::Circle.new(body, image.width / 2 * @scale, CP::Vec2::ZERO)
    @shape.e = 0.5
    @shape.collision_type = @collision_type
    @shape.sensor = @collision_sensor
    #object is a place to store refs to be accessable at collisions
    @shape.object = self
  end

  def body
    @shape.body
  end

  def shape
    @shape
  end

end