class DocumentUploaders::BaseDocumentController < ApplicationController
  def download
    return render json: {message: 'File not found'}, status: 500 if params[:id].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?

    url = DocumentServices::DownloadFile.call(params[:type], params[:id])
    redirect_to url
  end

  def remove
    return render json: {message: 'Invalid document type'} unless params[:type].present? && params[:id].present?

    if DocumentServices::RemoveFile.call(params[:type], params[:id])
      return render json: {message: 'Removed it sucessfully'}, status: 200
    else
      return render json: {messaage: 'Remove file failed'}, status: 500
    end
  end

  def upload(args)
    document = DocumentServices::UploadFile.new(args).call

    render json: {
      message: 'Uploaded sucessfully',
      download_url: get_download_url(document),
      remove_url: get_remove_url(document)
    }, status: 200
  end

  private

  def get_download_url(document)
    download_document_uploaders_base_document_path(document) + '?type=' + document.class_name
  end

  def get_remove_url(document)
    remove_document_uploaders_base_document_path(document) + '?type=' + document.class_name
  end
end
