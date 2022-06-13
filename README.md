

A server written in Elixir done as a personal project.

This server can be used to procces users for an application. An user is described by two fields: username of type String, and password of type String. When storing the users, the password will be encrypted. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `simple_server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_server, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/simple_server>.

## Starting the server

Using the command
```
iex -S mix
```
you can run the server. This will enable us to send requests to the server.


## Endpoints

`GET /hello`
This is just an example made for undestanding how GET method works. As a response a string having the value "world" will be returned. The status of the response will be set to 200.

`GET /users`
This request can be made to get all the users that are currently saved in the system. The response will have the status 200 and the body will contain the list of users. The list will be encoded as a JSON. 

`POST /post`
This is just an example made for undestanding how POST method works. This request should have a body containing a JSON structure with a field named "message" of type string. As an example, we can reffer to the following structure:
```
{
    "message": "Some message" 
}
```
The response for a successful request will have the status 201 and the body : "created: " + the given message.

`POST /user`
This request can be used to create new users in the system. The body of the request should be encoded as JSON, with the structure as the following example:
```
{
    "username": "an_username_value",
    "password": "a_password_value"
}
```
If the creation is successful, the response will have the status code 201 and the body will contain the data of the new user created. 

`POST /auth`

This request can be used to authenticate users. The body of the request should be encoded as JSON, with the structure as the following example:
```
{
    "username": "an_username_value",
    "password": "a_password_value"
}
```
If the credentials are correct, the response will have the status code 200 and the body will contain the string "Autenthication succeeded". 
In case of incorrect credentials, the response will have the status set to 403 with the string "Autenthication error".

In case of requests that are not currently mapped, the response will have the status 404 and will contain the string "not found".
