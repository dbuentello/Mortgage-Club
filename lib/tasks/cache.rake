namespace :cache do
  desc "Clear cache of Docusign's templates and update them"
  task clear_cache_and_update_docusign_templates: :environment do
    Template.all.each do |template|
      p template.name
      cache_key = "Docusign - Template #{template.docusign_id}"
      recipients = DocusignRest::Client.new.get_envelope_recipients(envelope_id: template.docusign_id, include_tabs: true)
      REDIS.set(cache_key, recipients.to_json)
      REDIS.expire(cache_key, 30.day.to_i)
    end
  end
end
