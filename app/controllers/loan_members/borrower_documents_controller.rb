class LoanMembers::BorrowerDocumentsController < LoanMembers::BaseController
  def get_other_documents
    render json: {
      borrower_documents: LoanMembers::BorrowerDocumentsPresenter.new(Borrower.find(params[:id]).other_documents).show
    }, status: 200
  end
end
