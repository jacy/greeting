-module(greeting_views).
-compile(export_all).
-import(greeting_shortcuts, [render_ok/3]).

urls() -> [
      {"^hello/?$", hello}
    ].

hello('GET', Req) ->
    QueryStringData = Req:parse_qs(),
    Username = proplists:get_value("username", QueryStringData, "Anonymous"),
    render_ok(Req, greeting_dtl, [{username, Username}]);
hello('POST', Req) ->
    PostData = Req:parse_post(),
    Username = proplists:get_value("username", PostData, "Anonymous"),
    render_ok(Req, greeting_dtl, [{username, Username}]).