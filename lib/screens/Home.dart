import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/screens/SpaceDetailsScreen.dart';
import '../models/space.dart';
import '../widgets/space_card.dart';
import '../widgets/role_switch_button.dart'; // Importando o novo widget
import 'package:todolist/dialogs/edit_space_dialog.dart';
import '../providers/spaces_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    // Carregar os espaços ao iniciar
    ref.read(spacesProvider.notifier).fetchSpacesFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final spaces = ref.watch(spacesProvider);
    final spacesNotifier = ref.read(spacesProvider.notifier);
    final isUser = spacesNotifier.isUser; // Obter o papel atual
    final isLoading =
        spacesNotifier.isLoading; // Obter o estado de carregamento

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        actions: [
          RoleSwitchButton(
            isUser: isUser, // Passa o papel atual
            onPressed: () {
              spacesNotifier.toggleUserRole(); // Alterna o papel
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 15, 0),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: spaces.length + 1,
                    itemBuilder: (context, index) {
                      if (index == spaces.length) {
                        return const SizedBox(
                          height: 80,
                        );
                      }

                      return SpaceCard(
                        space: spaces[index],
                        isUser: isUser,
                        onEdit: () =>
                            _editSpace(context, spaces[index], spacesNotifier),
                        onDetails: () =>
                            _navigateToDetails(context, spaces[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _editSpace(
      BuildContext context, Space space, SpacesNotifier notifier) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditSpaceDialog(
          space: space,
          onStatusUpdated: (newStatus) {
            space.status = newStatus;
            notifier.updateSpaceInFirebase(space);
          },
        );
      },
    );
  }

  void _navigateToDetails(BuildContext context, Space space) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpaceDetailsScreen(space: space),
      ),
    );
  }
}
