class BadRequestError < RuntimeError
  def initialize(message = '')
    super message
  end
end
