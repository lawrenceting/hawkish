json.array!(@updates) do |tracker|
  json.extract! tracker, :created_at, :content
end