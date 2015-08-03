class DashboardController < ApplicationController
  def show
    borrower = current_user.borrower
    bootstrap(
      doc_list: borrower.documents.as_json(doc_list_json_option),
      address: borrower.display_current_address
    )
    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  private

  def doc_list_json_option
    {
      only: [:id],
      methods: [:name, :url]
    }
  end
end