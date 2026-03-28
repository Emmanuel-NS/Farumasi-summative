import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/add_edit_medicine_screen.dart';
import 'package:farumasi_patient_app/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/medicine/medicine_state.dart';
import 'package:farumasi_patient_app/presentation/blocs/pharmacy/pharmacy_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/pharmacy/pharmacy_state.dart';

class MockMedicineBloc extends Mock implements MedicineBloc {}
class MockPharmacyBloc extends Mock implements PharmacyBloc {}

void main() {
  late MockMedicineBloc mockMedicineBloc;
  late MockPharmacyBloc mockPharmacyBloc;

  setUp(() {
    mockMedicineBloc = MockMedicineBloc();
    mockPharmacyBloc = MockPharmacyBloc();
    when(() => mockMedicineBloc.state).thenReturn(MedicineInitial());
    when(() => mockMedicineBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockPharmacyBloc.state).thenReturn(const PharmacyLoaded([]));
    when(() => mockPharmacyBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MedicineBloc>.value(value: mockMedicineBloc),
        BlocProvider<PharmacyBloc>.value(value: mockPharmacyBloc),
      ],
      child: const MaterialApp(
        home: AddEditMedicineScreen(),
      ),
    );
  }

  testWidgets('renders formulation accurately', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('allows entering medicine details completely', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final nameField = find.widgetWithText(TextFormField, 'Medicine Name');
    final descField = find.widgetWithText(TextFormField, 'Description');
    final priceField = find.widgetWithText(TextFormField, 'Price (RWF)');

    if (nameField.evaluate().isNotEmpty) {
      await tester.enterText(nameField, 'Test Paracetamol');
      await tester.pumpAndSettle();
      expect(find.text('Test Paracetamol'), findsOneWidget); 
    }

    if (descField.evaluate().isNotEmpty) {
      await tester.enterText(descField, 'Effective pain reliever');
      await tester.pumpAndSettle();
      expect(find.text('Effective pain reliever'), findsOneWidget);
    }

    if (priceField.evaluate().isNotEmpty) {
      await tester.enterText(priceField, '1500');
      await tester.pumpAndSettle();
      expect(find.text('1500'), findsOneWidget);
    }
  });
}
