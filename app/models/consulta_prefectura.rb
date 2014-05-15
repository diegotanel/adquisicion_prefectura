class ConsultaPrefectura
  attr_reader :fecha, :reportName

  def initialize(params)
    @fecha = params[:fecha]
    @reportName = params[:reportName]
  end

  def obtener_registros
    begin
      config = YAML.load_file(Rails.root + 'config/conexion_ws.yml')
      client = Savon::Client.new(config["configuraciones"]["urlws"])
      client.http.read_timeout = config["configuraciones"]["http.read_timeout"]
      client.http.open_timeout = config["configuraciones"]["http.open_timeout"]
      response = client.request :get_report do |soap|
        soap.body = {"report_name" => @reportName, "report_params" => {"ReportParam" => {"nombre" => "fecha", "valor" => @fecha, :attributes! => { "ins0:valor" => { "xsi:type" => "xsd:string"} } } } }
      end
      response.to_xml
    rescue Savon::Error => error
      # log error.to_s
      obtener_posiciones_almacenada
    rescue Timeout::Error => error
      obtener_posiciones_almacenada
    end
  end

  # private

  def obtener_posiciones_almacenada
    Posiciones.find_by_fecha(@fecha).listado
  end

end
