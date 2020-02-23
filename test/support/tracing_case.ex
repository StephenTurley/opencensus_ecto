defmodule OpencensusEcto.TracingCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__)

      require Record

      for {name, spec} <- Record.extract_all(from_lib: "opencensus/include/opencensus.hrl") do
        Record.defrecord(name, spec)
      end

      setup do
        result = :oc_reporter.register(:oc_reporter_pid, self())
        flush_mailbox()
        result
      end
    end
  end

  def report_spans do
    send(:oc_reporter, :report_spans)
  end

  def flush_mailbox() do
    receive do
      _ -> flush_mailbox()
    after
      100 -> nil
    end
  end

  defmacro assert_span(attrs, timeout \\ 1000) do
    quote do
      report_spans()
      assert_receive {:span, span(unquote(attrs))}, unquote(timeout)
    end
  end
end
