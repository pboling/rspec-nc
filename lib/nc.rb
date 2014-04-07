require 'rspec/core/formatters/base_text_formatter'
require 'terminal-notifier'

class Nc < RSpec::Core::Formatters::BaseTextFormatter
  def dump_summary(duration, example_count, failure_count, pending_count)
    body = []
    if Object.const_defined?('SimpleCov')
      json = JSON.parse(File.open(Dir.pwd+"/coverage/coverage.json").read)
      sub=  "Test Coverage: #{json["metrics"]["covered_percent"].round(2).to_s}% Strength: #{json["metrics"]["covered_strength"].round(1).to_s} \u{1F63C}"
    else
      sub= "Finished in #{format_duration duration}"
    end
    body << summary_line(example_count, failure_count, pending_count)

    name = File.basename(File.expand_path '.')

    title = if failure_count > 0
      "\u26D4 #{name}: #{failure_count} failed example#{failure_count == 1 ? nil : 's'}"
    else
      "\u2705 #{name}: Success"
    end

    say title, body.join("\n"), sub
  end

  def dump_pending; end
  def dump_failures; end
  def message(message); end

  private

  def say(title, body, sub = nil)
    if TerminalNotifier.available?
      options = {:title => title}
      options.merge!(:subtitle => sub) if !sub.nil?
      TerminalNotifier.notify body, options
    end
  end
end
