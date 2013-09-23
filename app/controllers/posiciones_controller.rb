class PosicionesController < ApplicationController
  def index
  	@consultar = ConsultaPrefectura.new(params).obtener_registros
    respond_to do |format|
      # format.html # index.html.erb
      format.xml  { render xml: @consultar}
      # format.json { render json: @users}
    end
  end
end
