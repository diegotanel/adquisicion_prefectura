require 'spec_helper'

describe "Posiciones" do
  describe "GET /posiciones" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get posiciones_index_path
      response.status.should be(200)
    end

    it "obtener el listado de posiciones desde prefectura" do
      VCR.use_cassette "prefectura" do
        @fecha = '15-09-13'
        @reportName = 'Hidrovia_PZRP'
        get '/posiciones/index.xml', params = { :fecha => @fecha, :reportName => @reportName }
        # response.should have_selector("FH_INFO")
        response.status.should be(200)
      end
    end

    it "obtener el listado de posiciones almacenado" do

    end

  end
end
