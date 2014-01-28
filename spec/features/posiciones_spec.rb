#encoding: utf-8

require 'spec_helper'

describe "Posiciones" do

  def get(fecha, reportName)
    page.driver.get posiciones_proxy_index_path, params = { :fecha => fecha, :reportName => reportName }
  end

  describe "lista de posiciones" do
    it "mostrar la lista de posiciones" do
      @posiciones1 = Factory(:posiciones)
      @posiciones2 = Factory(:posiciones, :fecha => '17-09-13', :listado => "14/09/2013")
      visit posiciones_index_path
      expect(page.status_code).to be(200)
      expect(page.body).to have_content(@posiciones1.fecha)
      expect(page.body).to have_content(@posiciones2.fecha)
    end

    it "mostrar los elementos correspondientes" do
      @posiciones = Factory(:posiciones, :created_at => DateTime.new(2013, 9, 15, 22, 41))
      visit posiciones_index_path
      expect(page.body).to have_content("15/09/2013 19:41")
      expect(page.body).to have_link("descargar_#{@posiciones.id}", :href => descargar_posiciones_path(@posiciones) ,:text => "Descargar")
    end

    it "descargar el reporte" do
      @posiciones1 = Factory(:posiciones, :created_at => DateTime.new(2013, 9, 15, 22, 41))
      @posiciones2 = Factory(:posiciones)
      visit posiciones_index_path
      click_link "descargar_#{@posiciones1.id}"
      result = page.response_headers['Content-Type'].should == "application/xml"
      if result
        nombre_del_archivo = "attachment; filename=\"posiciones.xml\""
        result = page.response_headers['Content-Disposition'].should == nombre_del_archivo
      end
    end

    it "verificar el resultado del reporte" do
      @posiciones = Factory(:posiciones, :fecha => '17-09-13', :listado => "14/09/2013")
      visit posiciones_index_path
      click_link "descargar_#{@posiciones.id}"
      expect(page.body).to have_content(@posiciones.listado)
    end

    it "seleccionar los registros" do
      @posiciones1 = Factory(:posiciones)
      @posiciones2 = Factory(:posiciones, :fecha => '17-09-13', :listado => "14/09/2013")
      visit posiciones_index_path
      check "posiciones_#{@posiciones2.id}"
      regsitro1 = find("#posiciones_#{@posiciones1.id}")
      regsitro1.should_not be_checked
      regsitro2 = find("#posiciones_#{@posiciones2.id}")
      regsitro2.should be_checked
    end

    it "debe eliminar los registros seleccionados" do
      @posiciones1 = Factory(:posiciones)
      @posiciones2 = Factory(:posiciones, :fecha => '17-09-13', :listado => "14/09/2013")
      @posiciones3 = Factory(:posiciones, :fecha => '19-09-13', :listado => "16/09/2013")
      visit posiciones_index_path
      expect(page.body).to have_content(@posiciones1.fecha)
      expect(page.body).to have_content(@posiciones2.fecha)
      expect(page.body).to have_content(@posiciones3.fecha)
      check "posiciones_#{@posiciones1.id}"
      check "posiciones_#{@posiciones3.id}"
      click_button "Eliminar registros"
      expect(page.body).to_not have_content(@posiciones1.fecha)
      expect(page.body).to have_content(@posiciones2.fecha)
      expect(page.body).to_not have_content(@posiciones3.fecha)
    end

    it "seleccionar todos los registros", :js => :true do
      @posiciones1 = Factory(:posiciones)
      @posiciones2 = Factory(:posiciones, :fecha => '17-09-13', :listado => "14/09/2013")
      @posiciones3 = Factory(:posiciones, :fecha => '19-09-13', :listado => "16/09/2013")
      visit posiciones_index_path
      find("#posiciones_#{@posiciones1.id}").should_not be_checked
      find("#posiciones_#{@posiciones2.id}").should_not be_checked
      find("#posiciones_#{@posiciones3.id}").should_not be_checked
      click_button "Seleccionar todos"
      find("#posiciones_#{@posiciones1.id}").should be_checked
      find("#posiciones_#{@posiciones2.id}").should be_checked
      find("#posiciones_#{@posiciones3.id}").should be_checked
    end

    it "deseleccionar todos los registros", :js => :true do
      @posiciones1 = Factory(:posiciones)
      @posiciones2 = Factory(:posiciones, :fecha => '17-09-13', :listado => "14/09/2013")
      @posiciones3 = Factory(:posiciones, :fecha => '19-09-13', :listado => "16/09/2013")
      visit posiciones_index_path
      find("#posiciones_#{@posiciones1.id}").should_not be_checked
      find("#posiciones_#{@posiciones2.id}").should_not be_checked
      find("#posiciones_#{@posiciones3.id}").should_not be_checked
      click_button "Seleccionar todos"
      find("#posiciones_#{@posiciones1.id}").should be_checked
      find("#posiciones_#{@posiciones2.id}").should be_checked
      find("#posiciones_#{@posiciones3.id}").should be_checked
      click_button "Deseleccionar todos"
      find("#posiciones_#{@posiciones1.id}").should_not be_checked
      find("#posiciones_#{@posiciones2.id}").should_not be_checked
      find("#posiciones_#{@posiciones3.id}").should_not be_checked
    end
  end


  describe "almacenar posiciones" do
    it "guardar" do
      VCR.use_cassette "prefectura_15-09-13", :allow_playback_repeats => true do
        DateTime.stub!(:now).and_return(DateTime.new(2013, 9, 15))
        @fecha = '15-09-13'
        @reportName = 'Hidrovia_PZRP'
        page.driver.post '/posiciones/create', params = { :fecha => @fecha, :reportName => @reportName }
        get(@fecha, @reportName)
        expect(page.body).to have_content("15/09/2013")
        # @pos = Posiciones.first
        # expect(@pos.fecha).to eq("15-09-13")
        # expect(@pos.listado).to have_content("15/09/2013")
      end
    end

  end
end
