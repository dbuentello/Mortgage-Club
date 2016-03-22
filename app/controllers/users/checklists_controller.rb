class Users::ChecklistsController < Users::BaseController
  before_action :set_loan, only: [:load_docusign]
  before_action :load_checklist, only: [:update, :load_docusign, :docusign_callback]

  def update
    if @checklist.update(checklist_params)
      render json: {message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update_checklist"))}, status: 500
    end
  end

  def load_docusign
    template = Template.where(name: params[:template_name]).first
    if template.blank?

      return render json: {
        message: t("errors.template_not_found"),
        details: t("errors.template_not_exist", object_name: "#{params[:template_name]}")
      }, status: 500
    end

    envelope = Docusign::CreateEnvelopeForChecklistService.new.call(current_user, @loan)
    if envelope
      docusign_callback_url = docusign_callback_checklists_url(
        loan_id: @loan.id,
        id: @checklist.id,
        envelope_id: envelope["envelopeId"],
        user_id: current_user.id
      )
      recipient_view = Docusign::GetRecipientViewService.call(envelope["envelopeId"], current_user, docusign_callback_url)
      return render json: {message: recipient_view}, status: 200 if recipient_view
    end

    render json: {message: t("errors.iframe_render_error")}, status: 500
  end

  def docusign_callback
    utility = DocusignRest::Utility.new

    if params[:event] == "signing_complete"
      @checklist.update(status: "done")
      Docusign::MapChecklistExplanationToLenderDocument.new(params[:envelope_id], @checklist.id, params[:user_id]).delay.call
      render text: utility.breakout_path(dashboard_url(params[:loan_id])), content_type: "text/html"
    elsif params[:event] == "ttl_expired"
      # the session has been expired
    else
      render text: utility.breakout_path(dashboard_url(params[:loan_id], success: true)), content_type: "text/html"
    end
  end

  private

  def checklist_params
    params.require(:checklist).permit(:checklist_type, :document_type, :name, :description, :question, :due_date, :template_id, :status)
  end

  def load_checklist
    @checklist = Checklist.find(params[:id])
  end
end
