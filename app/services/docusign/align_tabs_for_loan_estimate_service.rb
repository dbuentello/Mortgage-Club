module Docusign
  class AlignTabsForLoanEstimateService
    HEADER_TABS = %w(
     date_issued applicant_name applicant_address property sale_price
     loan_term purpose product loan_type_conventional loan_type_fha
     loan_type_va loan_type_other loan_type_other_text loan_id rate_lock_no
     rate_lock_yes rate_lock_text
    )

    LOAN_TERM_TABS = %w(
      loan_amount loan_amount_increase interest_rate interest_rate_increase
      monthly_principal_interest monthly_principal_interest_increase
      monthly_principal_interest prepayment_penalty prepayment_penalty_text
      balloon_payment balloon_payment_text
    )

    PROJECTED_PAYMENTS_TABS = %w(
      payment_calculation_text_1
      payment_calculation_text_2 projected_principal_interest_1
      projected_principal_interest_2 projected_mortgage_insurance_1 projected_mortgage_insurance_2
      estimated_escrow_1 estimated_escrow_2 estimated_total_monthly_payment_1 estimated_total_monthly_payment_2
      estimated_taxes_insurance_assessments estimated_taxes_insurance_assessments_text
      include_property_taxes include_homeowners_insurance include_other include_other_text
      in_escrow_property_taxes in_escrow_homeowners_insurance in_escrow_other
    )

    COSTS_AT_CLOSING_TABS = %w(
      estimated_closing_costs loan_costs other_costs lender_credits
    )

    LOAN_COSTS_TABS = %w(
      points application_fee underwriting_fee
      services_cannot_shop_total appraisal_fee credit_report_fee flood_determination_fee
      flood_monitoring_fee tax_monitoring_fee tax_status_research_fee services_can_shop_total
      pest_inspection_fee survey_fee insurance_binder lenders_title_policy settlement_agent_fee
      title_search
      points_text application_fee_text underwriting_fee_text appraisal_fee_text credit_report_fee_text
      flood_determination_fee_text flood_monitoring_fee_text tax_monitoring_fee_text tax_status_research_fee_text
      pest_inspection_fee_text survey_fee_text insurance_binder_text lenders_title_policy_text
      settlement_agent_fee_text title_search_text
    )

    OTHER_COSTS_TABS = %w(
      taxes_and_other_government_fees_total recording_fees_and_other_taxes transfer_taxes
      prepaids_total homeowners_insurance_premium mortgage_insurance_premium prepaid_interest
      prepaid_property_taxes intial_escrow_payment_total initial_homeowner_insurance
      initial_mortgage_insurance initial_property_taxes other_total owner_title_policy lender_credits
      homeowners_insurance_premium_months mortgage_insurance_premium_months prepaid_interest_per_day
      prepaid_interest_days prepaid_interest_rate prepaid_property_taxes_months
      initial_homeowner_insurance_per_month initial_homeowner_insurance_months
      intial_mortgage_insurance_per_month initial_mortgage_insurance_months
      initial_property_taxes_per_month initial_property_taxes_months
    )

    TOTAL_COSTS_TABS = %w(
      total_other_costs total_closing_costs total_loan_costs_and_other_costs
    )

    CALCULATING_CASH_TO_CLOSE_TABS = %w(
      total_closing_costs closing_costs_financed down_payment deposit
      funds_for_borrower seller_credits adjustments_and_other_credits
    )

    ADDITIONAL_INFORMATION_TABS = %w(
      lender_name lender_nmls_id loan_officer_name_1 loan_officer_nmls_id_1
      loan_officer_email_1 loan_officer_phone_1
      mortgage_broker_name mortgage_broker_nmls_id loan_officer_name_2
      loan_officer_nmls_id_2 loan_officer_email_2 loan_officer_phone_2
    )

    COMPARISONS_TABS = %w(
      in_5_years_total in_5_years_principal annual_percentage_rate total_interest_percentage
    )

    CONSIDERATIONS_TABS = %w(
      assumption_will_allow assumption_will_not_allow late_days
      late_fee_text servicing_service servicing_transfer
    )

    def initialize(tabs)
      @tabs = tabs
    end

    def call
      @tabs[:text_tabs].each_with_index do |field, index|
        case field[:name]
        when *HEADER_TABS
          align_header_tabs(field)
        when *LOAN_TERM_TABS
          align_loan_term_tabs(field)
        when *PROJECTED_PAYMENTS_TABS
          align_projected_payments_tabs(field)
        when *COSTS_AT_CLOSING_TABS
          align_costs_at_closing_tabs(field)
        when *LOAN_COSTS_TABS
          align_loan_costs_tabs(field)
        when *OTHER_COSTS_TABS
          align_other_costs_tabs(field)
        when *TOTAL_COSTS_TABS
          align_total_costs_tabs(field)
        when *CALCULATING_CASH_TO_CLOSE_TABS
          align_calculating_cash_to_clos_tabs(field)
        when *ADDITIONAL_INFORMATION_TABS
          align_additional_information_tabs(field)
        when *COMPARISONS_TABS
          align_comparisons_tabs(field)
        when *CONSIDERATIONS_TABS
          align_considerations_tabs(field)
        when *%w(loan_costs_total origination_charges_total)
          field[:x_position] = 220
        end
      end
      @tabs
    end

    private

    def align_header_tabs(field)
      case field[:name]
      when *%w(date_issued applicant_name applicant_address property sale_price)
        field[:x_position] = 92
      when *%w(loan_term purpose product)
        field[:x_position] = 350
      when *%w(loan_type_conventional loan_type_fha loan_type_va loan_type_other loan_type_other_text)
        field[:y_position] = 116
      when *%w(rate_lock_no rate_lock_yes rate_lock_text)
        field[:y_position] = 140
        field[:x_position] = 351 if field[:name] == 'rate_lock_no'
        field[:x_position] = 379 if field[:name] == 'rate_lock_yes'
      end
    end

    def align_loan_term_tabs(field)
      case field[:name]
      when *%w(loan_amount interest_rate monthly_principal_interest monthly_principal_interest)
        field[:x_position] = 194
      when *%w(loan_amount_increase interest_rate_increase monthly_principal_interest_increase prepayment_penalty prepayment_penalty)
        field[:x_position] = 301
      when *%w(prepayment_penalty_text balloon_payment_text)
        field[:x_position] = 333
      end
    end

    def align_projected_payments_tabs(field)
      case field[:name]
      when *%w(
              payment_calculation_text_1 projected_principal_interest_1
              projected_mortgage_insurance_1 estimated_escrow_1
              estimated_total_monthly_payment_1 estimated_taxes_insurance_assessments
              estimated_taxes_insurance_assessments_text
            )
        field[:x_position] = 194
      when *%w(payment_calculation_text_2 projected_principal_interest_2 projected_mortgage_insurance_2 estimated_escrow_2 estimated_total_monthly_payment_2)
        field[:x_position] = 387
      when *%w(include_property_taxes include_homeowners_insurance include_other)
        field[:x_position] = 279
      when *%w(in_escrow_property_taxes in_escrow_homeowners_insurance in_escrow_other)
        field[:x_position] = 467
      end
    end

    def align_costs_at_closing_tabs(field)
      case field[:name]
      when "estimated_closing_costs"
        field[:x_position] = 194
      when *%w(loan_costs other_costs)
        field[:y_position] = 684
        field[:x_position] = 294 if field[:name] == "loan_costs"
        field[:x_position] = 388 if field[:name] == "other_costs"
      end
    end

    def align_loan_costs_tabs(field)
      case field[:name]
      when *%w(
              origination_charges_total points application_fee underwriting_fee services_cannot_shop_total
              appraisal_fee credit_report_fee flood_determination_fee flood_monitoring_fee
              tax_monitoring_fee tax_status_research_fee services_can_shop_total
              pest_inspection_fee survey_fee insurance_binder settlement_agent_fee
              title_search loan_costs_total
            )
        field[:x_position] = 240
      when *%w(
              points_text application_fee_text underwriting_fee_text appraisal_fee_text
              credit_report_fee_text flood_determination_fee_text flood_monitoring_fee_text
              tax_monitoring_fee_text tax_status_research_fee_text pest_inspection_fee_text
              survey_fee_text insurance_binder_text lenders_title_policy_text
              settlement_agent_fee_text title_search_text
            )
        field[:x_position] = 43
      end
    end

    def align_other_costs_tabs(field)
      if %w(
              taxes_and_other_government_fees_total recording_fees_and_other_taxes transfer_taxes
              prepaids_total homeowners_insurance_premium mortgage_insurance_premium
              prepaid_interest prepaid_property_taxes intial_escrow_payment_total initial_homeowner_insurance
              initial_mortgage_insurance initial_property_taxes other_total owner_title_policy
            ).include? field[:name]
        field[:x_position] = 527
      end

      case field[:name]
      when *%w(homeowners_insurance_premium homeowners_insurance_premium_months)
        field[:y_position] = 144
      when *%w(mortgage_insurance_premium_months mortgage_insurance_premium)
        field[:y_position] = 154
      when *%w(prepaid_interest_per_day prepaid_interest_days prepaid_interest_rate prepaid_interest)
        field[:y_position] = 166
        field[:x_position] = 380 if field[:name] == 'prepaid_interest_per_day'
        field[:x_position] = 454 if field[:name] == 'prepaid_interest_days'
      when *%w(prepaid_property_taxes_months prepaid_property_taxes)
        field[:y_position] = 177
      when *%w(initial_homeowner_insurance_per_month initial_homeowner_insurance_months initial_homeowner_insurance)
        field[:y_position] = 236
      when *%w(intial_mortgage_insurance_per_month initial_mortgage_insurance_months initial_mortgage_insurance)
        field[:y_position] = 246
      when *%w(initial_property_taxes_per_month initial_property_taxes_months initial_property_taxes)
        field[:y_position] = 257
      when *%w(owner_title_policy_text owner_title_policy)
        field[:y_position] = 341
      end
    end

    def align_total_costs_tabs(field)
      field[:x_position] = 496
      if %w(lenders_title_policy total_loan_costs_and_other_costs).include? field[:name]
        field[:y_position] = 441
      end
    end

    def align_calculating_cash_to_clos_tabs(field)
      field[:x_position] = 530
    end

    def align_additional_information_tabs(field)
      case field[:name]
      when *%w(
              lender_name lender_nmls_id loan_officer_name_1 loan_officer_nmls_id_1
              loan_officer_email_1 loan_officer_phone_1
            )
        field[:x_position] = 127
      when *%w(
              mortgage_broker_name mortgage_broker_nmls_id loan_officer_name_2
              loan_officer_nmls_id_2 loan_officer_email_2 loan_officer_phone_2
            )
        field[:x_position] = 429
      end
    end

    def align_comparisons_tabs(field)
      field[:x_position] = 192
    end

    def align_considerations_tabs(field)
      case field[:name]
      when *%w(late_days late_fee_text_top)
        field[:y_position] = 495
      when 'late_fee_text_bottom'
        field[:y_position] = 479
        field[:x_position] = 165
      else
        field[:x_position] = 165
      end
    end
  end
end
