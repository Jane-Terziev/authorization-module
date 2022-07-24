module AuthorizationModule
  module Models
    module Abac
      class Condition
        attr_reader :subject_attribute, :resource_attribute, :expression

        def self.from_json(json)
          new(json['subject'], json['resource'], json['expression'])
        end

        def initialize(subject_attribute, resource_attribute, expression)
          self.subject_attribute  = subject_attribute
          self.resource_attribute = resource_attribute
          self.expression = expression # validate valid boolean operator
        end

        def satisfied_by?(subject, resource)
          parsed = expression % { subject: subject.public_send(subject_attribute), resource: resource.public_send(resource_attribute) }
          eval(parsed)
        end

        def as_json(_options = {})
          {
              'subject'    => subject_attribute,
              'resource'   => resource_attribute,
              'expression' => expression
          }
        end

        private

        attr_writer :subject_attribute, :resource_attribute, :expression
      end
    end
  end
end
