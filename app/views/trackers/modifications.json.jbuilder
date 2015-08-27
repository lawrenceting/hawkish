json.array!(@modifications) do |tracker|
  json.extract! tracker, :date, :content
end