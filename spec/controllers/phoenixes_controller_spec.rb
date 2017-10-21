describe PhoenixesController do
  before do
    @phoenix = create(:phoenix)
    sign_in @phoenix.owner
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
      get :new
    end

    it 'renders sucessfully' do
      expect(response).to have_http_status(:success)
    end

    it 'builds a new phoenix' do
      expect(assigns(:phoenix)).to be_a_new(Phoenix)
    end
  end
end
