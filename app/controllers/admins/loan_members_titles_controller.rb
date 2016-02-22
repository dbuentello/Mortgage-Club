class Admins::LoanMembersTitlesController <  Admins::BaseController
  def index
    loan_members_titles = LoanMembersTitle.all

    bootstrap(
      loan_members_titles: loan_members_titles
    )
    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end
end