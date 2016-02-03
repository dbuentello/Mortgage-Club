class Admins::BorrowersPresenter
  def initialize(borrowers)
    @borrowers = borrowers
  end

  def show
    @borrowers.as_json(json_options)
  end

  private

  def json_options
    {
      include: {
        user: {
          only: [ :id, :email],
          methods: [ :full_name ]
        }
      }
    }
  end
end
