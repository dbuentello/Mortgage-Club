class ClosingDocumentUploaderController < ApplicationController
  def download
    return render json: {message: 'File not found'}, status: 500 if params[:id].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?

    # document = params[:type].constantize.find(params[:id])
    # url = Amazon::GetUrlService.new(document.attachment.s3_object).call
    redirect_to url
  end

  def upload
    return render json: {message: 'File not found'}, status: 500 if params[:file].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?
    return render json: {message: 'Closing not found'}, status: 500 if params[:closing_id].blank?

    # document_klass = params[:type].constantize
    # document = document_klass.where(closing_id: params[:closing_id]).last
    # closing = Closing.find(params[:closing_id])

    # if document.present? && params[:type]!= 'OtherClosingReport'
    #   document.update(attachment: params[:file])
    # else
    #   document = document_klass.new(attachment: params[:file], closing_id: closing.id, description: params[:description])
    #   document.owner = current_user
    #   document.save
    # end

    download_url = get_download_url(document)
    remove_url = get_remove_url(document, closing)
    render json: {message: "Uploaded sucessfully", download_url: download_url, remove_url: remove_url}, status: 200
  end

  def remove
    return render json: {message: 'Invalid document type'} unless params[:type].present? && params[:closing_id].present?
    document_klass = params[:type].constantize
    document = document_klass.where(closing_id: params[:closing_id]).last
    document.destroy
    render json: {message: "Removed it sucessfully"}, status: 200
  end

  private

  def get_download_url(document)
    download_closing_document_uploader_url(document) + '?type=' + document.class_name
  end

  def get_remove_url(document, closing)
    remove_closing_document_uploader_index_url + '?type=' + document.class_name + '&closing_id=' + closing.id.to_s
  end
end
