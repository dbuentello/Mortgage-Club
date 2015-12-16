require "rails_helper"

describe SubmitApplicationToLenderService do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:staff) { FactoryGirl.create(:user) }
  let!(:lender_document) { FactoryGirl.create(:lender_document, loan: loan) }

  describe "#call" do
    context "when params are valid" do
      before(:each) { allow(Amazon::GetUrlService).to receive(:call).and_return("http://example.com") }

      it "returns true" do
        expect(described_class.new(loan, staff).call).to be_truthy
      end

      it "calls LoanMemberMailer with proper params" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)

        expect(LoanMemberMailer).to receive(:submit_application).with({
          documents_info: [{url: "http://example.com", file_name: lender_document.lender_template.name << File.extname(lender_document.attachment_file_name)}],
          templates_name: loan.lender.lender_templates.where(is_other: false).pluck(:description),
          lender_name: loan.lender.name,
          lender_email: loan.lender.lock_rate_email,
          loan_member_name: staff.to_s,
          loan_member_email: "#{staff.to_s} <#{staff.email}>",
          client_name: loan.borrower.user.to_s,
          loan_id: loan.id
        }).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        described_class.new(loan, staff).call
      end

      context "with other template" do
        let(:second_lender_document) { FactoryGirl.create(:lender_document, loan: loan) }
        let!(:requirement) { FactoryGirl.create(:lender_template_requirement, lender: loan.lender, lender_template: second_lender_document.lender_template) }

        it "returns proper templates name" do
          second_lender_document.lender_template.update(is_other: true)
          message_delivery = instance_double(ActionMailer::MessageDelivery)

          expect(LoanMemberMailer).to receive(:submit_application).with({
            documents_info: [
              {url: "http://example.com", file_name: lender_document.lender_template.name + File.extname(lender_document.attachment_file_name)},
              {url: "http://example.com", file_name: second_lender_document.description + File.extname(second_lender_document.attachment_file_name)}
            ],
            templates_name: loan.lender.lender_templates.where(is_other: false).pluck(:description) << second_lender_document.description,
            lender_name: loan.lender.name,
            lender_email: loan.lender.lock_rate_email,
            loan_member_name: staff.to_s,
            loan_member_email: "#{staff.to_s} <#{staff.email}>",
            client_name: loan.borrower.user.to_s,
            loan_id: loan.id
          }).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          described_class.new(loan, staff).call
        end
      end
    end

    context "when loan is missing" do
      before(:each) { @service = described_class.new(nil, staff) }

      it "returns false" do
        expect(@service.call).to be_falsey
      end

      it "returns an error message" do
        @service.call
        expect(@service.error_message).to eq("Loan is missing")
      end
    end

    context "when staff is missing" do
      before(:each) { @service = described_class.new(loan, nil) }

      it "returns false" do
        expect(@service.call).to be_falsey
      end

      it "returns an error message" do
        @service.call
        expect(@service.error_message).to eq("Don't know who is in charge of this loan")
      end
    end

    context "when lender is missing" do
      before(:each) { @service = described_class.new(loan, staff) }

      it "returns false" do
        loan.lender = nil
        expect(@service.call).to be_falsey
      end

      it "returns an error message" do
        loan.lender = nil
        @service.call
        expect(@service.error_message).to eq("Loan does not belong to any lenders")
      end
    end

    context "when documents are incomplete" do
      before(:each) { @service = described_class.new(loan, staff) }

      it "returns an error message" do
        loan.lender_documents.destroy_all
        @service.call
        expect(@service.error_message).to eq("Loan is not provided adequate documents")
      end
    end
  end

  describe "#documents_are_incomlete?" do
    context "when lender documents are missing" do
      it "returns false" do
        loan.lender_documents.destroy_all
        expect(described_class.new(loan, staff).documents_are_incomlete?).to be_truthy
      end
    end

    context "when lender documents are complete" do
      it "returns true" do
        expect(described_class.new(loan, staff).documents_are_incomlete?).to be_falsey
      end

      context "when other lender document is missing" do
        let(:other_lender_document) { FactoryGirl.create(:lender_document, loan: loan) }
        let!(:requirement) { FactoryGirl.create(:lender_template_requirement, lender: loan.lender, lender_template: other_lender_document.lender_template) }

        it "does not care other lender document and returns false" do
          other_lender_document.lender_template.update(is_other: true)
          expect(described_class.new(loan, staff).documents_are_incomlete?).to be_falsey
        end
      end
    end
  end
end
