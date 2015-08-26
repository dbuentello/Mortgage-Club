class DocumentUploaders::BorrowersController < DocumentUploaders::BaseDocumentController
  def upload
    return render json: {message: 'File not found'}, status: 500 if params[:file].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?
    return render json: {message: 'Borrower not found'}, status: 500 if params[:borrower_id].blank?

    args = {
      subject_class_name: 'Borrower',
      document_klass_name: params[:type],
      foreign_key_name: 'borrower_id',
      foreign_key_id: params[:borrower_id],
      current_user: current_user,
      params: params
    }

    super(args)
  end
end
