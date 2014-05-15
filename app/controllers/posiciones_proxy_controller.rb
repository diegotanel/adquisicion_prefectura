class PosicionesProxyController < ApplicationController

  def index
    #@consultar = ConsultaPrefectura.new(params).obtener_registros
    @consultar = ConsultaPrefectura.new(params).obtener_posiciones_almacenada
    render xml: @consultar
  end

end
