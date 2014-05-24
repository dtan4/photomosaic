require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'photomosaic'

def fixture_path(name)
  File.expand_path(File.join("..", "fixtures", name), __FILE__)
end

def tmp_dir
  File.expand_path("../tmp", File.dirname(__FILE__))
end

def tmp_path(name)
  File.join(tmp_dir, name)
end
