require 'rails_helper'

describe Phoenix do
  let(:phoenix) { create(:phoenix) }

  describe "#total_status" do
    context "droplet is not on" do
      before do
        allow(phoenix).to receive(:do_status).and_return(nil)
      end

      it "returns 'burnt'" do
        expect(phoenix.total_status).to eq("Burnt")
      end
    end

    context "status is set" do
      before do
        phoenix.update(status: "test")
      end

      it "returns set status" do
        expect(phoenix.total_status).to eq("test")
      end
    end

    context "droplet is on" do
      before do
        allow(phoenix).to receive(:on?).and_return(true)
      end

      it "returns the DigitalOcean status" do
        expect(phoenix).to receive(:do_status).and_return("active")
        expect(phoenix.total_status).to eq("active")
      end
    end
  end

  describe "#on?" do
    it "returns false" do
      expect(phoenix.on?).to be_falsey
    end
  end

  describe "#active?" do
    context "DO status is 'active'" do
      before do
        allow(phoenix).to receive(:do_status).and_return("active")
      end

      it "returns true" do
        expect(phoenix.active?).to be_truthy
      end
    end

    context "DO status is 'foo'" do
      before do
        allow(phoenix).to receive(:do_status).and_return("foo")
      end

      it "returns false" do
        expect(phoenix.active?).to be_falsey
      end
    end
  end

  describe "#failed?" do
    context "status contains 'fail'" do
      before do
        allow(phoenix).to receive(:total_status).and_return("it done failed")
      end

      it "returns true" do
        expect(phoenix.failed?).to be_truthy
      end
    end

    context "status is 'foo'" do
      before do
        allow(phoenix).to receive(:do_status).and_return("foo")
      end

      it "returns false" do
        expect(phoenix.failed?).to be_falsey
      end
    end
  end
end
