class LoansController < ApplicationController
  before_action :set_loan, only: [:new, :update]

  def new
    show
  end

  def show
    @loan = @loan || Loan.find(params[:id])

    bootstrap({
      currentLoan: @loan.as_json(loan_json_options),
      borrower_type: (@borrower_type == :borrower) ? 0 : 1
    })

    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  def update
    @loan = @loan || Loan.find(params[:id])

    borrower_params = secondary_borrower_params
    if borrower_params
      if borrower_params[:_remove]
        Form::SecondaryBorrower.remove(current_user, @borrower_type, secondary_borrower_params)
      else
        Form::SecondaryBorrower.save(current_user, @borrower_type, secondary_borrower_params)
      end
    end

    if @loan.update(loan_params)
      render json: {loan: @loan.reload.as_json(loan_json_options)}
    else
      render json: {error: @loan.errors.full_messages}, status: 500
    end
  end

  # GET get_co_borrower_info
  def get_co_borrower_info
    is_existing = Form::SecondaryBorrower.check_existing_borrower(current_user, params[:email])

    if is_existing
      is_valid = Form::SecondaryBorrower.check_valid_borrower(borrower_info_params)

      if is_valid
        user = User.where(email: params[:email]).first
        borrower = user.borrower

        render json: { secondary_borrower: borrower.as_json(borrower_json_options) }, status: :ok
      else
        render json: { message: 'invalid email or date of birth or social security number' }, status: :ok
      end
    else
      render json: { message: 'not found' }, status: :ok
    end
  end

  private

  def set_loan
    @loan = current_user.loans.first # get the first own loan
    if @loan.present?
      @borrower_type = :borrower
    else
      @loan = current_user.borrower.loan # or get the co-borrower relationship

      if @loan.present?
        @borrower_type = :secondary_borrower
      else
        @loan = Loan.initiate(current_user) # or create branch new one

        @borrower_type = :borrower
      end
    end
  end

  def loan_params
    params.require(:loan).permit(Loan::PERMITTED_ATTRS)
  end

  def secondary_borrower_params
    if params[:loan][:secondary_borrower_attributes].present?
      permit_attrs = Borrower::PERMITTED_ATTRS + [:email, :_remove]
      params.require(:loan).require(:secondary_borrower_attributes).permit(permit_attrs)
    else
      nil
    end
  end

  def borrower_info_params
    params.permit([:email, :dob, :ssn])
  end

  def loan_json_options
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

  def borrower_json_options
    {
      include: [
        user: {
          only: [ :email ]
        }
      ],
      methods: [
        :current_address, :previous_addresses, :current_employment, :previous_employments
      ]
    }
  end

end
