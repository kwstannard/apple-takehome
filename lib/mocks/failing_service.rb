module Mocks
  FailingService = ->(env) { [500, {}, ["my failure"]] }
end
