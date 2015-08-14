class DashboardController < ApplicationController
  before_action :set_loan, only: [:show, :edit]

  def show
    # WILL_DO: select loan by params[:loan_id] when we build multi dashboards.
    # WILL_DO: resolve n+1 query problem
    loan = @loan
    property = loan.property
    borrower = current_user.borrower
    closing = loan.closing

    bootstrap(
      address: property.address.try(:address),
      loan: loan.as_json(loan_json_options),
      borrower_list: borrower.as_json(borrower_list_json_options),
      contact_list: contact_list_json_options,
      property_list: property.as_json(property_list_json_options),
      loan_list: loan.as_json(loan_list_json_options),
      loan_activities: loan.loan_activities.includes(loan_member: :user).recent_loan_activities(10).as_json,
      closing_list: closing.as_json(closing_list_json_options)
    )

    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  def edit
    show
  end

  def loans
    bootstrap(
      loans: current_user.loans.includes(property: :address).as_json(loan_json_options)
    )

    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  private

  def loan_json_options
    {
      only: [:id, :amount, :created_at, :interest_rate],
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
          methods: [:file_icon_url, :class_name, :owner_name]
        }
      }
    }
  end

  def borrower_list_json_options
    {
      include: {
        borrower_documents: {
          methods: [:file_icon_url, :class_name, :owner_name]
        }
      }
    }
  end

  def property_list_json_options
    {
      include: {
        property_documents: {
          methods: [:file_icon_url, :class_name, :owner_name]
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
          methods: [:file_icon_url, :class_name]
        }
      }
    }
  end
end