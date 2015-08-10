class DashboardController < ApplicationController
  before_action :set_loan, only: [:show]

  def show
    borrower = current_user.borrower
    # TODO: select loan by params[:loan_id] when we build multi dashboards.
    loan = @loan
    property =  loan.property
    bootstrap(
      address: property.address.try(:address),
      loan: loan.as_json(loan_json_options),
      borrower_list: borrower.as_json(borrower_list_json_options),
      contact_list: contact_list_json_options,
      property_list: property.as_json(property_list_json_options),
      loan_list: loan.as_json(loan_list_json_options),
      loan_activities: loan.loan_activities.includes(loan_member: :user).order(updated_at: :desc).limit(10).as_json
    )

    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  private

  def loan_list_json_options
    {
      include: {
        loan_documents: {
          methods: [:file_icon_url, :class_name]
        }
      }
    }
  end

  def property_list_json_options
    {
      include: {
        property_documents: {
          methods: [:file_icon_url, :class_name]
        }
      }
    }
  end

  def contact_list_json_options
    [
      {
        name: 'Michael Gifford',
        title: 'Relationship Manager',
        email: 'michael@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      },
      {
        name: 'Jerry Williams',
        title: 'Loan Analyst',
        email: 'jerry@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      },
      {
        name: 'Kristina Rendon',
        title: 'Insurance',
        email: 'kristina@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      }
    ]
  end

  def loan_json_options
    {
      include: {
        property: {
          include: :address,
          methods: :usage_name
        }
      },
      methods: [
        :num_of_years, :ltv_formula, :purpose_titleize
      ]
    }
  end

  def borrower_list_json_options
    {
      include: {
        borrower_documents: {
          include: {
            owner: {
              only: [:first_name]
            }
          },
          methods: [:file_icon_url, :class_name]
        }
      }
    }
  end
end