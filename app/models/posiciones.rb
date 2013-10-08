class Posiciones < ActiveRecord::Base
  attr_accessible :fecha, :listado
  default_scope -> { order('created_at DESC') }
end
