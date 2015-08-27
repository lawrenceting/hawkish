json.array!(@modifications) do |modification|
  json.extract! modification, :id, :date, :content, :Tracker_id
  json.url modification_url(modification, format: :json)
end
