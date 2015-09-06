json.array!(@updates) do |tracker|
  json.extract! tracker, :date, :content
end