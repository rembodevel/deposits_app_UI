import 'package:flutter/material.dart';
import '../models/deposit.dart';

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  State<DepositsScreen> createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  List<Deposit> deposits = [
    Deposit(bankName: 'Сбербанк', name: 'Накопительный', amount: 150000, interestRate: 5.5, isFavorite: true),
    Deposit(bankName: 'ВТБ', name: 'Пенсионный', amount: 300000, interestRate: 6.0),
    Deposit(bankName: 'Газпромбанк', name: 'Детский', amount: 100000, interestRate: 4.0, isFavorite: true),
    Deposit(bankName: 'Альфа-Банк', name: 'Премиум', amount: 500000, interestRate: 7.2),
    Deposit(bankName: 'Тинькофф', name: 'Срочный', amount: 250000, interestRate: 5.8),
    Deposit(bankName: 'Райффайзенбанк', name: 'Онлайн', amount: 120000, interestRate: 6.5, isFavorite: true),
    Deposit(bankName: 'МТС Банк', name: 'Пакетный', amount: 350000, interestRate: 5.0),
    Deposit(bankName: 'Открытие', name: 'Конверсионный', amount: 400000, interestRate: 6.3),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void toggleFavorite(int index) {
    setState(() {
      deposits[index].isFavorite = !deposits[index].isFavorite;
    });
  }

  void _showAddDepositSheet() {
    final bankNameController = TextEditingController();
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final rateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  'Добавить вклад',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(bankNameController, 'Название банка', Icons.account_balance),
                const SizedBox(height: 16),
                _buildInputField(nameController, 'Название вклада', Icons.account_balance_wallet),
                const SizedBox(height: 16),
                _buildInputField(amountController, 'Сумма вклада (руб.)', Icons.attach_money, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildInputField(rateController, 'Процентная ставка (%)', Icons.percent, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        final bankName = bankNameController.text.trim();
                        final name = nameController.text.trim();
                        final amount = double.tryParse(amountController.text.trim()) ?? 0;
                        final rate = double.tryParse(rateController.text.trim()) ?? 0;

                        if (bankName.isEmpty || name.isEmpty || amount <= 0 || rate <= 0) return;

                        setState(() {
                          deposits.insert(0, Deposit(bankName: bankName, name: name, amount: amount, interestRate: rate));
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Добавить', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  void _removeDeposit(int index) {
    final removedDeposit = deposits[index];
    setState(() {
      deposits.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вклад "${removedDeposit.name}" удалён'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              deposits.insert(index, removedDeposit);
            });
          },
        ),
      ),
    );
  }

  Widget buildDepositCard(Deposit deposit, int index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 36),
      ),
      onDismissed: (_) => _removeDeposit(index),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          title: Text(
            deposit.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deposit.bankName,
                style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Сумма: ${deposit.amount.toStringAsFixed(0)} ₽\nПроцент: ${deposit.interestRate.toStringAsFixed(2)}%',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              deposit.isFavorite ? Icons.star : Icons.star_border,
              color: deposit.isFavorite ? Colors.amber : Colors.grey,
              size: 28,
            ),
            onPressed: () => toggleFavorite(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = deposits.where((d) => d.isFavorite).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          centerTitle: true,
          title: const Text('Обзор вкладов' , style: TextStyle(color: Colors.white),),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,           // Цвет активного таба
            unselectedLabelColor: Colors.white70, // Цвет неактивных табов (можно тоже сделать белым)
            tabs: const [
              Tab(text: 'Все вклады'),
              Tab(text: 'Избранное'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddDepositSheet,
          tooltip: 'Добавить вклад',
          child: const Icon(Icons.add, size: 32, color: Colors.white,),
          backgroundColor: Colors.blue.shade700,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            deposits.isEmpty
                ? const Center(child: Text('Список вкладов пуст'))
                : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              itemCount: deposits.length,
              itemBuilder: (_, index) => buildDepositCard(deposits[index], index),
            ),
            favorites.isEmpty
                ? const Center(child: Text('Избранных вкладов нет'))
                : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              itemCount: favorites.length,
              itemBuilder: (_, index) {
                final deposit = favorites[index];
                final realIndex = deposits.indexOf(deposit);
                return buildDepositCard(deposit, realIndex);
              },
            ),
          ],
        ),
      ),
    );
  }
}