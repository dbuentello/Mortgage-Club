class BorrowerUploaderController < ApplicationController
  def bank_statements
    if params[:file].blank?
      message = 'File not found'
    else
      borrower = Borrower.find_by_id(params[:id])

      case params[:order]
      when "1"
        bank_statement = borrower.first_bank_statement
        if bank_statement.present?
          bank_statement.update(attachment: params[:file])
        else
          bank_statement = borrower.build_first_bank_statement(attachment: params[:file])
          bank_statement.save
        end
      when "2"
        bank_statement = borrower.second_bank_statement
        if bank_statement.present?
          bank_statement.update(attachment: params[:file])
        else
          bank_statement = borrower.build_second_bank_statement(attachment: params[:file])
          bank_statement.save
        end
      end

      message = "Sucessfully for #{borrower.first_name}"
    end

    render json: { message: message }, status: :ok
  end

  def brokerage_statements
    if params[:file].blank?
      message = 'File not found'
    else
      borrower = Borrower.find_by_id(params[:id])

      case params[:order]
      when "1"
        brokerage_statement = borrower.build_first_brokerage_statement
        if brokerage_statement.present?
          brokerage_statement.update(attachment: params[:file])
        else
          brokerage_statement = borrower.build_first_brokerage_statement(attachment: params[:file])
          brokerage_statement.save
        end
      when "2"
        brokerage_statement = borrower.second_brokerage_statement
        if brokerage_statement.present?
          brokerage_statement.update(attachment: params[:file])
        else
          brokerage_statement = borrower.build_second_brokerage_statement(attachment: params[:file])
          brokerage_statement.save
        end
      end

      message = "Sucessfully for #{borrower.first_name}"
    end

    render json: { message: message }, status: :ok
  end

  def paystubs
    if params[:file].blank?
      message = 'File not found'
    else
      borrower = Borrower.find_by_id(params[:id])

      case params[:order]
      when "1"
        paystub = borrower.first_paystub
        if paystub.present?
          paystub.update(attachment: params[:file])
        else
          paystub = borrower.build_first_paystub(attachment: params[:file])
          paystub.save
        end
      when "2"
        paystub = borrower.second_paystub
        if paystub.present?
          paystub.update(attachment: params[:file])
        else
          paystub = borrower.build_second_paystub(attachment: params[:file])
          paystub.save
        end
      end

      message = "Sucessfully for #{borrower.first_name}"
    end

    render json: { message: message }, status: :ok
  end

  def w2s
    if params[:file] == 'undefined'
      message = 'File not found'
    else
      borrower = Borrower.find_by_id(params[:id])

      case params[:order]
      when "1"
        w2 = borrower.first_w2
        if w2.present?
          w2.update(attachment: params[:file])
        else
          w2 = borrower.build_first_w2(attachment: params[:file])
          w2.save
        end
      when "2"
        w2 = borrower.second_w2
        if w2.present?
          w2.update(attachment: params[:file])
        else
          w2 = borrower.build_second_w2(attachment: params[:file])
          w2.save
        end
      end

      message = "Sucessfully for #{borrower.first_name}"
    end

    render json: { message: message }, status: :ok
  end

  private

    def borrower_uploader_params
      params.permit(:file, :order)
    end

end
