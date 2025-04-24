# webmock patch. webmock sets rack.session to {}, which blows up rails as rails
# needs a session object.
# https://github.com/bblimke/webmock/issues/985
module WebmockPatch
  def build_rack_env(*)
    super.tap {
      _1.delete('rack.session') || raise("delete this patch:#{__FILE__}:#{__LINE__}")
      _1.delete('rack.session.options')
    }
  end
end
WebMock::RackResponse.prepend(WebmockPatch)
