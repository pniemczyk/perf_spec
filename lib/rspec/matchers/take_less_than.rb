RSpec::Matchers.define(:take_less_than) do |n|
  match do |block|
    @why_so_long = PerfSpec::WhySoLong.new(n)
    @why_so_long.check(&block)
    @why_so_long.success?
  end

  def supports_block_expectations?
    true
  end

  failure_message do |actual|
    @why_so_long.failure_message(actual, self)
  end
end
