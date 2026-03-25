import os
import re

def fix_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Fix Auth states
        content = content.replace('state is AuthInitial', 'state.status == AuthStatus.unauthenticated')
        content = content.replace('authState is AuthAuthenticated', 'authState.status == AuthStatus.authenticated')
        content = content.replace('authState is! AuthAuthenticated', 'authState.status != AuthStatus.authenticated')
        content = content.replace('state is! AuthAuthenticated', 'state.status != AuthStatus.authenticated')
        
        # Logout Event
        content = content.replace('LogoutRequested()', 'AuthLogoutRequested()')
        
        # Admin Screen OrderStatus
        content = content.replace('OrderStatus.pending:', 'OrderStatus.pendingReview:')
        content = content.replace('OrderStatus.processing:', 'OrderStatus.findingPharmacy:')
        content = content.replace('OrderStatus.shipped:', 'OrderStatus.outForDelivery:')
        content = content.replace('.add(UpdateOrderStatusEvent(order.id, status));', '.add(UpdateOrderStatusEvent(order.id, status.name));')
        
        # Admin dashboard screen imports
        content = content.replace('import \'package:farumasi_patient_app/presentation/screens/auth/login_screen.dart\';', 'import \'package:farumasi_patient_app/presentation/screens/auth_screen.dart\';\nimport \'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart\';')
        # Also fix Orders screen
        if 'orders_screen.dart' in filepath or 'profile_screen.dart' in filepath:
             content = content.replace('import \'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart\';', 'import \'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart\';\nimport \'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart\';\nimport \'package:farumasi_patient_app/presentation/blocs/auth/auth_event.dart\';')

        content = content.replace('LoginScreen()', 'AuthScreen()')

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Fixed {filepath}')
    except Exception as e:
        print(f'Error fixing {filepath}: {e}')

files = [
    'lib/presentation/screens/admin/admin_dashboard_screen.dart',
    'lib/presentation/screens/orders_screen.dart',
    'lib/presentation/screens/profile_screen.dart'
]

for f in files:
    fix_file(f)
