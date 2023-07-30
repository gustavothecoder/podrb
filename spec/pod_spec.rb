# frozen_string_literal: true

RSpec.describe Pod do
  it "has a version number" do
    expect(Pod::VERSION).not_to be nil
  end
end
