module EdgeCollision
  module EdgeCollisionHandler
    def self.begin(a, b)
      if a.object
        a.object.display_ghost(b.collision_type, true)
      end
    end

    def self.separate(a, b)
      if a.object
        a.object.display_ghost(b.collision_type, false)
      end
    end
  end

  def self.create_universe_boundary(width, height, space, collision_types)
    edge = CP::Body.new_static()
    up_left = vec2(0, 0)
    up_right = vec2(width, 0)
    down_left = vec2(0, height)
    down_right = vec2(width, height)
    boundaries = {
      left_edge: CP::Shape::Segment.new(edge, up_left, down_left, 1),
      right_edge: CP::Shape::Segment.new(edge, up_right, down_right, 1),
      top_edge: CP::Shape::Segment.new(edge, up_left, up_right, 1),
      bottom_edge: CP::Shape::Segment.new(edge, down_left, down_right, 1)
    }
    boundaries.each_value {|value| value.sensor = true}
    boundaries.each {|key, value| value.collision_type = key }
    boundaries.each_value {|value| space.add_shape(value)}

    collision_types.each {|collision_type|
      boundaries.each_key {|key| space.add_collision_handler(collision_type, key, EdgeCollisionHandler)}
    }
  end
end