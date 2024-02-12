require 'rubyXL'
require 'rubyXL/convenience_methods'

class Sale < ApplicationRecord
  # Associations
  has_many :sale_details, dependent: :destroy
  has_many :sale_payments, dependent: :destroy

  belongs_to :client, optional: true
  belongs_to :user

  enum payment_status: { unpaid: 0, partially_paid: 1, paid: 2 }

  # Validations
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :user_id, presence: true
  validates :payment_status, presence: true

  def paid_amount()
    if not self.sale_payments.empty?
      return self.sale_payments.sum(:amount)
    end
  end

  def pending_amount()
    if not self.sale_payments.empty?
      self.total_amount - self.paid_amount()
    end
  end

  def update_paid_status
    paid_amount = self.paid_amount()
    if paid_amount > 0 and paid_amount < self.total_amount
      self.update(payment_status: :partially_paid)
    elsif paid_amount == self.total_amount
      self.update(payment_status: :paid)
    else
      self.update(payment_status: :unpaid)
    end
  end

  def self.generate_doc(sale)
    path = "#{Rails.root}/app/views/excel_templates/comprobante-descartables-sa.xlsx"

    workbook = RubyXL::Parser.parse(path)
    worksheet = workbook.worksheets[0]

    # Client data
    if sale.client.nil?
      worksheet[10][1].change_contents("Consumidor final")
    else
      worksheet[10][1].change_contents(sale.client.name)
      worksheet[10][5].change_contents(sale.client.phone)
      worksheet[12][1].change_contents(sale.client.dir)
    end

    # ID of the sale
    worksheet[6][6].change_contents(sale.id.to_s)
    # Date of the sale
    worksheet[4][6].change_contents(sale.created_at.strftime('%d/%m/%Y'))

    current_row = 18
    discount_rows = []

    sale.sale_details.find_each do |detail|
      total_amount = detail.product.selling_unit_price * detail.quantity
      worksheet.insert_row(16)
      worksheet.add_cell(16, 1, detail.product.name)
      worksheet.add_cell(16, 4, detail.quantity)
      worksheet.add_cell(16, 5, "$#{detail.product.selling_unit_price}")
      worksheet.add_cell(16, 6, "$#{total_amount}")

      worksheet.sheet_data[16][5].change_horizontal_alignment('right')
      worksheet.sheet_data[16][6].change_horizontal_alignment('right')

      if detail.discount > 0
        discount_rows << { row: current_row, name: detail.product.name, amount: total_amount * detail.discount }
      end

      current_row += 1
    end

    discount_rows.each do |discount|
      worksheet.insert_row(discount[:row])
      worksheet.add_cell(discount[:row], 1, "DESCUENTO por "+discount[:name])
      worksheet.add_cell(discount[:row], 6, "-$#{discount[:amount]}")
      worksheet.sheet_data[discount[:row]][6].change_horizontal_alignment('right')

      current_row += 1
    end

    worksheet[current_row][6].change_contents("$#{sale.total_amount}")

    Tempfile.create(["receipt", ".xlsx"]) do |temp_file|
      workbook.write(temp_file.path)
      xlsx_data = File.read(temp_file.path)
      xlsx_data
    end
  end


end
