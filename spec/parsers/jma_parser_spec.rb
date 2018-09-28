require 'rails_helper'

describe JmaParser do
  describe '#parse' do
    let(:result) do
      File.open("#{__dir__}/../data/jma01.html") do |file|
        JmaParser.parse(file.read, JmaPlace.find_by(name: '帯広')) 
      end
    end

    it do
      expect(result.first.date).to eq(Date.new(2018, 9, 1))
      pp result
    end
  end
end
