describe Updoc::Consumer do
  subject { class ThingToTest ; include Updoc::Consumer ; end }

  let(:name) { 'test_name' }
  let(:service_type) { 'test_service' }
  let(:uri) { 'test_uri' }

  describe '.register_consumer' do
    let(:expected_definition) do
      {
        name: name,
        service_type: service_type,
        definition_uri: uri,
        services: []
      }
    end

    before do
      subject.updoc.register_consumer(name: name, service_type: service_type, definition_uri: uri)
    end

    it 'should set consumer name' do
      expect(subject.updoc.config.consumer.consumer_name).to eq name
    end

    it 'should register a consumer' do
      expect(Updoc::Consumers[name].to_h).to eq expected_definition
    end
  end

  describe '.register_consumer_service' do
    context 'with a registered consumer' do
      before do
        subject.updoc.register_consumer(name: name, service_type: service_type, definition_uri: uri)
      end

      it 'should add to services' do
        subject.updoc.register_consumer_service('uri1', 'uri2')
        expect(subject.updoc.config.consumer.services).to eq %w(uri1 uri2)
      end
    end

    context 'without a registered consumer' do
      it 'should raise an error' do
        expect { subject.updoc.register_consumer_service('uri1', 'uri2') }.to(
          raise_error Updoc::Consumer::RegisterError
        )
      end
    end
  end
end
