module AuthorizationModule
  module Abac
    class NullAttributeProvider
      def attributes_by_id(_id)
        OpenStruct.new
      end
    end
  end
end
