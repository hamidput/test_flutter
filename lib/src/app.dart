import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/src/features/user/logic/bloc/user_bloc.dart';
import 'package:test_flutter/src/features/user/logic/events/user_event.dart';
import 'package:test_flutter/src/features/user/presentation/screens/user_list_screen.dart';
import 'core/dependency_injection.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<UserBloc>()..add(FetchUsers())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User List',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const UserListScreen(),
      ),
    );
  }
}
