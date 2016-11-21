class LoanMembers::MessagesPresenter
  def initialize(messages)
    @messages = messages
  end

  def show
    @messages.as_json(json_options)
  end

  private

  def json_options
    {

    }
  end
end
