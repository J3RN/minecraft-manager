describe PhoenixesController do
  before do
    sign_in create(:user_with_phoenixes)
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
end
