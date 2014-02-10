class Posiciones < ActiveRecord::Base
  attr_accessible :fecha, :listado
  default_scope -> { order('created_at DESC') }

  def obtener_listado
    if registros?
      @pos.Envelope.Body.GetReportResponse.GetReportResult.diffgram.NewDataSet.Table
    else
      []
    end
  end

  def registros?
    @pos = Hash.from_xml(listado).to_ostruct_recursive
    @pos.Envelope.Body.GetReportResponse.GetReportResult.diffgram.NewDataSet.respond_to?(:Table)
  end
end
