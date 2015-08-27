json.array!(@trackers) do |tracker|
  json.extract! tracker, :id, :url, :nodes, :content
  json.url tracker_url(tracker, format: :json)
end
