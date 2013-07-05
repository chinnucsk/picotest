% Copyright (C) 2013 Johannes Huning
% This file is part of ec_test.
%
% ec_test is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% ec_test is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with ec_test.  If not, see <http://www.gnu.org/licenses/>.

-module (ect_client).
-include ("ect_internal.hrl").
-compile (export_all).


-spec run() -> no_return().
% The runner's entry routine called from bin/ect_client.
run() -> run(init:get_plain_arguments()).


-spec run([string()]) -> no_return().
% TODO - Catch-all and logging, should something go wrong we at least see
%        something useful instead of do_boot fubar.
% The main entry routine. Split into two functions for testing.
run(Args) ->
    % Obtain a unqiue node name for this run.
    {M,S,U} = os:timestamp(),
    UniqName = list_to_binary(io_lib:format("ect_client_~p_~p_~p", [M,S,U])),
    NodeName = binary_to_atom(UniqName, utf8),

    % Have the master's name as a node.
    MasterNode = binary_to_atom(list_to_binary(os:getenv("ECT_MASTER")), utf8),

    % Activate this node, then connect to the supplied master.
    {ok, _Pid} = net_kernel:start([NodeName, longnames]),
    case net_kernel:connect_node(MasterNode) of
        true -> ok;
        Reason ->
            ?ectStdErr(
                "Failed to connect to master ~p for reason '~p'",
                [MasterNode, Reason]),
            halt(1)
    end,

    io:format(
        "Arguments: ~p~nMaster: ~p~nName: ~p~n",
        [Args, MasterNode, NodeName]).
