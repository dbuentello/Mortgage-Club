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

  def show_at_loan_member_dashboard
    @loan.as_json(show_at_loan_member_dashboard_json_options)
  end

  def show_documents
    @loan.loan_documents.includes(:owner).as_json(loan_documents_json_options)
  end

  private

  def edit_loan_json_options
    {
      include: {
        rental_properties: {
          include: :address,
          methods: [:mortgage_payment_liability, :other_financing_liability]
        },
        primary_property: {
          include: :address,
          methods: [:mortgage_payment_liability, :other_financing_liability]
        },
        subject_property: {
          include: :address,
          methods: [:mortgage_payment_liability, :other_financing_liability]
        },
        borrower: {
          include: [
            :declaration, :documents, :assets,
            user: {
              only: [ :email, :first_name ]
            }
          ],
          methods: [
            :current_address, :previous_address, :current_employment, :previous_employments,
            :first_name, :last_name, :middle_name, :suffix
          ]
        },
        secondary_borrower: {
          include: [
            :declaration, :documents,
            user: {
              only: [ :email ]
            }
          ],
          methods: [
            :current_address, :previous_address, :current_employment, :previous_employments,
            :first_name, :last_name, :middle_name, :suffix
          ]
        }
      },
      methods: [
        :property_completed, :borrower_completed, :income_completed, :credit_completed, :assets_completed, :declarations_completed, :primary_property, :subject_property, :rental_properties
      ]
    }
  end

  def show_at_loan_member_dashboard_json_options
    {
      include: {
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
        documents: {},
        lender_documents: {}
      },
      methods: :can_submit_to_lender
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
            :documents
          ]
        },
        closing: {
          only: [:id]
        }
      },
      methods: [
        :num_of_years, :purpose_titleize, :primary_property, :subject_property
      ]
    }
  end

  def loan_documents_json_options
    {
      methods: [ :file_icon_url, :class_name, :owner_name ]
    }
  end

end