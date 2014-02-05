class VisualizarService

  def initialize(xml)
    @xml = xml
  end

  def obtener_listado
    Hash.from_xml(@xml).to_ostruct_recursive
  end


end
