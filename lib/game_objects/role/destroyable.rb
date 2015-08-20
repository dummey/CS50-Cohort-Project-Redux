module Destroyable
  def destroy(space)
    space.add_post_step_callback(self.object_id.to_s.to_sym) do |space, key|
      space.remove_shape(self.shape)
      space.remove_body(self.body)
    end

    @destroyed = true
  end

  def destroyed?
    @destroyed
  end
end