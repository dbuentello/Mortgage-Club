class DocumentUploaderController < ApplicationController
  # TODO: refactor with other document uploaders
  def download
    return unless params[:type].present? && params[:id].present?
    document = params[:type].constantize.find(params[:id])

    url = Amazon::GetUrlService.call(document.attachment)
    redirect_to url
  end
end
