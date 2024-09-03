-module(community_chat).
-export([start_link/0, create_user/1, create_group/1, join_group/2, send_message/3, get_messages/1]).

start_link() ->
    InitialState = #{users => #{}, groups => #{}},
    spawn(fun() -> loop(InitialState) end).

create_user(User) ->
    gen_server:call(?MODULE, {create_user, User}).

create_group(GroupName) ->
    gen_server:call(?MODULE, {create_group, GroupName}).

join_group(User, GroupName) ->
    gen_server:call(?MODULE, {join_group, User, GroupName}).

send_message(User, GroupName, Message) ->
    gen_server:cast(?MODULE, {send_message, User, GroupName, Message}).

get_messages(GroupName) ->
    gen_server:call(?MODULE, {get_messages, GroupName}).

loop(State) ->
    receive
        {create_user, User} ->
            Users = maps:get(users, State, #{}),
            NewUsers = maps:put(User, [], Users),
            loop(maps:put(users, NewUsers, State));

        {create_group, GroupName} ->
            Groups = maps:get(groups, State, #{}),
            NewGroups = maps:put(GroupName, #{messages => [], members => []}, Groups),
            loop(maps:put(groups, NewGroups, State));

        {join_group, User, GroupName} ->
            Groups = maps:get(groups, State),
            Group = maps:get(GroupName, Groups),
            Members = maps:get(members, Group),
            NewGroup = maps:put(members, [User | Members], Group),
            NewGroups = maps:put(GroupName, NewGroup, Groups),
            loop(maps:put(groups, NewGroups, State));

        {send_message, User, GroupName, Message} ->
            Groups = maps:get(groups, State),
            Group = maps:get(GroupName, Groups),
            Messages = maps:get(messages, Group),
            NewMessages = [#{user => User, message => Message} | Messages],
            NewGroup = maps:put(messages, NewMessages, Group),
            NewGroups = maps:put(GroupName, NewGroup, Groups),
            loop(maps:put(groups, NewGroups, State));

        {get_messages, GroupName} ->
            Groups = maps:get(groups, State),
            Group = maps:get(GroupName, Groups),
            Messages = lists:reverse(maps:get(messages, Group)),
            {reply, Messages, State}
    end.
