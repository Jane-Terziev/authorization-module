require 'spec_helper'

RSpec.describe AuthorizationModule::PolicyEnforcer, type: :unit do
  subject(:policy_enforcer) do
    described_class.new
  end

  describe '#action_allowed?(action, resource_type, user, context)' do
    let(:user)          { spy(AuthorizationModule::Models::Identity.name) }
    let(:action)        { 'show' }
    let(:resource_type) { 'Client::SomeStuff' }
    let(:context) { {} }

    context 'when user has a permission that denies the action' do
      before do
        permissions = [
            instance_double('AuthorizationModule::Models::Permission', allows_on_resource?: true, denies?: false, denies_on_resource?: false),
            instance_double('AuthorizationModule::Models::Permission', denies?: true, allows_on_resource?: false, denies_on_resource?: true)
        ]
        allow(user).to receive(:hierarchical_permissions) { [permissions] }
        allow(user).to receive(:permissions) { permissions }
      end

      it 'returns false' do
        expect(policy_enforcer.action_allowed?(action, resource_type, user, context)).to be false
      end
    end

    context 'when user has a permission that allows the action' do
      before do
        permissions = [
            instance_double('AuthorizationModule::Models::Permission', allows_on_resource?: true, denies_on_resource?: false)
        ]
        allow(user).to receive(:hierarchical_permissions) { [permissions] }
        allow(user).to receive(:permissions) { permissions }
      end

      it 'returns true' do
        expect(policy_enforcer.action_allowed?(action, resource_type, user, context)).to be true
      end
    end

    context 'when user has no permission that either allows or denies the action' do
      before do
        permissions = [
            instance_double('AuthorizationModule::Models::Permission', allows_on_resource?: false, denies_on_resource?: false),
            instance_double('AuthorizationModule::Models::Permission', denies_on_resource?: false, allows_on_resource?: false)
        ]
        allow(user).to receive(:hierarchical_permissions) { [permissions] }
        allow(user).to receive(:permissions) { permissions }
      end

      it 'returns false' do
        expect(policy_enforcer.action_allowed?(action, resource_type, user, context)).to be false
      end
    end

    context 'when a role further down the hierarchical tree denies an action that a higher role allows' do
      before do
        priority_permission =
            instance_double('higher_priority_permission', allows_on_resource?: true, denies_on_resource?: false)

        lower_priority_permission =
            instance_double('lower_priority_permission', denies_on_resource?: true, allows_on_resource?: false)

        allow(user).to receive(:hierarchical_permissions) { [[priority_permission], [lower_priority_permission]] }
      end

      it 'allows the action' do
        expect(policy_enforcer.action_allowed?(action, resource_type, user, context)).to be true
      end
    end

    context 'when a role further down the hierarchical tree allows an action that a higher role denies' do
      before do
        priority_permission =
            instance_double('higher_priority_permission', allows_on_resource?: false, denies_on_resource?: true)

        lower_priority_permission =
            instance_double('lower_priority_permission', denies_on_resource?: false, allows_on_resource?: true)

        allow(user).to receive(:hierarchical_permissions) { [[priority_permission], [lower_priority_permission]] }
      end

      it 'denies the action' do
        expect(policy_enforcer.action_allowed?(action, resource_type, user, context)).to be false
      end
    end
  end
end
