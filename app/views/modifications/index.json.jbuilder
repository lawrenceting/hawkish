json.array!(@modifications) do |modification|
  json.extract! modification, :id, :date, :content, :tracker_id
  json.url modification_url(modification, format: :json)
end
