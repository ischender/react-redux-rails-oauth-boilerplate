require "rails_helper"

describe User::Authenticate do
  describe 'with access_token' do
    describe "access_token matches no user"  do
      let(:params){ {'access_token' => JsonWebToken.encode({'user_id' => SecureRandom.uuid})}}
      it 'raises an error' do
        expect{ User::Authenticate.call(params) }.to raise_error "oauth_access_token missing"
      end
    end

    describe 'access_token matches user' do
      let(:user){ User.create() }
      let(:params){ {'access_token' => JsonWebToken.encode({'user_id' => user.id}) }}
      it 'find and returns the user' do
        result = User::Authenticate.call(params)
        expect(result['model'].id).to eq(user.id)
      end
    end
  end

  describe 'with oauth_access_token and provider' do
    describe 'oauth provider missing' do
      let(:params){ {'oauth_access_token' => 'XXXX'} }
      it 'raises an error' do
        expect{ User::Authenticate.call(params) }.to raise_error "oauth provider missing"
      end
    end

    describe 'with provider' do
      let(:params){ {'oauth_access_token' => 'XXXX', 'provider' => 'facebook'} }
      it 'calls FacebookApi and creates a user, sets user#display_name' do
        allow(FacebookApi)
          .to receive(:resolve_user)
          .and_return({"name"=>"Tom", "id"=>"123"})
        result = User::Authenticate.call(params)
        expect(result['model'].auths['facebook']).to eq({"name"=>"Tom", "id"=>"123"})
        expect(result['model'].profile['display_name']).to eq('Tom')
      end
    end
  end
end