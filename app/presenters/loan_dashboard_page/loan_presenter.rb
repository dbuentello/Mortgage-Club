class LoanDashboardPage::LoanPresenter
  def initialize(loan)
    @loan = loan
  end

  def show
    @loan.as_json(json_options)
  end

  private

  def json_options
    {
      only: [
        :id,
        :amount,
        :created_at,
        :interest_rate,
        :amortization_type,
        :down_payment,
        :estimated_cash_to_close,
        :loan_costs,
        :third_party_fees,
        :monthly_payment,
        :lender_credits,
        :estimated_prepaid_items,
        :lender_underwriting_fee,
        :appraisal_fee,
        :tax_certification_fee,
        :flood_certification_fee,
        :outside_signing_service_fee,
        :concurrent_loan_charge_fee,
        :endorsement_charge_fee,
        :lender_title_policy_fee,
        :recording_service_fee,
        :settlement_agent_fee,
        :recording_fees,
        :owner_title_policy_fee,
        :prepaid_item_fee,
        :prepaid_homeowners_insurance,
        :cash_out,
        :lender_name,
        :updated_rate_time,
        :is_rate_locked,
        :rate_lock_expiration_date
      ],
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
        subject_property: {
          methods: :usage_name
        },
        borrower: {
          only: [:id],
          include: [
            :documents,
            user: {
              only: [:email]
            }
          ]
        },
        secondary_borrower: {
          only: [:id],
          include: [
            :documents,
            user: {
              only: [:first_name],
              methods: [:to_s]
            }
          ]
        },
        closing: {
          only: [:id]
        }
      },
      methods: [
        :num_of_years, :purpose_titleize, :subject_property, :pretty_status
      ]
    }
  end
end
