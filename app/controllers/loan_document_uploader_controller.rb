class LoanDocumentUploaderController < ApplicationController
  # TODO: refactor with other document uploaders
  def download
    return unless params[:type].present? && params[:id].present?
    document = params[:type].constantize.find(params[:id])

    url = Amazon::GetUrlService.new(document.attachment.s3_object).call
    redirect_to url
  end
end
