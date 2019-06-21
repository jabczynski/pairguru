require "rails_helper"

describe Movie do
  describe "associations" do
    it { should have_many(:comments).dependent(:destroy) }
  end
end
