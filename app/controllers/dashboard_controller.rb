class DashboardController < ApplicationController
  before_action :set_loan, only: [:show]

  def show
    borrower = current_user.borrower

    # TODO: select loan by params[:loan_id] when we build multi dashboards.
    loan = Loan.first
    property =  loan.property
    # byebug
    bootstrap(
      doc_list: borrower.documents.as_json(doc_list_json_option),
      address: borrower.display_current_address,
      loan: loan.as_json(loan_json_options),
      contact_list: contact_list_json_options,
      property_list: property.as_json(property_list_json_options),
      loan_list: loan.as_json(loan_list_json_options),
      loan_activities: loan.loan_activities.as_json
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

  def doc_list_json_option
    {
      only: [:id],
      methods: [:name, :file_icon_url]
    }
  end
end