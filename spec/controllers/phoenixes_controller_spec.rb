describe PhoenixesController do
  before do
    @user = create(:user_with_phoenixes)
    @phoenix = @user.owned_phoenixes.first
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

  describe 'GET edit' do
    before do
      VCR.use_cassette('droplet fetch') do
        get :edit, { id: @phoenix.id }
      end
    end

    it 'renders sucessfully' do
      expect(response).to have_http_status(:success)
    end
  end
end
