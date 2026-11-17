
import 'package:material_ui/material_ui.dart';
import 'add_expense_screen.dart';

class SharedExpensesScreen extends StatefulWidget {
  const SharedExpensesScreen({super.key});

  @override
  State<SharedExpensesScreen> createState() =>
      _SharedExpensesScreenState();
}

class _SharedExpensesScreenState extends State<SharedExpensesScreen> {
  static const green = Color(0xFF079F78);

  // Members added by the user.
  final List<String> members = [];

  // Expenses saved by the user.
  final List<Map<String, dynamic>> expenses = [];

  final TextEditingController memberController =
  TextEditingController();

  @override
  void dispose() {
    memberController.dispose();
    super.dispose();
  }

  // Add a new group member.
  void addMember() {
    final name = memberController.text.trim();

    if (name.isEmpty) return;

    final alreadyExists = members.any(
          (member) => member.toLowerCase() == name.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This member already exists'),
        ),
      );
      return;
    }

    setState(() {
      members.add(name);
      memberController.clear();
    });

    Navigator.pop(context);
  }

  // Show dialog to add a member.
  void showAddMemberDialog() {
    memberController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Group Member'),
          content: TextField(
            controller: memberController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter member name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => addMember(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: addMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Member'),
            ),
          ],
        );
      },
    );
  }

  // Delete a group member.
  void deleteMember(int index) {
    final name = members[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Member?'),
          content: Text(
            'Are you sure you want to delete $name?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  members.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name deleted'),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Display all members.
  void showMembersDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: Row(
                children: [
                  const Expanded(
                    child: Text('Group Members'),
                  ),
                  Text(
                    '${members.length}',
                    style: const TextStyle(
                      color: green,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: members.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No members added yet.',
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor:
                        green.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          color: green,
                        ),
                      ),
                      title: Text(members[index]),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          final name = members[index];

                          setState(() {
                            members.removeAt(index);
                          });

                          updateDialog(() {});

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text('$name deleted'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    showAddMemberDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Member'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Open Add Expense screen and receive saved data.
  Future<void> openAddExpenseScreen() async {
    if (members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add group members first'),
        ),
      );
      showAddMemberDialog();
      return;
    }

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          availableMembers: List<String>.from(members),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        expenses.insert(0, result);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense added successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shared Expenses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showMembersDialog,
            icon: const Icon(
              Icons.people_outline,
              color: green,
            ),
            tooltip: 'Manage Members',
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Members section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Group Members',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: showAddMemberDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Member'),
                  style: TextButton.styleFrom(
                    foregroundColor: green,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 85,
            child: members.isEmpty
                ? const Center(
              child: Text(
                'No members yet. Add your first member.',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: members.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      GestureDetector(
                        onLongPress: () => deleteMember(index),
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor:
                          green.withOpacity(0.1),
                          child: const Icon(
                            Icons.person,
                            color: green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        members[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(height: 24),

          // Expense heading
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your Expenses',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${expenses.length} Expenses',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Expense list
          Expanded(
            child: expenses.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No expenses added yet',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Tap + to add your first expense',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return expenseCard(expenses[index]);
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: green,
        foregroundColor: Colors.white,
        onPressed: openAddExpenseScreen,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  // Dynamic expense card.
  Widget expenseCard(Map<String, dynamic> expense) {
    final participants =
        expense['participants'] as List<dynamic>? ?? [];

    final amount = (expense['amount'] as num?) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense['title']?.toString() ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'PKR ${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: green,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Paid by: ${expense['payer'] ?? ''}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Participants:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: participants.map((participant) {
                final name = participant['name']?.toString() ?? '';

                return Chip(
                  label: Text(
                    name,
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: green.withOpacity(0.1),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
