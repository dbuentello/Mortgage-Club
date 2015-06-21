class BorrowerUploaderController < ApplicationController
  def bank_statements
    if params[:file].blank?
      message = 'File not found'
    else
      message = ""
      borrower = Borrower.find_by_id(params[:id])
      file = File.open(params[:file].tempfile, 'r')
      message.concat("#{params[:order] }")

      case params[:order]
      when 1
        bank_statement = borrower.first_bank_statement
        if bank_statement.present?
          bank_statement.update(attachment: file)
        else

          bank_statement = borrower.build_first_bank_statement(attachment: file)
          bank_statement.save
        end
      when 2
        bank_statement = borrower.second_bank_statement
        if bank_statement.present?
          bank_statement.update(attachment: file)
        else
          bank_statement = borrower.build_second_bank_statement(attachment: file)
        end
      end

      file.close
      message.concat("Sucessfully for #{borrower.first_name}")
    end

    render json: { message: message }, status: :ok
  end

  def brokerage_statements
  end

  def paystubs
  end

  def w2s
  end

  private

    def borrower_uploader_params
      params.permit(:file, :order)
    end

end
