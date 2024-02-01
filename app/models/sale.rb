require 'rubyXL'
require 'rubyXL/convenience_methods'

class Sale < ApplicationRecord
  # Associations
  has_many :sale_details, dependent: :destroy
  has_many :sale_payments, dependent: :destroy

  belongs_to :client, optional: true
  belongs_to :user

  def paid_amount()
    self.sale_payments.sum(:amount)
  end

  def pending_amount()
    self.total_amount - self.paid_amount()
  end

  def paid?()
    self.total_amount == paid_amount()
  end

  def self.generate_doc(sale)
    path = "#{Rails.root}/app/views/excel_templates/comprobante-descartables-sa.xlsx"

    workbook = RubyXL::Parser.parse(path)
    worksheet = workbook.worksheets[0]

    # Client data
    if sale.client.nil?
      worksheet[10][1].change_contents("Consumidor final")
    else
      worksheet[10][1].change_contents("#{sale.client.name}")
    end
    # ID of the sale
    worksheet[6][6].change_contents("#{sale.id}")
    # Date of the sale
    worksheet[4][6].change_contents("#{sale.created_at.strftime('%d/%m/%Y')}")

    current_row = 18
    sale.sale_details.each do |detail|
      worksheet.insert_row(16)
      worksheet.add_cell(16, 1, detail.product.name)
      worksheet.add_cell(16, 4, detail.quantity)
      worksheet.add_cell(16, 5, detail.product.selling_unit_price)
      worksheet.add_cell(16, 6, detail.product.selling_unit_price * detail.quantity)
      current_row += 1
    end
    worksheet[current_row][6].change_contents("$#{sale.total_amount}")

    temp_file = Tempfile.new(["receipt", ".xlsx"])
    workbook.write(temp_file.path)
    xlsx_data = File.read(temp_file.path)
    temp_file.close
    temp_file.unlink

    xlsx_data
  end
end
