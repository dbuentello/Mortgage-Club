class DocumentUploaders::LoansController < DocumentUploaders::BaseDocumentController
  def upload
    return render json: {message: 'File not found'}, status: 500 if params[:file].blank?
    return render json: {message: 'Invalid document type'}, status: 500 unless params[:type].present?
    return render json: {message: 'Loan not found'}, status: 500 if params[:loan_id].blank?

    args = {
      subject_class_name: 'Loan',
      document_klass_name: params[:type],
      foreign_key_name: 'loan_id',
      foreign_key_id: params[:loan_id],
      current_user: current_user,
      params: params
    }

    super(args)
  end
end
