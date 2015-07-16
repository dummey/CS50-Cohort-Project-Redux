$MEDIA_ROOT = File.dirname(__FILE__) + '/../media'

$CONFIG = {
  window_size_x: 1024,
  window_size_y: 768,
  window_full_screen: false,

  initialize_lives: 3,
  initialize_score: 0,

  sprite_star: ['star1.png', 'star2.png', 'star3.png'].map{|f| "#{$MEDIA_ROOT}/PNG/Effects/#{f}"}
}