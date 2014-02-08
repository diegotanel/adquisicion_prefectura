require 'spec_helper'

describe Posiciones do
  it "retornar un OpenStruct con los valores del XML" do
    #@xml = "<list><item>Washington D.C.</item></list>"
    xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado = @posiciones.obtener_listado
    @listado[0].PT_INFO.should eq("DIAM")
  end

  describe "registros?" do
    it "si no hay registros, debe retornar un false" do
      xml = File.read(Rails.root.join("spec/support/posiciones_sin_registros.xml"))
      @posiciones = Factory(:posiciones, :listado => xml)
      @posiciones.registros?.should be_false
    end

    it "si hay registros, debe retornar true" do
      xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
      @posiciones = Factory(:posiciones, :listado => xml)
      @posiciones.registros?.should be_true
    end
  end
end
