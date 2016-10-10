class LoanMembers::DocumentsController < LoanMembers::BaseController
  def get_other_documents
    other_documents = Document.where(subjectable_type: params[:subject_type], subjectable_id: params[:subject_id], document_type: params[:document_type])

    render json: {
      other_documents: LoanMembers::DocumentsPresenter.new(other_documents).show
    }, status: 200
  end

  def update_required
    document = Document.find_by_id(params[:id])

    if document && document.update(is_required: params[:is_required])
      document.subjectable.update(is_editted_by_loan_member: true)
      render json: {}, status: 200
    else
      render json: {}, status: 404
    end
  end
end
