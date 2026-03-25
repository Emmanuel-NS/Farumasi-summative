import os
import re

def fix_file(filepath, replacements):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        for old, new in replacements:
            content = content.replace(old, new)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Fixed {filepath}')
    except Exception as e:
        print(f'Error fixing {filepath}: {e}')

fix_file('lib/presentation/blocs/order/order_state.dart', [
    ('class OrdersLoading extends OrderState {}\nclass OrdersLoading extends OrderState {}', 'class OrdersLoading extends OrderState {}'),
])

fix_file('lib/presentation/screens/admin/admin_dashboard_screen.dart', [
    ('import \'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart\';', ''),
    ('import \'package:farumasi_patient_app/presentation/blocs/auth/auth_event.dart\';', ''),
    ('AuthAuthLogoutRequested', 'AuthLogoutRequested'),
])

fix_file('lib/presentation/screens/orders_screen.dart', [
    ('import \'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart\';', ''),
    ('import \'package:farumasi_patient_app/presentation/blocs/auth/auth_event.dart\';', '')
])

fix_file('lib/presentation/screens/profile_screen.dart', [
    ('import \'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart\';', ''),
    ('import \'package:farumasi_patient_app/presentation/blocs/auth/auth_event.dart\';', ''),
    ('AuthAuthLogoutRequested', 'AuthLogoutRequested'),
])

# Also fix the updateProfile signature in profile_screen.dart
with open('lib/presentation/screens/profile_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()
    
content = re.sub(r'await context\.read<AuthRepository>\(\)\.updateProfile\(uid: userId, data: \{(.*?)\}\);', 
                 r'await context.read<AuthRepository>().updateProfile(uid: userId, displayName: _nameController.text.trim(), phoneNumber: _phoneController.text.trim());', 
                 content, flags=re.DOTALL)
                 
with open('lib/presentation/screens/profile_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
