require 'rails_helper'

RSpec.describe Sale, type: :model do

  it "validacion inicial" do
    expect(1).to eq(1)
  end

  it "validacion que da error" do
    expect(1).to eq(2)
  end

end
