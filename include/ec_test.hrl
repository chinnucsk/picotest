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

-ifndef (EC_TEST_HRL).
-define (EC_TEST_HRL, true).

% Print to stderr.
-define (ectStdErr(Format, Args),
    io:put_chars(standard_error, io_lib:format(Format, Args))).

-define (ectStdErr(Format), ?ectStdErr(Format, [])).

-endif.
