class Scene
  attr_accessor :updatable, :drawable

  def initialize(window)
    @window = window
    @updatable = []
    @drawable = []
  end

  def width
    @window.width
  end

  def height
    @window.height
  end

  def update
    @updatable.each {|o| o.update}
  end

  def draw
    @drawable.each {|o| o.draw}
  end

  def button_down(id)

  end

  def button_up(id)

  end
end
