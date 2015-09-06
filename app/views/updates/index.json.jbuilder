json.array!(@updates) do |update|
  json.extract! update, :id, :date, :content, :tracker_id
  json.url update_url(update, format: :json)
end
