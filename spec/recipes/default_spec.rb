require 'spec_helper'

describe "rails_app::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'should include ruby_build' do
    expect(chef_run).to include_recipe('ruby_build')
  end

  it 'should include rbenv do' do
    expect(chef_run).to include_recipe('rbenv')
  end
  

end
