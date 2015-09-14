class Users::ChecklistsController < Users::BaseController
  before_action :set_loan, only: [:load_docusign]
  before_action :load_checklist, only: [:update, :load_docusign, :docusign_callback]

  def update
    if @checklist.update(checklist_params)
      render json: {message: 'Updated successfully'}, status: 200
    else
      render json: {message: "Cannot update the checklist"}, status: 500
    end
  end

  def load_docusign
    template = Template.where(name: params[:template_name]).first
    if template.blank?
      return render json: {
              message: "Template does not exist yet",
              details: "Template #{params[:template_name]} does not exist yet!"
            }, status: 500
    end

    envelope = Docusign::CreateEnvelopeService.new(current_user, @loan, [template]).call
    if envelope
      docusign_callback_url = docusign_callback_checklists_url(
        loan_id: @loan.id,
        id: @checklist.id,
        envelope_id: envelope['envelopeId'],
        user_id: current_user.id
      )
      recipient_view = Docusign::GetRecipientViewService.call(envelope['envelopeId'], current_user, docusign_callback_url)
      return render json: {message: recipient_view}, status: 200 if recipient_view
    end

    render json: {message: "can't render iframe"}, status: 500
  end

  def docusign_callback
    utility = DocusignRest::Utility.new

    if params[:event] == "signing_complete"
      @checklist.update(status: 'done')
      Docusign::UploadEnvelopeToAmazonService.new(params[:envelope_id], @checklist.id, params[:user_id]).delay.call
      render text: utility.breakout_path(dashboard_url(params[:loan_id])), content_type: 'text/html'
    elsif params[:event] == "ttl_expired"
      # the session has been expired
    else
      render text: utility.breakout_path(dashboard_url(params[:loan_id], success: true)), content_type: 'text/html'
    end
  end

  private

  def checklist_params
    params.require(:checklist).permit(:checklist_type, :document_type, :name, :description, :question, :due_date, :template_id)
  end

  def load_checklist
    @checklist = Checklist.find(params[:id])
  end
end