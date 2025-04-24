Address = Struct.new(:address1, :city, :state, :zip) do
  include ActiveModel::Validations
  validates *members, presence: true

  def initialize(*a, **b)
    super
    validate!
  end

  alias each each_pair
end
