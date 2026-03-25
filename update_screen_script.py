import shutil
import os

src = 'lib/presentation/screens/admin/admin_consultations_screen_new.dart'
dst = 'lib/presentation/screens/admin/admin_consultations_screen.dart'

try:
    with open(src, 'r') as f_src:
        content = f_src.read()
    
    with open(dst, 'w') as f_dst:
        f_dst.write(content)
        
    print(f"Successfully updated {dst}")
    os.remove(src)
except Exception as e:
    print(f"Error: {e}")
