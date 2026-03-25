import re

with open('lib/presentation/screens/admin/admin_dashboard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Add Medicine and Pharmacy Bloc imports
imports = """import 'package:farumasi_patient_app/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/medicine/medicine_state.dart';
import 'package:farumasi_patient_app/presentation/blocs/pharmacy/pharmacy_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/pharmacy/pharmacy_state.dart';
"""
if 'medicine_bloc.dart' not in text:
    text = text.replace("import 'package:farumasi_patient_app/presentation/blocs/order/order_state.dart';", 
                        "import 'package:farumasi_patient_app/presentation/blocs/order/order_state.dart';\n" + imports)

# We want to replace the `final totalMedicines` part.
target = """            final totalMedicines = StateService().medicines.length; // placeholder
            final totalPharmacies = StateService().pharmacies.length;"""

replacement = """            final medState = context.read<MedicineBloc>().state;
            final pharmState = context.read<PharmacyBloc>().state;
            
            final totalMedicines = medState is MedicineLoaded ? medState.medicines.length : 0;
            final totalPharmacies = pharmState is PharmacyLoaded ? pharmState.pharmacies.length : 0;"""

if target in text:
    text = text.replace(target, replacement)

with open('lib/presentation/screens/admin/admin_dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)
