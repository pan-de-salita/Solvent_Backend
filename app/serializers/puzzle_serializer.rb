class PuzzleSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :start_date, :end_date, :updated_at
end
