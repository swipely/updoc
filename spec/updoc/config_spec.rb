describe Updoc::Config do
  subject { class ThingToTest ; include Updoc::Config ; end }

  it 'should define updoc helper' do
    expect(subject.updoc).to be_a Updoc::Config::FeatureConfig
  end

  it 'should generate feature name' do
    expect(subject.updoc.feature_name).to eq 'thing_to_test'
  end
end
