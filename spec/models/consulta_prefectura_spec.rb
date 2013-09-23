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

  it "obtener los datos del ws de prefectura" do
    VCR.use_cassette "prefectura" do
      @consulta.obtener_registros.should match("FH_INFO")
    end
  end

end
