class ChecklistsPresenter
  def self.index(checklists)
    checklists.includes(:user).as_json(checklist_json_options)
  end

  def self.show(checklist)
    checklist.as_json(checklist_json_options)
  end

  private

  def self.checklist_json_options
    {
      include: {
        loan: {
          only: [:id]
        },
        user: {
          methods: [:to_s, :avatar_url, :role_name]
        }
      },
      methods: [:document_info]
    }
  end
end
