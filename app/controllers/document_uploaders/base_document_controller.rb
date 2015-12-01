class DocumentUploaders::BaseDocumentController < ApplicationController
  def download
    return render json: {message: 'File not found'}, status: 500 if params[:id].blank?

    url = DocumentServices::DownloadFile.call(params[:id])
    redirect_to url
  end

  def remove
    return render json: {message: 'Invalid document type'}, status: 500 if params[:id].blank?

    if DocumentServices::RemoveFile.call(params[:id])
      return render json: {message: 'Removed it sucessfully'}, status: 200
    else
      return render json: {messaage: 'Remove file failed'}, status: 500
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
      return render json: {messaage: 'Upload file failed'}, status: 500
    end
  end

  private

  def get_download_url(document)
    download_document_uploaders_base_document_path(document)
  end

  def get_remove_url(document)
    remove_document_uploaders_base_document_path(document)
  end
end
