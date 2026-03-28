import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/screens/cart_screen.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_state.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';

class MockCartBloc extends Mock implements CartBloc {}
class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockCartBloc mockCartBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockCartBloc = MockCartBloc();
    mockAuthBloc = MockAuthBloc();
    
    when(() => mockCartBloc.state).thenReturn(const CartLoaded(cartItems: [], totalAmount: 0.0));
    when(() => mockCartBloc.stream).thenAnswer((_) => const Stream.empty());
    
    when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>.value(value: mockCartBloc),
        BlocProvider<AuthBloc>.value(value: mockAuthBloc),
      ],
      child: const MaterialApp(
        home: CartScreen(),
      ),
    );
  }

  testWidgets('CartScreen displays empty state when cart is empty', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Look for text indicating the cart is empty
    expect(find.textContaining(RegExp('empty', caseSensitive: false)), findsOneWidget);
    
    // Look for 'Checkout' button to NOT be rendered or to be disabled
    // Assuming checkout shouldn't happen on an empty cart
  });
  
  testWidgets('CartScreen displays loading indicator when state is CartLoading', (WidgetTester tester) async {
    when(() => mockCartBloc.state).thenReturn(CartLoading());
    
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Not pumpAndSettle because of infinite animation

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
