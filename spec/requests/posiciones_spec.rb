#encoding: utf-8

require 'spec_helper'

describe "Posiciones" do
  describe "GET /posiciones" do
    it "obtener el listado de posiciones desde prefectura" do
      VCR.use_cassette "prefectura_15-09-13" do
        @fecha = '15-09-13'
        @reportName = 'Hidrovia_PZRP'
        get '/posiciones/index.xml', params = { :fecha => @fecha, :reportName => @reportName }
        response.status.should be(200)
        response.should contain("15/09/2013")
      end
    end

    it "obtener el listado de posiciones almacenado" do
      config = YAML.load_file(Rails.root + 'config/conexion_ws.yml')
      stub_request(:any, config["configuraciones"]["urlws"]).to_timeout
      @fecha = '17-09-13'
      @reportName = 'Hidrovia_PZRP'
      @posiciones = Factory(:posiciones)
      get '/posiciones/index.xml', params = { :fecha => @fecha, :reportName => @reportName }
      response.status.should be(200)
      response.should contain(@posiciones.listado)
    end

    it "obtener el listado de posiciones almacenado durante distintos días" do
      config = YAML.load_file(Rails.root + 'config/conexion_ws.yml')
      stub_request(:any, config["configuraciones"]["urlws"]).to_timeout
      @fecha = '15-09-13'
      @reportName = 'Hidrovia_PZRP'
      Factory(:posiciones)
      @posiciones = Factory(:posiciones, :fecha => @fecha, :listado => "14/09/2013")
      get '/posiciones/index.xml', params = { :fecha => @fecha, :reportName => @reportName }
      response.status.should be(200)
      response.should contain(@posiciones.listado)
    end

    it "obtener el listado de posiciones almacenado el mismo día y distinta horas" do
      config = YAML.load_file(Rails.root + 'config/conexion_ws.yml')
      stub_request(:any, config["configuraciones"]["urlws"]).to_timeout
      @fecha = '17-09-13'
      @reportName = 'Hidrovia_PZRP'
      Factory(:posiciones, :fecha => @fecha, :listado => "listado1", :created_at => 3.hour.ago)
      Factory(:posiciones, :fecha => @fecha, :listado => "listado2", :created_at => 2.hour.ago)
      Factory(:posiciones, :fecha => @fecha, :listado => "listado3", :created_at => 1.hour.ago)
      get '/posiciones/index.xml', params = { :fecha => @fecha, :reportName => @reportName }
      response.status.should be(200)
      response.should contain("listado3")
    end
  end

  describe "almacenar posiciones" do
    it "guardar" do
      VCR.use_cassette "prefectura_15-09-13" do
        DateTime.stub!(:now).and_return(DateTime.new(2013, 9, 15))
        @fecha = '15-09-13'
        @reportName = 'Hidrovia_PZRP'
        post '/posiciones/create', params = { :fecha => @fecha, :reportName => @reportName }
        @pos = Posiciones.first
        @pos.fecha.should eq("15-09-13")
        @pos.listado.should contain("15/09/2013")
      end
    end

  end
end
