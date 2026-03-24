import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:farumasi_patient_app/data/models/medicine.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_event.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_state.dart';
import 'package:farumasi_patient_app/presentation/widgets/medicine_item.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}
class FakeCartEvent extends Fake implements CartEvent {}
class FakeCartState extends Fake implements CartState {}

void main() {
  late MockCartBloc mockCartBloc;

  setUpAll(() {
    registerFallbackValue(FakeCartEvent());
    registerFallbackValue(FakeCartState());
  });

  setUp(() {
    mockCartBloc = MockCartBloc();
  });

  final testMedicine = Medicine(
    id: '1',
    name: 'Test Medicine',
    description: 'Test Description',
    price: 100.0,
    imageUrl: 'https://example.com/image.png',
    category: 'General',
  );

  testWidgets('MedicineItem displays name and price', (WidgetTester tester) async {
    // Arrange
    when(() => mockCartBloc.state).thenReturn(const CartLoaded(cartItems: []));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CartBloc>.value(
          value: mockCartBloc,
          child: Scaffold(
            body: MedicineItem(
              medicine: testMedicine,
              onAboutTap: () {},
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Test Medicine'), findsOneWidget);
    // Price checks
    // "100 RWF" based on MedicineItem implementation '${medicine.price.toStringAsFixed(0)} RWF'
    expect(find.text('100 RWF'), findsOneWidget);
  });
}
