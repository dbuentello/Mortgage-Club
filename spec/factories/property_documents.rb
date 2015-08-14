FactoryGirl.define do
  factory :property_document do |f|
    f.type {[
      'AppraisalReport', 'FloodZoneCertification', 'PurchaseAgreement', 'TermiteReport',
      'HomeownersInsurance','MortgageStatement', 'InspectionReport', 'LeaseAgreement',
      'TitleReport', 'RiskReport'
    ].sample}

    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
    f.owner { build(:user) }

    factory :appraisal_report, class: 'AppraisalReport' do
      type { 'AppraisalReport' }
    end

    factory :homeowners_insurance , class: 'HomeownersInsurance'do
      type { 'HomeownersInsurance' }
    end

    factory :mortgage_statement, class: 'MortgageStatement' do
      type { 'MortgageStatement' }
    end

    factory :lease_agreement, class: 'LeaseAgreement' do
      type { 'LeaseAgreement' }
    end

    factory :purchase_agreement, class: 'PurchaseAgreement' do
      type { 'PurchaseAgreement' }
    end

    factory :flood_zone_certification , class: 'FloodZoneCertification'do
      type { 'FloodZoneCertification' }
    end

    factory :termite_report, class: 'TermiteReport' do
      type { 'TermiteReport' }
    end

    factory :inspection_report, class: 'InspectionReport' do
      type { 'InspectionReport' }
    end

    factory :title_report, class: 'TitleReport' do
      type { 'TitleReport' }
    end

    factory :risk_report , class: 'RiskReport'do
      type { 'RiskReport' }
    end

    factory :other_property_report, class: 'OtherPropertyReport' do
      description { Faker::Lorem.word }
      type { 'OtherPropertyReport' }
    end
  end
end
