function startup ()

% Locate project root
project_root = fileparts (mfilename ('fullpath'));
cd (project_root);

% Add directories to the path
addpath (fullfile (project_root));
addpath (fullfile (project_root, 'test_functions'));
addpath (fullfile (project_root, 'misc'));
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
