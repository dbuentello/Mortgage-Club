class LoanMembers::LenderDocumentsController < LoanMembers::BaseController
  before_action :set_loan, only: [:create]
  before_action :set_document, only: [:download, :remove]

  def create
    # TODO: loan_id & required_template_id
    lender_document = LenderDocument.find_or_initialize_by(loan: @loan)
    lender_document.attachment = params[:file]
    lender_document.description = params[:description]
    lender_document.user = current_user

    if lender_document.save
      render json: {
        lender_document: LenderDocumentsPresenter.show(lender_document),
        lender_documents: LenderDocumentsPresenter.index(@loan.lender_documents),
        download_url: get_download_url(lender_document),
        remove_url: get_remove_url(lender_document),
        message: 'Created successfully'
      }, status: 200
    else
      render json: {message: "Failed to upload document"}, status: 500
    end
  end

  def download
    url = Amazon::GetUrlService.call(@document.attachment, 10.seconds)
    redirect_to url
  end

  def remove
    @document.destroy
    if @document.destroyed?
      return render json: {message: 'Removed it sucessfully'}, status: 200
    else
      return render json: {message: 'Remove file failed'}, status: 500
    end
  end

  private

  def set_document
    return render json: {message: 'File is not found'}, status: 500 unless @document = LenderDocument.find_by_id(params[:id])
  end

  def get_download_url(document)
    download_loan_members_lender_document_path(document)
  end

  def get_remove_url(document)
    remove_loan_members_lender_document_path(document)
  end
end
