class DocumentUploaders::BaseDocumentController < ApplicationController
  before_action :set_document, only: [:download, :destroy]

  def download
    url = Amazon::GetUrlService.call(@document.attachment, 10.seconds)
    redirect_to url
  end

  def destroy
    @document = Document.find_by_id(params[:id])

    if @document.destroy
      return render json: {message: 'Removed it sucessfully'}, status: 200
    else
      return render json: {message: 'Remove file failed'}, status: 500
    end
  end

  def upload
    return render json: {message: 'File not found'}, status: 500 if params[:file].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:document_type].present?
    return render json: {message: 'Subject was not found'}, status: 500 if params[:subject_id].blank? || params[:subject_type].blank?

    args = {
      subject_type: params[:subject_type],
      subject_id: params[:subject_id],
      document_type: params[:document_type],
      current_user: current_user,
      params: params
    }

    if document = DocumentServices::UploadFile.new(args).call
      render json: {
        message: 'Uploaded sucessfully',
        download_url: get_download_url(document),
        remove_url: get_remove_url(document)
      }, status: 200
    else
      return render json: {message: 'Upload file failed'}, status: 500
    end
  end

  private

  def set_document
    return render json: {message: 'File is not found'}, status: 500 unless @document = Document.find_by_id(params[:id])
  end

  def get_download_url(document)
    download_document_uploaders_base_document_path(document)
  end

  def get_remove_url(document)
    document_uploaders_base_document_path(document)
  end
end
