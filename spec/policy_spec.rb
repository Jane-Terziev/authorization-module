require 'spec_helper'

RSpec.describe AuthorizationModule::Models::Policy, type: :unit do

  describe "#.create_new(id:SecureRandom.uuid, name:, description:, resource_type:, action:, effect:)" do
    context "when creating a new policy" do
      it 'should assign all values' do
        id = SecureRandom.uuid
        name = 'name'
        description = 'description'
        resource_type = 'Client'
        action = AuthorizationModule::Models::Policy::ANY_ACTION
        effect = AuthorizationModule::Models::Policy::ALLOW
        policy = described_class.create_new(
            id:            id,
            name:          name,
            description:   description,
            resource_type: resource_type,
            action:        action,
            effect:        effect
        )
        expect(policy.id).to eq(id)
        expect(policy.name).to eq(name)
        expect(policy.description).to eq(description)
        expect(policy.resource_type).to eq(resource_type)
        expect(policy.action).to eq(action)
        expect(policy.effect).to eq(effect)
      end
    end
  end
  describe '#allows?' do
    context 'when resource is unmodulized' do
      let(:resource_type) { '::Projects' }
      let(:action)        { 'show' }

      it 'returns true when the policy allows the action for the specific resource' do
        policy = described_class.new(
          resource_type: '::Projects',
          action:        AuthorizationModule::Models::Policy::ANY_ACTION,
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be true
      end

      it 'returns true when the policy allows the action for a wildcard of resources' do
        policy = described_class.new(
          resource_type: "::#{AuthorizationModule::Models::Policy::ANY_RESOURCE_TYPE}",
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be true
      end

      it 'returns false when the policy denies the action' do
        policy = described_class.new(
          resource_type: '::JobPositions',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.allows?(action, resource_type)).to be false
      end

      it 'returns false when the policy does not match the resource type' do
        policy = described_class.new(
          resource_type: '::Unknown',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be false
      end

      it 'returns false when the policy does not match the action' do
        policy = described_class.new(
          resource_type: '::Projects',
          action:        'something_else',
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be false
      end
    end

    context 'when resource is modulized' do
      let(:resource_type) { 'Client::Projects' }
      let(:action)        { 'show' }

      it 'returns false when the policy allows the action for the specific resource' do
        policy = described_class.new(
          resource_type: '::Projects',
          action:        AuthorizationModule::Models::Policy::ANY_ACTION,
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be false
      end

      it 'returns false when the policy allows the action for a wildcard of resources' do
        policy = described_class.new(
          resource_type: "::#{AuthorizationModule::Models::Policy::ANY_RESOURCE_TYPE}",
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be false
      end

      it 'returns false when the policy denies the action' do
        policy = described_class.new(
          resource_type: 'Client::Projects',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.allows?(action, resource_type)).to be false
      end

      it 'returns false when the policy does not match the resource type' do
        policy = described_class.new(
          resource_type: 'Client::Unknown',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be false
      end

      it 'returns true when the policy allows a wildcard of resource types' do
        policy = described_class.new(
          resource_type: "Client::#{AuthorizationModule::Models::Policy::ANY_RESOURCE_TYPE}",
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be true
      end

      it 'returns true when the policy matches the resource type exactly' do
        policy = described_class.new(
          resource_type: 'Client::Projects',
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.allows?(action, resource_type)).to be true
      end
    end
  end

  describe '#denies?' do
    context 'when resource is unmodulized' do
      let(:resource_type) { '::Projects' }
      let(:action)        { 'show' }

      it 'returns true when the policy denies the action for the specific resource' do
        policy = described_class.new(
          resource_type: '::Projects',
          action:        AuthorizationModule::Models::Policy::ANY_ACTION,
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be true
      end

      it 'returns true when the policy denies the action for a wildcard of resources' do
        policy = described_class.new(
          resource_type: "::#{AuthorizationModule::Models::Policy::ANY_RESOURCE_TYPE}",
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be true
      end

      it 'returns false when the policy allows the action' do
        policy = described_class.new(
          resource_type: '::Projects',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.denies?(action, resource_type)).to be false
      end

      it 'returns false when the policy does not match the resource type' do
        policy = described_class.new(
          resource_type: '::Unknown',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be false
      end

      it 'returns false when the policy does not match the action' do
        policy = described_class.new(
          resource_type: '::Projects',
          action:        'something_else',
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be false
      end
    end

    context 'when resource is modulized' do
      let(:resource_type) { 'Client::Projects' }
      let(:action)        { 'show' }

      it 'returns false when the policy denies the action for the specific resource in a different module' do
        policy = described_class.new(
          resource_type: '::Projects',
          action:        AuthorizationModule::Models::Policy::ANY_ACTION,
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be false
      end

      it 'returns false when the policy denies the action for a wildcard of resources in a different module' do
        policy = described_class.new(
          resource_type: "::#{AuthorizationModule::Models::Policy::ANY_RESOURCE_TYPE}",
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be false
      end

      it 'returns false when the policy allows the action' do
        policy = described_class.new(
          resource_type: 'Client::Projects',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::ALLOW
        )
        expect(policy.denies?(action, resource_type)).to be false
      end

      it 'returns false when the policy does not match the resource type' do
        policy = described_class.new(
          resource_type: 'Client::Unknown',
          action:        action,
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be false
      end

      it 'returns true when the policy denies a wildcard of resource types' do
        policy = described_class.new(
          resource_type: "Client::#{AuthorizationModule::Models::Policy::ANY_RESOURCE_TYPE}",
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be true
      end

      it 'returns true when the policy matches the resource type exactly' do
        policy = described_class.new(
          resource_type: 'Client::Projects',
          action:        'show',
          effect:        AuthorizationModule::Models::Policy::DENY
        )
        expect(policy.denies?(action, resource_type)).to be true
      end
    end
  end
end
