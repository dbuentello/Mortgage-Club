class DashboardController < ApplicationController
  def show
    borrower = current_user.borrower
    # TODO: select loan by params[:loan_id] when we build multi dashboards.
    loan = current_user.loans.first
    property =  loan.property

    bootstrap(
      doc_list: borrower.documents.as_json(doc_list_json_option),
      address: borrower.display_current_address,
      loan: loan.as_json(loan_json_options),
      contact_list: contact_json_options,
      property_list: property_json_options
    )

    respond_to do |format|
      format.html { render template: 'client_app' }
    end
  end

  private

  def property_json_options
    [
      {
        file: {
          name: 'sample_file.doc',
          thumbnail: 'http://tinyurl.com/prj3bcx'
        },
        owner: 'Mortgage Club',
        kind: 'Upload AVE Valuation',
        modified_at: '2015-01-08'
      },
      {
        file: {
          name: 'redbell_cma.csv',
          thumbnail: 'http://tinyurl.com/oldhgjj'
        },
        owner: 'Mortgage Club',
        kind: 'Upload CMA / BPO',
        modified_at: '2015-02-08'
      },
      {
        file: {
          name: 'Quick_valuation.csv',
          thumbnail: 'http://tinyurl.com/oldhgjj'
        },
        owner: 'Mortgage Club',
        kind: 'Upload Lending Home',
        modified_at: '2015-01-09'
      },
      {
        file: {
          name: 'Final_valuation.doc',
          thumbnail: 'http://tinyurl.com/prj3bcx'
        },
        owner: 'Mortgage Club',
        kind: 'Upload Lending Home',
        modified_at: '2015-01-09'
      },
    ]
  end

  def contact_json_options
    [
      {
        name: 'Michael Gifford',
        title: 'Relationship Manager',
        email: 'michael@gmail.com',
        avatar_url: 'http://tinyurl.com/7mclx3d'
      },
      {
        name: 'Jerry Williams',
        title: 'Loan Analyst',
        email: 'jerry@gmail.com',
        avatar_url: 'http://tinyurl.com/7mclx3d'
      },
      {
        name: 'Kristina Rendon',
        title: 'Insurance',
        email: 'kristina@gmail.com',
        avatar_url: 'http://tinyurl.com/7mclx3d'
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
      methods: [:name, :url]
    }
  end
end