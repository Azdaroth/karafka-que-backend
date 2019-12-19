# frozen_string_literal: true

module Karafka
  module Extensions
    module QueAttributesMap
      module ClassMethods
        def topic
          (super + %i[interchanger worker]).uniq
        end
      end

      def self.prepended(base)
        base.singleton_class.prepend(ClassMethods)
      end
    end
  end
end
