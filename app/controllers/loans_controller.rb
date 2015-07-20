class LoansController < ApplicationController
  def new
    @loan = current_user.loans.first || # get the first own loan
      current_user.borrower.loan || # or get the co-borrower relationship
      Loan.initiate(current_user) # or create branch new one

    show
  end

  def show
    @loan = @loan || Loan.find(params[:id])
    bootstrap({currentLoan: @loan.as_json(json_options)})
    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  def create
    @loan = Loan.create(loan_params)
  end

  def update
    @loan = current_user.loans.find(params[:id])

    if secondary_borrower_params.present?
      Form::SecondaryBorrower.save(current_user, secondary_borrower_params)
    end

    if @loan.update(loan_params)
      render json: {loan: @loan.reload.as_json(json_options)}
    else
      render json: {error: @loan.errors.full_messages}, status: 500
    end
  end

  private

  def loan_params
    params.require(:loan).permit(Loan::PERMITTED_ATTRS)
  end

  def secondary_borrower_params
    permit_attrs = Borrower::PERMITTED_ATTRS + [:email]
    params.require(:loan).require(:secondary_borrower_attributes).permit(permit_attrs)
  end

  def json_options
    {
      include: {
        property: {
          include: :address
        },
        borrower: {
          include: [
            :first_bank_statement, :second_bank_statement,
            :first_paystub, :second_paystub,
            :first_w2, :second_w2, user: {
              only: [ :email ]
            }
          ],
          methods: [
            :current_address, :previous_addresses, :current_employment, :previous_employments
          ]
        },
        secondary_borrower: {
          include: [
            user: {
              only: [ :email ]
            }
          ]
        }
      },
      methods: [
        :property_completed, :borrower_completed, :income_completed
      ]
    }
  end

end
