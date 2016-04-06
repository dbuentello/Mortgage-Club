class LoanMembers::DocumentsController < LoanMembers::BaseController
  def get_other_documents
    other_documents = Document.where(subjectable_type: params[:subject_type], subjectable_id: params[:subject_id], document_type: params[:document_type])

    render json: {
      other_documents: LoanMembers::DocumentsPresenter.new(other_documents).show
    }, status: 200
  end
end
