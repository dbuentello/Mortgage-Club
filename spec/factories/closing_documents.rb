FactoryGirl.define do
  factory :closing_document do |f|
    f.type {[
      'ClosingDisclosure', 'DeedOfTrust', 'LoanDoc'
    ].sample}

    f.attachment File.new(Rails.root.join 'spec', 'files', 'sample.png')
    f.owner { build(:user) }
    f.token { Faker::Lorem.characters(10) }

    factory :closing_disclosure, class: 'ClosingDisclosure' do
      type { 'ClosingDisclosure' }
    end

    factory :deed_of_trust , class: 'DeedOfTrust'do
      type { 'DeedOfTrust' }
    end

    factory :loan_doc, class: 'LoanDoc' do
      type { 'LoanDoc' }
    end

    factory :other_closing_report, class: 'OtherClosingReport' do
      description { Faker::Lorem.word }
      type { 'OtherClosingReport' }
    end
  end
end
