defmodule OpencensusEctoTest do
  use OpencensusEcto.TracingCase, async: true
  alias OpencensusEcto.TestRepo, as: Repo
  alias OpencensusEcto.TestModels.{User, Post}

  @event_name [:opencensus_ecto, :test_repo, :query]

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(OpencensusEcto.TestRepo)

    :ocp.with_child_span("test")

    on_exit(fn ->
      :ocp.finish_span()
    end)
  end

  test "captures basic query events" do
    attach_handler()

    Repo.all(User)

    assert_span(
      name: "opencensus_ecto.test_repo.query:users",
      attributes: %{
        "query" => _,
        "source" => "users",
        "total_time_microseconds" => _,
        "decode_time_microseconds" => _,
        "query_time_microseconds" => _,
        "queue_time_microseconds" => _
      }
    )
  end

  test "changes the time unit" do
    attach_handler(time_unit: :millisecond)

    Repo.all(Post)

    assert_span(
      name: "opencensus_ecto.test_repo.query:posts",
      attributes: %{
        "query" => _,
        "source" => "posts",
        "total_time_milliseconds" => _,
        "decode_time_milliseconds" => _,
        "query_time_milliseconds" => _,
        "queue_time_milliseconds" => _
      }
    )
  end

  test "changes the span name prefix" do
    attach_handler(span_prefix: "Ecto")

    Repo.all(User)

    assert_span(
      name: "Ecto:users",
      attributes: %{
        "query" => _,
        "source" => "users",
        "total_time_microseconds" => _,
        "decode_time_microseconds" => _,
        "query_time_microseconds" => _,
        "queue_time_microseconds" => _
      }
    )
  end

  test "collects multiple spans" do
    user = Repo.insert!(%User{email: "opencensus@erlang.org"})
    Repo.insert!(%Post{body: "We got traced!", user: user})

    attach_handler()

    User
    |> Repo.all()
    |> Repo.preload([:posts])

    assert_span(
      name: "opencensus_ecto.test_repo.query:users",
      attributes: %{
        "query" => _,
        "source" => "users",
        "total_time_microseconds" => _,
        "decode_time_microseconds" => _,
        "query_time_microseconds" => _,
        "queue_time_microseconds" => _
      }
    )

    assert_span(
      name: "opencensus_ecto.test_repo.query:posts",
      attributes: %{
        "query" => _,
        "source" => "posts",
        "total_time_microseconds" => _,
        "decode_time_microseconds" => _,
        "query_time_microseconds" => _,
        "queue_time_microseconds" => _
      }
    )
  end

  test "skips recording spans when the trace is disabled" do
    ctx = :ocp.current_span_ctx()
    :ocp.with_span_ctx(span_ctx(ctx, trace_options: 0))

    attach_handler()

    Repo.all(User)

    refute_receive({:span, span()})
  end

  def attach_handler(config \\ []) do
    # For now setup the handler manually in each test
    handler = {__MODULE__, self()}

    :telemetry.attach(handler, @event_name, &OpencensusEcto.handle_event/4, config)

    on_exit(fn ->
      :telemetry.detach(handler)
    end)
  end
end
