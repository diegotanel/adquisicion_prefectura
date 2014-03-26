#encoding: utf-8

require 'spec_helper'

describe Posiciones do
  it "retornar los valores del XML" do
    #@xml = "<list><item>Washington D.C.</item></list>"
    xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado = @posiciones.obtener_listado
    @listado[0][:PT_INFO].should eq("DIAM")
    @listado[0][:IDEN].should eq("DON KASBERGEN")
    @listado[1][:IDEN].should eq("GONZA")
  end

  it "si no hay registros debe retornar un array vacio" do
    xml = File.read(Rails.root.join("spec/support/posiciones_sin_registros.xml"))
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado = @posiciones.obtener_listado
    @listado.should == []
  end

  it "obtener los nombres de todos los buques" do
    xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado_de_buques = @posiciones.obtener_nombre_de_buques
    @listado_de_buques.should include("DON KASBERGEN")
    @listado_de_buques.should include("GONZA")
  end

  it "obtener los nombres de todos los buques sin que se repitan" do
    xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado_de_buques = @posiciones.obtener_nombre_de_buques
    @listado_de_buques.should include("DON KASBERGEN")
    @listado_de_buques.should include("GONZA")
    @listado_de_buques.should include("ADOLFO")
    @listado_de_buques.should include("DIEGO")
    @listado_de_buques.size.should == 4
  end

  it "obtener los nombres de los buques alfabéticamente" do
    xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado_de_buques = @posiciones.obtener_nombre_de_buques
    @listado_de_buques[0].should eq("ADOLFO")
    @listado_de_buques[1].should eq("DIEGO")
    @listado_de_buques[2].should eq("DON KASBERGEN")
    @listado_de_buques[3].should eq("GONZA")
    @listado_de_buques.size.should == 4
  end

  it "obtener los resgistros de un buque especifico" do
    xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado_filtrado = @posiciones.obtener_listado_por_buque("DON KASBERGEN")
    @listado_filtrado[0][:PT_INFO].should eq("DIAM")
    @listado_filtrado[0][:IDEN].should eq("DON KASBERGEN")
    @listado_filtrado[1][:IDEN].should_not eq("GONZA")
    @listado_filtrado[1][:IDEN].should eq("DON KASBERGEN")
    @posiciones = Factory(:posiciones, :listado => xml)
    @listado_filtrado = @posiciones.obtener_listado_por_buque("  DIEGO")
    @listado_filtrado[0][:PT_INFO].should eq("DIAM")
    @listado_filtrado[0][:IDEN].should eq("  DIEGO")
  end

  # describe "registros?" do
  #   it "si no hay registros, debe retornar un false" do
  #     xml = File.read(Rails.root.join("spec/support/posiciones_sin_registros.xml"))
  #     @posiciones = Factory(:posiciones, :listado => xml)
  #     @posiciones.registros?.should be_false
  #   end

  #   it "si hay registros, debe retornar true" do
  #     xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
  #     @posiciones = Factory(:posiciones, :listado => xml)
  #     @posiciones.registros?.should be_true
  #   end
  # end
end
