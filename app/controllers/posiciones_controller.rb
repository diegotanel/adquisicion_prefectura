class PosicionesController < ApplicationController

  def index
    @posiciones = Posiciones.all
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

  def descargar
    @posiciones = Posiciones.find(params[:id])
    send_data @posiciones.listado, :filename => 'posiciones.xml', :type=>"application/xml", :disposition => 'attachment'
  end

  def eliminar_multiple
    Posiciones.delete_all(:id => params[:posiciones_ids])
    redirect_to posiciones_index_path
  end

end
