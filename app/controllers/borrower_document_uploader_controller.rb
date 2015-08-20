# rubocop:disable ClassLength
class BorrowerDocumentUploaderController < ApplicationController
  def upload
    return render json: {message: 'File not found'}, status: 500 if params[:file].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?
    return render json: {message: 'Borrower not found'}, status: 500 if params[:borrower_id].blank?

    document_klass = params[:type].constantize
    document = document_klass.where(borrower_id: params[:borrower_id]).last
    borrower = Borrower.find(params[:borrower_id])

    if document.present? && params[:type]!= 'OtherBorrowerReport'
      document.update(attachment: params[:file])
    else
      document = document_klass.new(attachment: params[:file], borrower_id: borrower.id, description: params[:description])
      document.owner = current_user
      document.save
    end

    download_url = get_download_url(document)
    remove_url = get_remove_url(document, borrower)
    render json: {message: "Uploaded sucessfully", download_url: download_url, remove_url: remove_url}, status: 200
  end

  def download
    return render json: {message: 'File not found'}, status: 500 if params[:id].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?

    document = params[:type].constantize.find(params[:id])
    url = Amazon::GetUrlService.new(document.attachment.s3_object).call
    redirect_to url
  end

  def remove
    return render json: {message: 'Invalid document type'} unless params[:type].present? && params[:borrower_id].present?
    document_klass = params[:type].constantize
    document = document_klass.where(borrower_id: params[:borrower_id]).last
    document.destroy
    render json: {message: "Removed it sucessfully"}, status: 200
  end

  private

  def borrower_document_uploader_params
    params.permit(:file, :order)
  end

  def get_download_url(document)
    download_borrower_document_uploader_url(document) + '?type=' + document.class_name
  end

  def get_remove_url(document, borrower)
    remove_borrower_document_uploader_index_url + '?type=' + document.class_name + '&borrower_id=' + borrower.id.to_s
  end
end
