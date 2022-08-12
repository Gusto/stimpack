# frozen_string_literal: true

require "active_support"
require "pathname"
require "rails"

module Stimpack
  module Packs
    class << self
      def root
        @root ||= Rails.root.join(Stimpack.config.root)
      end

      def resolve
        # Gather all the parent packs and the children packs.
        package_locations = root.glob('*/{package.yml,*/package.yml}').map(&:dirname)
        package_locations.sort!.each do |path|
          next unless pack = Pack.create(path)
          @packs[pack.name] = pack
        end
        @packs.freeze
      end

      def find(path)
        path = "#{path}/"

        @packs.values.find do |pack|
          path.start_with?("#{pack.path}/")
        end
      end

      def [](name)
        @packs[name]
      end

      def each(*args, &block)
        @packs.each_value(*args, &block)
      end
    end

    @packs = {}
  end
end
