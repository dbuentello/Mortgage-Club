class LoanDocumentUploaderController < ApplicationController
  # TODO: refactor with other document uploaders
  def download
    return render json: {message: 'File not found'}, status: 500 if params[:id].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?

    document = params[:type].constantize.find(params[:id])
    url = Amazon::GetUrlService.new(document.attachment.s3_object).call
    redirect_to url
  end

  def upload
    return render json: {message: 'File not found'}, status: 500 if params[:file].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?
    return render json: {message: 'Loan not found'}, status: 500 if params[:loan_id].blank?

    document_klass = params[:type].constantize
    document = document_klass.where(loan_id: params[:loan_id]).last
    loan = Loan.find(params[:loan_id])

    if document.present?
      document.update(attachment: params[:file])
    else
      document = document_klass.new(attachment: params[:file], loan: loan)
      document.owner = current_user
      document.save
    end

    download_url = get_download_url(document)
    remove_url = get_remove_url(document, loan)
    render json: {message: "Uploaded sucessfully", download_url: download_url, remove_url: remove_url}, status: 200
  end

  def remove
    return render json: {message: 'Invalid document type'} unless params[:type].present? && params[:loan_id].present?
    document_klass = params[:type].constantize
    document = document_klass.where(loan_id: params[:loan_id]).last
    document.destroy
    render json: {message: "Removed it sucessfully"}, status: 200
  end

  private

  def get_download_url(document)
    download_loan_document_uploader_url(document) + '?type=' + document.class_name
  end

  def get_remove_url(document, loan)
    remove_loan_document_uploader_index_url + '?type=' + document.class_name + '&loan_id=' + loan.id.to_s
  end
end
