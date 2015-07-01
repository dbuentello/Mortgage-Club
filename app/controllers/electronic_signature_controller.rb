class ElectronicSignatureController < ApplicationController

  # POST
  def demo
    base = Docusign::Base.new
    response = base.create_envelope_from_template(
      template_name: "Loan Estimation",
      email_subject: "Electronic Signature Request from Mortgage Club",
      email_body: "As discussed, let's finish our contract by signing to this envelope. Thank you!",
      user: {
        name: current_user.to_s,
        email: current_user.email
      },
      values: {
        phone: current_user.borrower.phone
      }
    )

    redirect_to :back
  end

end
