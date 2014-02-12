class PosicionesController < ApplicationController

  def index
    @posiciones = []
    Posiciones.select("id,fecha,created_at").find_each(:batch_size => 500) {|p| @posiciones << p }
  end

  def create
    params[:fecha] = Time.zone.now.strftime("%d-%m-%y")
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

  def visualizar
    @posiciones = Posiciones.find(params[:id])
    @listado = @posiciones.obtener_listado.paginate(:page => params[:page], :per_page => 300)
  end

end
