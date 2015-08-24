class LoanDocumentUploaderController < ApplicationController
  def download
    return render json: {message: 'File not found'}, status: 500 if params[:id].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?

    url = DocumentServices::DownloadFile.call(params[:type], params[:id])
    redirect_to url
  end

  def upload
    return render json: {message: 'File not found'}, status: 500 if params[:file].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?
    return render json: {message: 'Loan not found'}, status: 500 if params[:loan_id].blank?

    args = {
      subject_class_name: 'Loan',
      document_klass_name: params[:type],
      foreign_key_name: 'loan_id',
      foreign_key_id: params[:loan_id],
      current_user: current_user,
      params: params
    }
    document = DocumentServices::UploadFile.new(args).call

    render json: {
      message: 'Uploaded sucessfully',
      download_url: get_download_url(document),
      remove_url: get_remove_url(document)
    }, status: 200
  end

  def remove
    return render json: {message: 'Invalid document type'} unless params[:type].present? && params[:id].present?

    if DocumentServices::RemoveFile.call(params[:type], params[:id])
      return render json: {message: 'Removed it sucessfully'}, status: 200
    else
      return render json: {messaage: 'Remove file failed'}, status: 500
    end
  end

  private

  def get_download_url(document)
    download_loan_document_uploader_url(document) + '?type=' + document.class_name
  end

  def get_remove_url(document)
    remove_loan_document_uploader_url(document) + '?type=' + document.class_name
  end
end
