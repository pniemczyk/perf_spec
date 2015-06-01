require 'spec_helper'

describe PerfSpec, type: :request do
  it 'has a version number' do
    expect(PerfSpec::VERSION).not_to be nil
  end

  it 'pass when action take_less_than' do
    expect do
      sleep 0.1
    end.to take_less_than(0.2)
  end
end
