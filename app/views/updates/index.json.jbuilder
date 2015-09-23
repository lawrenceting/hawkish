json.array!(@updates) do |update|
  json.extract! update, :id, :created_at, :content, :tracker_id
  json.url update_url(update, format: :json)
end
