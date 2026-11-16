
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final List<String> availableMembers;

  const AddExpenseScreen({
    super.key,
    required this.availableMembers,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  static const green = Color(0xFF079F78);

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String? selectedPayer;

  final Set<String> selectedMembers = {};

  @override
  void initState() {
    super.initState();

    if (widget.availableMembers.isNotEmpty) {
      selectedPayer = widget.availableMembers.first;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void saveExpense() {
    final title = titleController.text.trim();

    final amountText = amountController.text
        .trim()
        .replaceAll(',', '');

    final amount = double.tryParse(amountText);

    if (title.isEmpty) {
      showMessage('Please enter expense title');
      return;
    }

    if (amount == null || amount <= 0) {
      showMessage('Please enter a valid amount');
      return;
    }

    if (selectedPayer == null) {
      showMessage('Please select who paid');
      return;
    }

    if (selectedMembers.isEmpty) {
      showMessage('Please select at least one participant');
      return;
    }

    final share = amount / selectedMembers.length;

    final participants = selectedMembers.map((member) {
      return {
        'name': member,
        'share': share,
      };
    }).toList();

    final expenseData = <String, dynamic>{
      'title': title,
      'amount': amount,
      'payer': selectedPayer,
      'participants': participants,
      'date': DateTime.now().toIso8601String(),
    };

    // Send expense data back to Shared Expenses screen.
    Navigator.pop(context, expenseData);
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(
      amountController.text.trim().replaceAll(',', ''),
    );

    final share = amount != null && selectedMembers.isNotEmpty
        ? amount / selectedMembers.length
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 7),

            TextField(
              controller: titleController,
              decoration: inputDecoration('Enter expense title'),
            ),

            const SizedBox(height: 16),

            const Text(
              'Total Amount',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 7),

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) {
                setState(() {});
              },
              decoration: inputDecoration('Enter amount in PKR'),
            ),

            const SizedBox(height: 16),

            const Text(
              'Payer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 7),

            DropdownButtonFormField<String>(
              value: selectedPayer,
              isExpanded: true,
              decoration: inputDecoration('Select who paid'),
              items: widget.availableMembers.map((member) {
                return DropdownMenuItem<String>(
                  value: member,
                  child: Text(member),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPayer = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Select Participants',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Choose the members who will share this expense.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            // Members received from Shared Expenses screen.
            ...widget.availableMembers.map((member) {
              final isSelected = selectedMembers.contains(member);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CheckboxListTile(
                  activeColor: green,
                  value: isSelected,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    member,
                    style: const TextStyle(fontSize: 14),
                  ),
                  secondary: CircleAvatar(
                    radius: 16,
                    backgroundColor: green.withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      size: 19,
                      color: green,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedMembers.add(member);
                      } else {
                        selectedMembers.remove(member);
                      }
                    });
                  },
                ),
              );
            }),

            const SizedBox(height: 16),

            // Automatic share calculation.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expense Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Selected Members: ${selectedMembers.length}',
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Each Member Share: PKR ${share.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Expense',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFB8C8C5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: green,
          width: 1.5,
        ),
      ),
    );
  }
}
