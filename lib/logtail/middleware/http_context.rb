# frozen_string_literal: true

# Extracted from Logtail Ruby Rack gem
# https://github.com/logtail/logtail-ruby-rack

require "logtail/middleware"
require "logtail/util/request"
require "logtail/util/encoding"
require "logtail/current_context"

module Logtail
  module Integrations
    class HttpContext < Middleware
      def call(env)
        print("\n --- CALL HTTP CONTEXT\n\n")

        request = Util::Request.new(env)
        context = Contexts::Http.new(
          host: Util::Encoding.force_utf8_encoding(request.host),
          method: Util::Encoding.force_utf8_encoding(request.request_method),
          path: request.path,
          remote_addr: Util::Encoding.force_utf8_encoding(request.ip),
          request_id: request.request_id
        )

        CurrentContext.with(context.to_hash) do
          @app.call(env)
        end
      end
    end
  end
end
