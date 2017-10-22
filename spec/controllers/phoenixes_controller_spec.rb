describe PhoenixesController do
  before do
    @user = create(:user_with_phoenixes)
    @phoenix = @user.owned_phoenixes.first

    @user_without_access_token = create(:user)

    other_user = create(:user_with_phoenixes)
    @unowned_phoenix = other_user.owned_phoenixes.first

    sign_in @user
  end

  describe 'GET index' do
    before do
      get :index
    end

    it 'renders sucessfully' do
      expect(response).to have_http_status(:success)
    end

    it "loads the user's phoenixes" do
      expect(assigns(:phoenixes)).to eq([@phoenix])
    end
  end

  describe 'GET new' do
    context 'with access_token' do
      before do
        VCR.use_cassette('droplet fetch') do
          get :new
        end
      end

      it 'renders sucessfully' do
        expect(response).to have_http_status(:success)
      end

      it 'builds a new phoenix' do
        expect(assigns(:phoenix)).to be_a_new(Phoenix)
      end
    end

    context 'without access_token' do
      before do
        sign_out @user
        sign_in @user_without_access_token
        VCR.use_cassette('droplet fetch') do
          get :new
        end
      end

      it 'redirects back to the index' do
        expect(response).to redirect_to(phoenixes_url)
      end
    end
  end

  describe 'POST create' do
    before do
      post :create, phoenix: attributes_for(:phoenix)
    end

    it 'redirects to index' do
      expect(response).to redirect_to(phoenixes_url)
    end

    it 'sets the owner on the new phoenix' do
      expect(assigns(:phoenix).owner).to eq(@user)
    end

    it 'adds the owner to the list of users' do
      expect(assigns(:phoenix).users).to include(@user)
    end
  end

  describe 'GET edit' do
    context 'requesting owned phoenix' do
      before do
        VCR.use_cassette('droplet fetch') do
          get :edit, { id: @phoenix.id }
        end
      end

      it 'renders sucessfully' do
        expect(response).to have_http_status(:success)
      end

      it 'loads the requested phoenix' do
        expect(assigns(:phoenix)).to eq(@phoenix)
      end
    end

    context 'requesting unowned phoenix' do
      before do
        VCR.use_cassette('droplet fetch') do
          get :edit, { id: @unowned_phoenix.id }
        end
      end

      it 'redirects back to the index' do
        expect(response).to redirect_to(phoenixes_url)
      end
    end
  end
end
