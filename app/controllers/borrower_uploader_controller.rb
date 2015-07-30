class BorrowerUploaderController < ApplicationController

  def w2
    if params[:file].blank?
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
      else
        message = 'Missing param order'
      end

      message ||= "Sucessfully for #{borrower.first_name}"
    end

    render json: { message: message }, status: :ok
  end

  def paystub
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
      else
        message = 'Missing param order'
      end

      message ||= "Sucessfully for #{borrower.first_name}"
    end

    render json: { message: message }, status: :ok
  end

  def bank_statement
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
      else
        message = 'Missing param order'
      end

      message ||= "Sucessfully for #{borrower.first_name}"
    end

    render json: { message: message }, status: :ok
  end

  def remove_w2
    borrower = Borrower.find_by_id(params[:id])

    case params[:order]
    when "1"
      w2 = borrower.first_w2
    when "2"
      w2 = borrower.second_w2
    else
      message = 'Missing param order'
    end

    if w2.present?
      message = "Done removed"
      w2.destroy
    else
      message ||= "File not found"
    end

    render json: { message: message }, status: :ok
  end

  def remove_paystub
    borrower = Borrower.find_by_id(params[:id])

    case params[:order]
    when "1"
      paystub = borrower.first_paystub
    when "2"
      paystub = borrower.second_paystub
    else
      message = 'Missing param order'
    end

    if paystub.present?
      message = "Done removed"
      paystub.destroy
    else
      message ||= "File not found"
    end

    render json: { message: message }, status: :ok
  end

  def remove_bank_statement
    borrower = Borrower.find_by_id(params[:id])

    case params[:order]
    when "1"
      bank_statement = borrower.first_bank_statement
    when "2"
      bank_statement = borrower.second_bank_statement
    else
      message = 'Missing param order'
    end

    if bank_statement.present?
      message = "Done removed"
      bank_statement.destroy
    else
      message ||= "File not found"
    end

    render json: { message: message }, status: :ok
  end

  def download_w2
    borrower = Borrower.find_by_id(params[:id])

    case params[:order]
    when "1"
      w2 = borrower.first_w2
    when "2"
      w2 = borrower.second_w2
    else
      message = 'Missing param order'
    end

    if w2.present?
      url = w2.attachment.s3_object.url_for(:read, :secure => true, :expires => Document::EXPIRE_VIEW_SECONDS.seconds).to_s
      redirect_to url
    else
      render json: { message: "You don't have this file yet. Try to upload it!" }
    end
  end

  def download_paystub
    borrower = Borrower.find_by_id(params[:id])

    case params[:order]
    when "1"
      paystub = borrower.first_paystub
    when "2"
      paystub = borrower.second_paystub
    else
      message = 'Missing param order'
    end

    if paystub.present?
      url = paystub.attachment.s3_object.url_for(:read, :secure => true, :expires => Document::EXPIRE_VIEW_SECONDS.seconds).to_s
      redirect_to url
    else
      render json: { message: "You don't have this file yet. Try to upload it!" }
    end
  end

  def download_bank_statement
    borrower = Borrower.find_by_id(params[:id])

    case params[:order]
    when "1"
      bank_statement = borrower.first_bank_statement
    when "2"
      bank_statement = borrower.second_bank_statement
    else
      message = 'Missing param order'
    end

    if bank_statement.present?
      url = bank_statement.attachment.s3_object.url_for(:read, :secure => true, :expires => Document::EXPIRE_VIEW_SECONDS.seconds).to_s
      redirect_to url
    else
      render json: { message: "You don't have this file yet. Try to upload it!" }
    end
  end

  private

  def borrower_uploader_params
    params.permit(:file, :order)
  end

end
