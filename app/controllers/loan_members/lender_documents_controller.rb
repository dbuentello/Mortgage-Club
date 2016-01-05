class LoanMembers::LenderDocumentsController < LoanMembers::BaseController
  before_action :set_loan, only: [:create, :get_other_documents]
  before_action :set_document, only: [:download, :destroy]

  def create
    return render json: {message: "Template is not found"}, status: 500 unless template = LenderTemplate.find_by_id(params[:template_id])

    service = LenderDocumentServices::UploadFile.new({
      loan: @loan,
      template: template,
      file: params[:file],
      description: params[:description],
      user: current_user
    })

    if service.call
      render json: {
        lender_document: LoanMembers::LenderDocumentsPresenter.new(service.lender_document).show,
        lender_documents: LoanMembers::LenderDocumentsPresenter.new(@loan.lender_documents).show,
        download_url: get_download_url(service.lender_document),
        remove_url: get_remove_url(service.lender_document),
        message: "Created successfully"
      }, status: 200
    else
      render json: {message: "Failed to upload document"}, status: 500
    end
  end

  def download
    url = Amazon::GetUrlService.call(@document.attachment, 10.seconds)
    redirect_to url
  end

  def destroy
    if @document.destroy
      return render json: {message: "Removed it sucessfully"}, status: 200
    else
      return render json: {message: "Remove file failed"}, status: 500
    end
  end

  def get_other_documents
    render json: {
      lender_documents: LoanMembers::LenderDocumentsPresenter.new(@loan.other_lender_documents).show,
    }, status: 200
  end

  private

  def set_document
    return render json: {message: "File is not found"}, status: 500 unless @document = LenderDocument.find_by_id(params[:id])
  end

  def get_download_url(document)
    download_loan_members_lender_document_path(document)
  end

  def get_remove_url(document)
    loan_members_lender_document_path(document)
  end
end
