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
      expect(page.body).to have_link("visualizar_#{@posiciones.id}", :href => visualizar_posiciones_path(@posiciones) ,:text => "Visualizar")
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
        # DateTime.stub!(:now).and_return(DateTime.new(2013, 9, 15))
        Timecop.freeze(Time.zone.local(2013,9,15,0,0))
        @fecha = '15-09-13'
        @reportName = 'Hidrovia_PZRP'
        page.driver.post '/posiciones/create', params = { :fecha => @fecha, :reportName => @reportName }
        visit posiciones_index_path
        expect(page.body).to have_content("15/09/2013")
        expect(page.body).to have_content(@fecha)
        # @pos = Posiciones.first
        # expect(@pos.fecha).to eq("15-09-13")
        # expect(@pos.listado).to have_content("15/09/2013")
      end
    end
  end

  describe "visualización de posiciones" do
    it "verificar que esten todas las columnas" do
      VCR.use_cassette "prefectura_15-09-13" do
        @encabezados = ["Orden", "FH_INFO", "HS_INFO", "PT_INFO", "MATRICULA", "SDIST", "NRO_OMI", "IDEN", "PT_ORIG", "PT_DESTINO", "TIPO_MOV", "PT_FINAL", "EN_VIAJE", "NOMBRE", "UNIDAD", "KM", "CARGA", "OBSERVAC", "BAND", "ARQUEO_NETO", "CALADO_MAX", "CALADOR", "SERN", "TIPO_EVENTO", "COMENTARIO", "ID_VIAJE", "ID_ETAPA", "NRO_ETAPA", "ID_EVENTO", "REMOLCADA_POR", "ORIGEN", "DESTINO"]
        @fecha = '15-09-13'
        @reportName = 'Hidrovia_PZRP'
        page.driver.post '/posiciones/create', params = { :fecha => @fecha, :reportName => @reportName }
        visit posiciones_index_path
        click_link "Visualizar"
        @encabezados.map {|e|
          expect(page.body).to have_content(e)
        }
      end
    end

    it "debe mostrar los valores en las columans" do
      VCR.use_cassette "prefectura_15-09-13" do
        @valores = ["0", "15/09/2013", "00:01:00", "PZRP", "01660", "LW2558", "EL COCO", "B50", "BAI", "BAI", "1", "Rio de la Plata", "PTO BSAS", "0", "ARGENTINA", "643", "4", "2.3", "PZRP", "Pase de Barco a Zona", "262026", "906091", "11", "3841593", "-", "KM 266 MI R PARANA", "BUENOS AIRES"]
        @fecha = '15-09-13'
        @reportName = 'Hidrovia_PZRP'
        page.driver.post '/posiciones/create', params = { :fecha => @fecha, :reportName => @reportName }
        visit posiciones_index_path
        click_link "Visualizar"
        @valores.map {|e|
          expect(page.body).to have_content(e)
        }
      end
    end

    it "debe mostrar un mensaje indicando que no hay registros" do
      xml = File.read(Rails.root.join("spec/support/posiciones_sin_registros.xml"))
      @posiciones = Factory(:posiciones, :listado => xml)
      visit posiciones_index_path
      click_link "Visualizar"
      expect(page.body).to have_content("No hay registros para mostrar")
    end

    describe "paginación" do
      it "el reporte de posiciones debe tener la paginación" do
        VCR.use_cassette "prefectura_15-09-13" do
          #   xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
          #   @posiciones = Factory(:posiciones, :listado => xml)
          fecha = '15-09-13'
          reportName = 'Hidrovia_PZRP'
          page.driver.post '/posiciones/create', params = { :fecha => fecha, :reportName => reportName }
          #visit visualizar_posiciones_path(@posiciones.id)
          visit posiciones_index_path
          click_link "Visualizar"
          expect(page.body).to have_selector('div.pagination')
        end
      end
    end

    describe "filtro" do
      it "debe mostrar los nombres de los buques", :js => true do
        xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
        @posiciones = Factory(:posiciones, :listado => xml)
        visit visualizar_posiciones_path(@posiciones)
        click_link "Buscar por buque"
        select "DON KASBERGEN"
      end

      it "debe filtar el listado por el buque seleccionado", :js => true do
        xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
        @posiciones = Factory(:posiciones, :listado => xml)
        visit visualizar_posiciones_path(@posiciones)
        click_link "Buscar por buque"
        find('#nombre_de_buques_index').find(:xpath, 'option["DON KASBERGEN"]').select_option
        sleep 2
        find("table").should have_content("DON KASBERGEN")
        find("table").should_not have_content("GONZA")
      end

      it "debe eliminar el filtro", :js => true do
        xml = File.read(Rails.root.join("spec/support/posiciones_con_registros.xml"))
        @posiciones = Factory(:posiciones, :listado => xml)
        visit visualizar_posiciones_path(@posiciones)
        click_link "Buscar por buque"
        click_link "Eliminar filtro"
        find("table").should have_content("DON KASBERGEN")
        find("table").should have_content("GONZA")
      end


    end

  end
end
