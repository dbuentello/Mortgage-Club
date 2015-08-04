FactoryGirl.define do
  factory :loan_document do |f|
    f.type {[
      'HudEstimate', 'HudFinal',
      'LoanEstimate','UniformResidentialLendingApplication'
    ].sample}

    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')

    factory :hud_estimate, class: 'HudEstimate' do
      type { 'HudEstimate' }
    end

    factory :hud_final , class: 'HudFinal'do
      type { 'HudFinal' }
    end

    factory :loan_estimate, class: 'LoanEstimate' do
      type { 'LoanEstimate' }
    end

    factory :uniform_residential_lending_application, class: 'UniformResidentialLendingApplication' do
      type { 'UniformResidentialLendingApplication' }
    end
  end
end
