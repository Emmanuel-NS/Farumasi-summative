import subprocess

def run(cmd):
    print(f"Running: {cmd}")
    res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if res.stdout:
        print(res.stdout)
    if res.stderr:
        print(res.stderr)

run("git checkout main")
run("git checkout -b k.koita/admin-portal-features")
run("git config user.name 'Kkadi20'")
run("git config user.email 'k.koita@alustudent.com'")
run("git branch --show-current")
