class Posiciones < ActiveRecord::Base
  attr_accessible :fecha, :listado
  default_scope -> { order('created_at DESC') }

  def obtener_listado

    # doc = Nokogiri::XML(listado)
    # @registros_a_mostrar = valores_will_paginate[:per_page].to_i + 1
    # @pagina_actual = valores_will_paginate[:page].to_i

    # @limite_superior = @registros_a_mostrar * @pagina_actual
    # @limite_inferior = @limite_superior - @registros_a_mostrar
    # table = doc.xpath("//Table")[@limite_inferior..@limite_superior]
    ActiveSupport::XmlMini.backend = 'Nokogiri'
    @pos = Hash.from_xml(listado).with_indifferent_access
    if registros?
      @pos[:Envelope][:Body][:GetReportResponse][:GetReportResult][:diffgram][:NewDataSet][:Table]
      #noko.search(product_node).each do |node|
      # ...
      #end
      # @pos = []
      # table.each { |t|
      #   @fruta = {}
      #   t.elements.each { |e| @fruta["#{e.name}".to_sym] = "#{e.text}" }
      #   @pos << @fruta
      #   }
      # @pos
    else
      []
    end
  end

  def obtener_nombre_de_buques
    ActiveSupport::XmlMini.backend = 'Nokogiri'
    doc = Nokogiri::XML(listado)
    doc.search('//IDEN').map {|n| n.text.strip }.uniq.sort
  end

  def obtener_listado_por_buque(buque)
    ActiveSupport::XmlMini.backend = 'Nokogiri'
    doc = Nokogiri::XML(listado)
    doc.search('Table').each { |nodo|
      nodo.remove unless nodo.search('IDEN').text.strip == buque.strip
    }
    @pos = Hash.from_xml(doc.to_xml).with_indifferent_access
    @posiciones = @pos[:Envelope][:Body][:GetReportResponse][:GetReportResult][:diffgram][:NewDataSet][:Table]
    @coleccion = []
    @posiciones.kind_of?(Array) ? @posiciones : @coleccion << @posiciones
  end

  private

  def registros?
    # @pos[:Envelope][:Body][:GetReportResponse][:GetReportResult][:diffgram].key?(:NewDataSet)
    @pos[:Envelope][:Body][:GetReportResponse][:GetReportResult][:diffgram].present?
  end
end
