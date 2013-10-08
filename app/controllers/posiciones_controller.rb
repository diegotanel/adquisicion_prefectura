class PosicionesController < ApplicationController
  def index
    @consultar = ConsultaPrefectura.new(params).obtener_registros
    respond_to do |format|
      # format.html # index.html.erb
      format.xml  { render xml: @consultar}
      # format.json { render json: @users}
    end
  end

  def create
    params[:fecha] = DateTime.now.strftime("%d-%m-%y")
    @consultar = ConsultaPrefectura.new(params).obtener_registros
    @pos = Posiciones.create(:fecha => params[:fecha], :listado => @consultar)
    respond_to do |format|
      # format.html # index.html.erb
      # format.xml  { render xml: @pos}
      # format.json { render json: @pos }
    end
  end
end
