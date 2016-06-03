class LoanMembers::LeadRequestsPresenter
  def initialize(requests)
    @requests = requests
  end

  def show
    @requests.as_json(show_requests_json_options)
  end

  private

  def show_requests_json_options
    {
      only: [:id, :loan_id, :loan_member_id, :status]
    }
  end
end
