module AuthorizationModule
  module Abac
    class ConditionSerializer
      def self.load(json)
        json ? (json.is_a?(String) ? JSON.parse(json) : json) : []
      end

      def self.dump(conditions)
        conditions.to_json
      end
    end
  end
end
