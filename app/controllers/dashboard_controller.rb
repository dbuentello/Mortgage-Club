class DashboardController < ApplicationController
  def show
    borrower = current_user.borrower
    # TODO: select loan by params[:loan_id] when we build multi dashboards.
    loan = current_user.loans.first
    property =  loan.property

    bootstrap(
      doc_list: borrower.documents.as_json(doc_list_json_option),
      address: borrower.display_current_address,
      loan: {
        amount: loan.amount,
        duration: loan.num_of_months / 12,
        type: loan.loan_type,
        percentage: (loan.amount / property.purchase_price * 100).ceil,
        purpose: loan.purpose.titleize
      },
      property: {
        usage: property.usage_name
      }
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