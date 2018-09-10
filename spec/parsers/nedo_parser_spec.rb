require 'rails_helper'

describe NedoParser do
  describe '#parse' do
    let(:result) do
      File.open("#{__dir__}/../data/nedo01", 'r:cp932') do |file|
        NedoParser.parse(file.read) 
      end
    end

    it do
      expect(result.count).to eq(12)      
      expect(result.first.nedo_place.name).to eq('波照間')
    end
  end
end
