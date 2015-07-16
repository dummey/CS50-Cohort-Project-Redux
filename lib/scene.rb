class Scene
  def initialize(window)
    @window = window
  end

  def width 
    @window.width
  end

  def height
    @window.height
  end

  def update
    raise NotImplementedError
  end

  def draw
    raise NotImplementedError
  end
end