#encoding: utf-8

require 'spec_helper'

describe "PosicionesProxy" do

  def get(fecha, reportName)
    page.driver.get posiciones_proxy_index_path, params = { :fecha => fecha, :reportName => reportName }
  end

  describe "GET /posiciones_proxy" do
    it "debe responder a la ruta" do
      VCR.use_cassette "prefectura_15-09-13" do
        fecha = '15-09-13'
        reportName = 'Hidrovia_PZRP'
        Factory(:posiciones, :fecha => fecha, :listado => "14/09/2013")
        get(fecha, reportName)
        expect(page.status_code).to be(200)
        expect(page.body).to have_content("14/09/2013")
      end
    end
  end

  describe "posiciones almacenadas" do
    context "obtener el reporte" do
      before do
        config = YAML.load_file(Rails.root + 'config/conexion_ws.yml')
        stub_request(:any, config["configuraciones"]["urlws"]).to_timeout
      end

      it "de posiciones almacenado" do
        fecha = '15-09-13'
        reportName = 'Hidrovia_PZRP'
        @posiciones = Factory(:posiciones)
        get(fecha, reportName)
        expect(page.status_code).to be(200)
        expect(page.body).to have_content(@posiciones.listado)
      end

      it "de una posición específica, si bien hay reportes de distintos días" do
        Factory(:posiciones)
        fecha = '17-09-13'
        reportName = 'Hidrovia_PZRP'
        @posiciones = Factory(:posiciones, :fecha => fecha, :listado => "14/09/2013")
        get(fecha, reportName)
        expect(page.status_code).to be(200)
        expect(page.body).to have_content(@posiciones.listado)
      end

      it "de posiciones específica, el mismo día y distinta horas" do
        Timecop.freeze(DateTime.new(2013,9,15,15,00))
        fecha = '15-09-13'
        reportName = 'Hidrovia_PZRP'
        @pos1 = Factory(:posiciones, :fecha => fecha, :listado => "listado1", :created_at => 3.hour.ago)
        @pos2 = Factory(:posiciones, :fecha => fecha, :listado => "listado2", :created_at => 2.hour.ago)
        @pos3 = Factory(:posiciones, :fecha => fecha, :listado => "listado3", :created_at => 1.hour.ago)
        get(fecha, reportName)
        expect(page.status_code).to be(200)
        expect(page.body).to_not have_content('listado1')
        expect(page.body).to_not have_content('listado2')
        expect(page.body).to have_content('listado3')
      end
    end
  end

end
