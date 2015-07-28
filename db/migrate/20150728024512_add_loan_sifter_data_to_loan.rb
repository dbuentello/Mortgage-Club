class AddLoanSifterDataToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :appraisal_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :city_county_deed_stamp_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :credit_report_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :document_preparation_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :flood_certification, :decimal, :precision => 11, :scale => 2
    add_column :loans, :origination_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :settlement_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :state_deed_tax_stamp_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :tax_related_service_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :title_insurance_fee, :decimal, :precision => 11, :scale => 2
  end
end
