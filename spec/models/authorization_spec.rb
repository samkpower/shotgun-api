require 'rails_helper'

describe Authorization do
  before { @user = build(:authorization) }

  subject { @user }

  it { should respond_to(:provider) }
  it { should respond_to(:user_id) }
  it { should be_valid }
end
