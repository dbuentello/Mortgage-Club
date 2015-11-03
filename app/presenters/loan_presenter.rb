class LoanPresenter
  def initialize(loan)
    @loan = loan
  end

  def edit
    @loan.as_json(edit_loan_json_options)
  end

  def show
    @loan.as_json(show_loan_json_options)
  end

  def show_loan_activities
    @loan.as_json(show_loan_activities_json_options)
  end

  def show_documents
    @loan.loan_documents.includes(:owner).as_json(loan_documents_json_options)
  end

  private

  def edit_loan_json_options
    {
      include: {
        rental_properties: {
          include: :address
        },
        primary_property: {
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
          ],
          methods: [
            :current_address, :previous_addresses, :current_employment, :previous_employments,
            :first_name, :last_name, :middle_name, :suffix
          ]
        }
      },
      methods: [
        :property_completed, :borrower_completed, :income_completed, :credit_completed, :assets_completed, :declarations_completed, :primary_property, :rental_properties
      ]
    }
  end

  def show_loan_activities_json_options
    {
      include: {
        borrower: {
          include: [
            :first_bank_statement, :second_bank_statement,
            :first_paystub, :second_paystub,
            :first_w2, :second_w2
          ]
        },
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        },
        checklists: {
          include: {
            user: {
              methods: [ :to_s ]
            }
          }
        },
        hud_estimate: {}, hud_final: {}, other_loan_reports: {},
        loan_estimate: {}, uniform_residential_lending_application: {}
      }
    }
  end

  def show_loan_json_options
    {
      only: [ :id, :amount, :created_at, :interest_rate, :amortization_type ],
      include: {
        properties: {
          only: [:id],
          include: {
            address: {
              only: [],
              methods: :address
            }
          },
          methods: :usage_name
        },
        borrower: {
          only: [:id],
          include: [
            :first_bank_statement, :second_bank_statement,
            :first_paystub, :second_paystub,
            :first_w2, :second_w2
          ]
        },
        closing: {
          only: [:id]
        }
      },
      methods: [
        :num_of_years, :ltv_formula, :purpose_titleize, :primary_property
      ]
    }
  end

  def loan_documents_json_options
    {
      methods: [ :file_icon_url, :class_name, :owner_name ]
    }
  end

end