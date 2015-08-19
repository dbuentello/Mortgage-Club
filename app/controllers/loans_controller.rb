class LoansController < ApplicationController
  before_action :set_loan, only: [:edit, :update, :destroy]

  def create
    @loan = Loan.initiate(current_user)

    if @loan.save
      flash[:success] = "Sucessfully create a new loan"
      render json: {loan_id: @loan.id}, status: 200
    else
      render json: {message: "Cannot create new loan"}, status: 500
    end
  end

  def edit
    loan = @loan

    bootstrap({
      currentLoan: @loan.as_json(loan_json_options),
      borrower_type: (@borrower_type == :borrower) ? "borrower" : "co_borrower"
    })

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def update
    loan = @loan

    @borrower_params = co_borrower_params
    if @borrower_params.present?
      if @borrower_params[:_remove]
        Form::CoBorrower.remove(current_user, @borrower_type, @borrower_params)
      else
        Form::CoBorrower.save(current_user, @borrower_type, @borrower_params)
      end
    end

    if @loan.reload.update(loan_params)
      render json: {loan: @loan.reload.as_json(loan_json_options)}
    else
      render json: {error: @loan.errors.full_messages}, status: 500
    end
  end

  def destroy
    if @loan.destroy
      flash[:success] = "Sucessfully destroy loan"

      render json: {redirect_path: my_loans_path}, status: 200
    else
      render json: {message: "Cannot destroy loan"}, status: 500
    end
  end

  # GET get_co_borrower_info
  def get_co_borrower_info
    is_existing = Form::CoBorrower.check_existing_borrower(current_user, params[:email])

    if is_existing
      is_valid = Form::CoBorrower.check_valid_borrower(borrower_info_params)

      if is_valid
        user = User.where(email: params[:email]).first
        borrower = user.borrower

        render json: {secondary_borrower: borrower.as_json(borrower_json_options)}, status: :ok
      else
        render json: {message: 'Invalid email or date of birth or social security number'}, status: :ok
      end
    else
      render json: {message: 'Not found'}, status: :ok
    end
  end

  private

  def loan_params
    params.require(:loan).permit(Loan::PERMITTED_ATTRS)
  end

  def co_borrower_params
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
            :current_address, :previous_addresses, :current_employment, :previous_employments,
            :first_name, :last_name, :middle_name, :suffix
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
        :current_address, :previous_addresses, :current_employment, :previous_employments,
        :first_name, :last_name, :middle_name, :suffix
      ]
    }
  end

end
