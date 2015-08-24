class LoanPresenter
  def initialize(loan)
    @loan = loan
  end

  def edit_loan
    @loan.as_json(edit_loan_json_options)
  end

  def show_loan
    @loan.as_json(show_loan_json_options)
  end

  private

  def edit_loan_json_options
    {
      include: {
        property: {
          include: :address
        },
        borrower: {
          include: [
            :declaration, :first_bank_statement, :second_bank_statement,
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

  def show_loan_json_options
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

end