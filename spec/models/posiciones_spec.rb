require 'spec_helper'

describe Posiciones do
  it "retornar un OpenStruct con los valores del XML" do
    @xml = "<list><item>Washington D.C.</item></list>"
    @posiciones = Factory(:posiciones, :listado => @xml)
    @listado = @posiciones.obtener_listado
    @listado.list.item.should eq("Washington D.C.")
  end
end
