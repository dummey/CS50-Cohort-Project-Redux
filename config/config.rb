$MEDIA_ROOT = File.dirname(__FILE__) + '/../media'

$CONFIG = {
  window_size_x: 1024,
  window_size_y: 768,
  window_full_screen: false,

  initialize_lives: 3,
  initialize_score: 0,

  game_background_drift: {x: 10, y: 0},

  sprite_star: ['star1.png', 'star2.png', 'star3.png'].map{|f| "#{$MEDIA_ROOT}/PNG/Effects/#{f}"},
  sprite_ufo: ['ufoGreen.png', 'ufoBlue.png', 'ufoRed.png', 'ufoYellow.png'].map{|f| "#{$MEDIA_ROOT}/PNG/#{f}"},
}