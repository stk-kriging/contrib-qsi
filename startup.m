% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s):  Julien Bect  <julien.bect@centralesupelec.fr>
%                Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>

% Copying Permission Statement
%
%    This file is part of contrib-qsi (https://github.com/stk-kriging/contrib-qsi)
%
%    contrib-qsi is free software: you can redistribute it and/or modify it under
%    the terms of the GNU General Public License as published by the Free
%    Software Foundation,  either version 3  of the License, or  (at your
%    option) any later version.
%
%    contrib-qsi is distributed  in the hope that it will  be useful, but WITHOUT
%    ANY WARRANTY;  without even the implied  warranty of MERCHANTABILITY
%    or FITNESS  FOR A  PARTICULAR PURPOSE.  See  the GNU  General Public
%    License for more details.
%
%    You should  have received a copy  of the GNU  General Public License
%    along with contrib-qsi.  If not, see <http://www.gnu.org/licenses/>.



function startup ()

% Locate project root
project_root = fileparts (mfilename ('fullpath'));
cd (project_root);

% Add directories to the path
addpath (fullfile (project_root));
addpath (fullfile (project_root, 'test_functions'));
addpath (fullfile (project_root, 'misc'));
addpath (fullfile (project_root, 'examples'));
addpath (genpath (fullfile (project_root, 'methods' )));

% Download STK 2.8.1 (if needed)
stk_dir = fullfile (project_root, 'stk');
if ~ exist (stk_dir, 'dir')
    git_clone_dependency ('stk', stk_dir, ...
        'https://github.com/stk-kriging/stk.git', '2.8.1');
end

% Initialize STK
run (fullfile (stk_dir, 'stk_init.m'));

end % function


function git_clone_dependency (name, dst, url, sha1_or_tag)

if exist (dst, 'dir')
    error (sprintf ('Directory already exists: %s\n', dst)); %#ok<SPERR>
end

fprintf ('Cloning %s... ', name);

try

    gitcmd = sprintf ('git clone %s %s', url, dst);
    evalc (sprintf ('[status, output] = system (''%s'')', gitcmd));
    if status ~= 0
        error ([ ...
            'git-clone failed with the following ' ...
            'error message:\n\n%s\n\n'], output);
    end

    here = pwd ();  cd (dst);

    gitcmd = sprintf ('git checkout %s', sha1_or_tag);
    evalc (sprintf ('[status, output] = system (''%s'')', gitcmd));
    if status ~= 0
        error ([ ...
            'git-checkout failed with the following ' ...
            'error message:\n\n%s\n\n'], output);
    end

    cd (here);

catch e

    cd (here);

    % Remove partial/failed install
    if exist (dst, 'dir')
        rmdir (dst, 's');
    end

    rethrow (e);

end % try-catch

fprintf ('OK\n');

end % function
