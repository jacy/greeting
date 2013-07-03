-module(greeting_views).
-compile(export_all).
-import(greeting_shortcuts, [render_ok/3, render_ok/4, get_cookie_value/3]).

urls() -> [
	  {"^hello/?$", hello},
      {"^hello/(.+?)/?$", hello} % path param
    ].
% Return username input if present, otherwise return username cookie if
% present, otherwise return "Anonymous"
get_username(Req, InputData) ->
    proplists:get_value("username", InputData,
    get_cookie_value(Req, "username", "Anonymous")).

make_cookie(Username) ->
    mochiweb_cookies:cookie("username", Username, [{path, "/"}]).

handle_hello(Req, InputData) ->
    Username = get_username(Req, InputData),
    Cookie = make_cookie(Username),
    render_ok(Req, [Cookie], greeting_dtl, [{username, Username}]).

hello('GET', Req) ->
    handle_hello(Req, Req:parse_qs());
hello('POST', Req) ->
    handle_hello(Req, Req:parse_post()).

hello('GET', Req, Username) ->
    Cookie = make_cookie(Username),
    render_ok(Req, [Cookie], greeting_dtl, [{username, Username}]);
hello('POST', Req, _) ->
  hello('POST', Req).