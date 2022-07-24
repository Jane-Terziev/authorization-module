module AuthorizationModule
  module Abac
    class AttributeProviderFactory
      def initialize
        self.resource_providers = Hash.new
        self.subject_providers  = Hash.new
      end

      def resource_provider_for_type(resource_type)
        resource_provider = self.resource_providers.find { |type, _provider| resource_type.match?(type) }
        resource_provider ? resource_provider.last : NullAttributeProvider.new
      end

      def subject_provider_for_type(resource_type)
        subject_provider = self.subject_providers.find { |type, _provider| resource_type.match?(type) }
        subject_provider ? subject_provider.last : NullAttributeProvider.new
      end

      def register_resource_provider(resource_type, provider)
        self.resource_providers.store(Regexp.new(resource_type), provider)
      end

      def register_subject_provider(resource_type, provider)
        self.subject_providers.store(Regexp.new(resource_type), provider)
      end

      private

      attr_accessor :resource_providers, :subject_providers
    end
  end
end
