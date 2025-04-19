import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/src/features/user/logic/bloc/user_bloc.dart';
import 'package:test_flutter/src/features/user/logic/events/user_event.dart';
import 'package:test_flutter/src/features/user/logic/states/user_state.dart';
import '../widgets/user_tile.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<UserBloc>().add(LoadMoreUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: const Text(
          'GitHub Users',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Add theme toggle functionality here
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[100]!,
              Colors.white,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async => context.read<UserBloc>().add(RefreshUsers()),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _searchText = ''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchText = val),
                ),
              ),
              Expanded(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      );
                    }
                    if (state is UserError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<UserBloc>().add(RefreshUsers()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is UserLoaded) {
                      final users = state.users
                          .where((u) => u.login
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()))
                          .toList();
                      if (users.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No users found',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: users.length + (state.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= users.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: UserTile(
                              user: users[index],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UserDetailScreen(user: users[index]),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
