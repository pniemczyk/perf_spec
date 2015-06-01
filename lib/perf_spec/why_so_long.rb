require 'benchmark'
require 'json'

module PerfSpec
  class WhySoLong
    attr_reader :expected_time, :real_time, :check_result, :meta_request_id, :bullet_warnings, :bullet_enable_stat

    def initialize(expected_time)
      @expected_time = expected_time
    end

    def check(&block)
      @real_time = Benchmark.realtime do
        @check_result = block.call
      end
    end

    def success?
      @success ||= real_time <= expected_time
    end

    def failure_message(_actual, matcher)
      @meta_request_id = extract_meta_request_id(matcher)
      return default_failure_message unless meta_request_id
      [
        default_failure_message,
        "\nTakes controller: ",
        META_REQUEST_KEYS.map { |key| "#{key}: #{duration_sum(meta_request_output, key)}" }.join(', '),
        "\n",
        meta_request_output.ai(indent: -2)
      ].join('')
    end

    private

    META_REQUEST_KEYS =  :controller, :view, :partial_view, :sql, :other

    def extract_meta_request_id(matcher)
      return nil unless matcher.respond_to?(:response)
      matcher.response.headers['X-Request-Id']
    end

    def default_failure_message
      "expected that block take less than #{expected_time} but takes #{real_time}"
    end

    def meta_request_view_path(path_full)
      extract_path(path_full, '/app/view')
    end

    def meta_request_sql_path(path_full)
      extract_path(path_full, '/app/')
    end

    def extract_path(path_full, folder)
      path_full[path_full.index(folder)..-1]
    end

    def duration(val)
      val.to_f / 1000
    end

    def duration_sum(res, key)
      return 0 unless res[key]
      res[key].inject(0) do |num, el|
        num += el[:duration]
      end
    end

    def meta_request_json
      @meta_request_json ||= JSON.parse(MetaRequest::Storage.new(meta_request_id).read)
    end

    def meta_request_output
      @meta_request_output ||= meta_request_json.each_with_object({}) do |el, o|
        base_hash = { duration: duration(el['duration']) }
        case el['name']
        when 'render_partial.action_view'
          (o[:partial_view] ||= []).push(base_hash.merge(path: meta_request_view_path(el['payload']['identifier'])))
        when 'render_template.action_view'
          (o[:view] ||= []).push(base_hash.merge(path: meta_request_view_path(el['payload']['identifier']), layout: el['payload']['layout']))
        when 'process_action.action_controller'
          (o[:controller] ||= []).push(base_hash)
        when 'sql.active_record'
          pl = el['payload']
          (o[:sql] ||= []).push(base_hash.merge(name: pl['name'], sql: pl['sql'], method: pl['method'], filename: meta_request_sql_path(pl['filename'])))
        else
          (o[:other] ||= []).push(base_hash)
        end
      end
    end
  end
end
