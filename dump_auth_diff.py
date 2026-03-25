import subprocess

def run_cmd(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout

diff1 = run_cmd("git diff lib/data/repositories/auth_repository_impl.dart")
diff2 = run_cmd("git diff lib/presentation/blocs/login/login_cubit.dart")

with open('git_diff_auth.txt', 'w') as f:
    f.write(f"AUTH REPO IMPL:\n{diff1}\n\n")
    f.write(f"LOGIN CUBIT:\n{diff2}\n")
