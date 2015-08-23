module HasGameObjects
  def add_game_object(obj)
    @game_objects ||= []
    @game_objects << obj
  end

  def update_game_objects
    return unless @game_objects
    @game_objects.map! {|o| o.update}
    @game_objects.flatten!
    @game_objects.compact!
  end

  def draw_game_objects
    return unless @game_objects
    @game_objects.each {|o| o.draw}
  end

  def button_down_game_objects(id)
    return unless @game_objects
    @game_objects.each {|o| o.button_down(id)}
  end

  def button_up_game_objects(id)
    return unless @game_objects
    @game_objects.each {|o| o.button_up(id)}
  end

  def game_objects
    @game_objects
  end
end