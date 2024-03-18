
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/note_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NoteView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState> (
      builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NoteView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    },
    );
  }
}
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;
//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(create: (context)=> CounterBloc(),
//     child: Scaffold(appBar: AppBar(title: const Text('Test bloc'),),
//     body: BlocConsumer<CounterBloc,CounterState>(listener: (context, state){
//       _controller.clear();
//     },
//     builder: (context, state) {
//       final invalidValue = (state is CounterStateInvalidNumber) ? state.invalidValue: '';
//       return Column(
//         children: [
//           Text('Current value => ${state.value}'),
//           Visibility(visible: state is CounterStateInvalidNumber,
//           child: Text('Invalid input: $invalidValue'),),
//           TextField(
//             controller: _controller,
//             decoration: const InputDecoration(
//               hintText: 'Enter a number here'
//             ),
//             keyboardType: TextInputType.number,
//           ),
//           Row(children: [
//             TextButton(onPressed: () {
//               context.read<CounterBloc>()
//               .add((DecreamentEvent(_controller.text)));
//             }, 
//             child: const Text('-')),
//             TextButton(onPressed: () {
//                context.read<CounterBloc>()
//               .add((IncreamentEvent(_controller.text)));
//             }, 
//             child: const Text('+')),
//           ],)
//         ],
//       );
//     },),
//     ),
//     );
//   }
// }

// @immutable
// abstract class CounterState{
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(super.value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncreamentEvent extends CounterEvent {
//   const IncreamentEvent(super.value);
// }

// class DecreamentEvent extends CounterEvent {
//   const DecreamentEvent(super.value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc():super(const CounterStateValid(0)){
//     on<IncreamentEvent>((event,emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(state.value+integer));
//       }
//     });
//     on<DecreamentEvent>((event,emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(state.value-integer));
//       }
//     });
//   }
// }