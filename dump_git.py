import subprocess

def run_cmd(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout

status = run_cmd("git status")
log_status = run_cmd("git log -1")
branch = run_cmd("git branch --show-current")

with open('git_state_dump.txt', 'w') as f:
    f.write(f"BRANCH: {branch}\n")
    f.write(f"LOG: {log_status}\n")
    f.write(f"STATUS:\n{status}\n")
