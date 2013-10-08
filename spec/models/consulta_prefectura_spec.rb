#encoding: utf-8

require 'spec_helper'

describe ConsultaPrefectura do
  before do
    @fecha = '15-09-13'
    @reportName = 'Hidrovia_PZRP'
    @params = { :fecha => @fecha, :reportName => @reportName }
    @consulta = ConsultaPrefectura.new(@params)
  end

  describe "debe aceptar los parámetros" do
    it "fecha" do
      @consulta.fecha.should == @fecha
    end

    it "resportName" do
      @consulta.reportName.should == @reportName
    end
  end

  describe "flujos por excepciones" do
    before do
      @config = YAML.load_file(Rails.root + 'config/conexion_ws.yml')
      @posiciones = Factory(:posiciones, :fecha => @fecha)
    end

    it "por time-out" do
      stub_request(:any, @config["configuraciones"]["urlws"]).to_timeout
      @consulta.obtener_registros.should == @posiciones.listado
    end

    it "por error en el servicio" do
      stub_request(:any, @config["configuraciones"]["urlws"]).to_raise(Savon::Error)
      @consulta.obtener_registros.should == @posiciones.listado
    end
  end

end
