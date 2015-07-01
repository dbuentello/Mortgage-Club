class ElectronicSignatureController < ApplicationController

  # POST
  def demo
    base = Docusign::Base.new

    # Set values to tab labels
    # NOTE: need to map 2 names carefully (for example "Phone" will take value from :phone)
    # the JS name is from 'tooltip' of field in the template
    values = {
      "Your phone number" => current_user.borrower.phone
    }

    response = base.create_envelope_from_template(
      template_name: "Loan Estimation",
      email_subject: "Electronic Signature Request from Mortgage Club",
      email_body: "As discussed, let's finish our contract by signing to this envelope. Thank you!",
      user: {
        name: current_user.to_s,
        email: current_user.email
      },
      values: values
    )

    redirect_to :back
  end

end
