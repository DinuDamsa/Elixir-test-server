defmodule SimpleServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(:dispatch)

  def init(init_arg) do
    UserRepository.init_repo()
    {:ok, init_arg}
  end

  get "/hello" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "world")
  end

  post "/post" do
    {:ok, body, conn} = read_body(conn)

    body = Poison.decode!(body)

    IO.inspect(body)

    send_resp(conn, 201, "created: #{get_in(body, ["message"])}")
  end

  get "/users" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(GenServer.call(UserRepo, :getAll)))
  end

  post "/user" do
    {:ok, body, conn} = read_body(conn)

    newUser = Poison.decode!(body, as: %User{})

    GenServer.cast(
      UserRepo,
      {:push,
       %User{
         username: newUser.username,
         password: SimpleServer.Router.get_hash_password(newUser.password)
       }}
    )

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, body)
  end

  post "/auth" do
    {:ok, body, conn} = read_body(conn)

    IO.inspect(Poison.decode!(body))
    authUser = Poison.decode!(body, as: %User{})

    try do
      [_usr | _tail] =
        Enum.filter(GenServer.call(UserRepo, :getAll), fn usr ->
          usr.username == authUser.username
        end)
        |>Enum.filter(fn usr ->
          usr.password == SimpleServer.Router.get_hash_password(authUser.password)
        end)
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "Autenthication succeeded")
    rescue
      _e in MatchError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, "Autenthication error")
    end
  end

  # "Default" route that will get called when no other route is matched

  match _ do
    conn = put_resp_content_type(conn, "text/plain")
    send_resp(conn, 404, "not found")
  end

  def get_hash_password(password) do
    :crypto.hash(:md5, password) |> Base.encode16(case: :lower)
  end
end
