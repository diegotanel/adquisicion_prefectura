class PosicionesProxyController < ApplicationController

  def index
    @consultar = ConsultaPrefectura.new(params).obtener_registros
    render xml: @consultar
  end

end
