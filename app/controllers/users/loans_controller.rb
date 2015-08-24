class Users::LoansController < Users::BaseController
  before_action :set_loan, only: [:dashboard, :edit, :update, :destroy]

  def create
    # WILLDO: solve n+1 query problem
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
      currentLoan: @loan.as_json(edit_loan_json_options),
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
      render json: {loan: @loan.reload.as_json(edit_loan_json_options)}
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

  def index
    bootstrap(
      loans: current_user.loans.includes(property: :address).as_json(loan_json_options)
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def dashboard
    loan = @loan
    property = loan.property
    borrower = current_user.borrower
    closing = loan.closing || Closing.create(name: 'Closing', loan_id: loan.id)
    loan_activities = loan.loan_activities.includes(loan_member: :user).recent_loan_activities(10)

    bootstrap(
      address: property.address.try(:address),
      loan: loan.as_json(loan_json_options),
      borrower_list: borrower.as_json(borrower_list_json_options),
      contact_list: contact_list_json_options,
      property_list: property.as_json(property_list_json_options),
      loan_list: loan.as_json(loan_list_json_options),
      loan_activities: loan_activities.as_json,
      closing_list: closing.as_json(closing_list_json_options)
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
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

  def edit_loan_json_options
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

  def loan_json_options
    {
      only: [ :id, :amount, :created_at, :interest_rate ],
      include: {
        property: {
          only: [],
          include: {
            address: {
              only: [],
              methods: :address
            }
          },
          methods: :usage_name
        }
      },
      methods: [
        :num_of_years, :ltv_formula, :purpose_titleize
      ]
    }
  end

  def loan_list_json_options
    {
      include: {
        loan_documents: {
          methods: [ :file_icon_url, :class_name, :owner_name ]
        }
      }
    }
  end

  def borrower_list_json_options
    {
      include: {
        borrower_documents: {
          methods: [ :file_icon_url, :class_name, :owner_name ]
        }
      }
    }
  end

  def property_list_json_options
    {
      include: {
        property_documents: {
          methods: [ :file_icon_url, :class_name, :owner_name ]
        }
      }
    }
  end

  def contact_list_json_options
    [
      {
        id: 1,
        name: 'Michael Gifford',
        title: 'Relationship Manager',
        email: 'michael@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      },
      {
        id: 2,
        name: 'Jerry Williams',
        title: 'Loan Analyst',
        email: 'jerry@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      },
      {
        id: 3,
        name: 'Kristina Rendon',
        title: 'Insurance',
        email: 'kristina@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      }
    ]
  end

  def closing_list_json_options
    {
      include: {
        closing_documents: {
          methods: [ :file_icon_url, :class_name ]
        }
      }
    }
  end

end