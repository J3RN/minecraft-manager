require 'rails_helper'

describe MainController do
  describe 'GET index' do
    it 'renders successfully' do
      get :index
      expect(response).to have_http_status(:success)
    end

    context 'user is logged in' do
      before do
        user = create(:user)
        sign_in user
      end

      it 'redirects to PhoenixesController#index' do
        get :index

        expect(response).to redirect_to(phoenixes_url)
      end
    end
  end
end
