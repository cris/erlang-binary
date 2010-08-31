-module(erlang_binary).
-export([
        any/2,
        duplicate/2,
        map/2
    ]).

-type fun_pred() :: fun((char()) -> boolean()).
-spec any(fun_pred(), binary()) -> boolean();
         (fun_pred(), tuple())  -> boolean().
any(_Pred, <<>>) ->
    false;
any(Pred, <<Char, Rest/binary>>) ->
    case Pred(Char) of
        true ->
            true;
        false ->
            any(Pred, Rest)
    end;

% some experiments to implement universal binary API
any(Pred, {Binary, ':', Size}) ->
    any(Pred, {Binary, Size, binary});

any(Pred, {Binary, ':', Size, '/', TypeSpecifierList}) ->
    any(Pred, {Binary, Size, TypeSpecifierList});

any(Pred, {Binary, none, _TypeSpecifierList}) ->
    Any =
        fun(<<>>, _MySelf) ->
            false;
        (<<Char/utf8, Rest/binary>>, MySelf) ->
            case Pred(Char) of
                true ->
                    true;
                false ->
                    MySelf(Rest, MySelf)
            end
        end,
    Any(Binary, Any);

any(Pred, {Binary, Size}) ->
    Any =
        fun(<<>>, _MySelf) ->
            false;
        (<<Char:Size, Rest/binary>>, MySelf) ->
            case Pred(Char) of
                true ->
                    true;
                false ->
                    MySelf(Rest, MySelf)
            end
        end,
    Any(Binary, Any).

-spec duplicate(non_neg_integer(), binary()) -> binary().
duplicate(N, Elem) when is_binary(Elem) andalso N >= 0 ->
    IoList = lists:duplicate(N, Elem),
    iolist_to_binary(IoList).

-spec map(fun(), binary()) -> binary().
map(Fun, Binary) when is_binary(Binary) ->
    << <<(Fun(B))>> || <<B>> <= Binary >>.

