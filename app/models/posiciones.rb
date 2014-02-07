class Posiciones < ActiveRecord::Base
  attr_accessible :fecha, :listado
  default_scope -> { order('created_at DESC') }

  def obtener_listado
    Hash.from_xml(listado).to_ostruct_recursive
  end
end
