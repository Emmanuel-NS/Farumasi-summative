import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_event.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_state.dart';
import 'package:farumasi_patient_app/domain/repositories/cart_repository.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  group('CartBloc', () {
    late CartRepository cartRepository;
    late CartBloc cartBloc;

    setUp(() {
      cartRepository = MockCartRepository();
      cartBloc = CartBloc(cartRepository: cartRepository);
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state is CartLoaded with empty items', () {
      // Assuming CartBloc initializes with empty loaded state
      expect(cartBloc.state, equals(const CartLoaded(cartItems: [], totalAmount: 0.0)));
    });

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when LoadCart is added and succeeds',
      build: () {
        when(() => cartRepository.getCartItems()).thenAnswer((_) async => []);
        when(() => cartRepository.getTotalAmount()).thenAnswer((_) async => 0.0);
        return cartBloc;
      },
      act: (bloc) => bloc.add(LoadCart()),
      expect: () => [
        CartLoading(),
        const CartLoaded(cartItems: [], totalAmount: 0.0),
      ],
    );
  });
}
