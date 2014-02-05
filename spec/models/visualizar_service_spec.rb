#encoding: utf-8

require 'spec_helper'

describe VisualizarService do
  it "retornar un OpenStruct con los valores del XML" do
    @xml = "<list><item>Washington D.C.</item></list>"
    @listado = VisualizarService.new(@xml).obtener_listado
    @listado.list.item.should eq("Washington D.C.")
  end
end
