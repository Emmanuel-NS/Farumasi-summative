import subprocess
import time

def run(cmd):
    print(f"Running: {cmd}")
    res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if res.stdout:
        print(res.stdout)
    if res.stderr:
        print(res.stderr)
    return res.returncode

commands = [
    # Commit 1
    "git add lib/domain/ lib/data/models/ lib/core/constants/",
    'git commit -m "feat(domain): unify data models and add core constants"',
    
    # Commit 2
    "git add lib/data/datasources/ lib/data/dummy_data.dart",
    'git commit -m "feat(data): add dummy data and update state services"',
    
    # Commit 3
    "git add lib/data/repositories/",
    'git commit -m "feat(data): implement mock and remote repositories for core features"',
    
    # Commit 4
    "git add lib/presentation/blocs/ test/unit/cart_bloc_test.dart",
    'git commit -m "feat(bloc): enhance application state management and add tests"',
    
    # Commit 5
    "git add lib/presentation/screens/admin/",
    'git commit -m "feat(admin): build comprehensive admin dashboard with management screens"',
    
    # Commit 6
    "git add lib/presentation/screens/cart_screen.dart lib/presentation/screens/checkout_screen.dart lib/presentation/screens/orders_screen.dart lib/presentation/screens/order_tracking_screen.dart",
    'git commit -m "feat(orders): implement cart, checkout, and order tracking flows"',
    
    # Commit 7
    "git add lib/presentation/screens/medicine_detail_screen.dart lib/presentation/screens/medicine_store_screen.dart lib/presentation/screens/pharmacy_detail_screen.dart lib/presentation/widgets/medicine_item.dart test/widget/medicine_item_test.dart",
    'git commit -m "feat(shop): create medicine and pharmacy browsing screens"',
    
    # Commit 8
    "git add .",
    'git commit -m "feat(ui): update patient-facing screens and main configuration"',
]

for cmd in commands:
    run(cmd)

run("git log -n 8 --oneline")
