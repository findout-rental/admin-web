import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/user/all_users_controller.dart';

class TransactionHistoryPanel extends StatelessWidget {
  final String userName;
  final double currentBalance;

  const TransactionHistoryPanel({
    super.key,
    required this.userName,
    required this.currentBalance,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllUsersController>(
      builder: (controller) {
        return Container(
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(-5, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(context, controller),
              
              // Current Balance Banner
              _buildBalanceBanner(context),
              
              // Filters
              _buildFilters(context, controller),
              
              // Transaction List
              Expanded(
                child: _buildTransactionList(context, controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AllUsersController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => controller.closeTransactionHistoryPanel(),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'EGP ${currentBalance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          Icon(
            Icons.account_balance_wallet,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, AllUsersController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // Transaction Type Filter
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => DropdownButton<String>(
                    value: controller.selectedTransactionType.value,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Types')),
                      DropdownMenuItem(value: 'deposit', child: Text('Deposits')),
                      DropdownMenuItem(value: 'withdrawal', child: Text('Withdrawals')),
                      DropdownMenuItem(value: 'rent_payment', child: Text('Rent Payments')),
                      DropdownMenuItem(value: 'refund', child: Text('Refunds')),
                      DropdownMenuItem(value: 'cancellation_fee', child: Text('Cancellation Fees')),
                    ],
                    onChanged: controller.onTransactionTypeFilterChanged,
                    underline: const SizedBox.shrink(),
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                    isExpanded: true,
                  )),
            ),
          ),
          const SizedBox(width: 12),
          
          // Date Range Filter
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => DropdownButton<String>(
                    value: controller.selectedDateRange.value,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Time')),
                      DropdownMenuItem(value: 'month', child: Text('This Month')),
                      DropdownMenuItem(value: 'last_month', child: Text('Last Month')),
                      DropdownMenuItem(value: '3months', child: Text('Last 3 Months')),
                    ],
                    onChanged: controller.onDateRangeFilterChanged,
                    underline: const SizedBox.shrink(),
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                    isExpanded: true,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, AllUsersController controller) {
    return Obx(() {
      if (controller.isLoadingTransactionHistory.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final transactions = controller.filteredTransactionHistory;

      if (transactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No transactions found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transaction history will appear here',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return _buildTransactionCard(context, transactions[index]);
        },
      );
    });
  }

  Widget _buildTransactionCard(BuildContext context, Map<String, dynamic> transaction) {
    final type = transaction['type'] as String? ?? 'unknown';
    final amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
    final description = transaction['description'] as String? ?? '';
    final createdAt = transaction['created_at'] as String?;
    final relatedBookingId = transaction['related_booking_id'] as int?;
    
    final isPositive = amount >= 0;
    final typeInfo = _getTransactionTypeInfo(type);

    DateTime? date;
    if (createdAt != null) {
      try {
        date = DateTime.parse(createdAt);
      } catch (e) {
        // Invalid date format
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: typeInfo['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              typeInfo['icon'] as IconData,
              color: typeInfo['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        typeInfo['label'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${isPositive ? '+' : ''}EGP ${amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isPositive ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (date != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy - HH:mm').format(date),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
                if (relatedBookingId != null) ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      // Navigate to booking detail
                      Get.toNamed('/bookings');
                      // TODO: Filter or highlight specific booking
                    },
                    child: Text(
                      'Booking #$relatedBookingId',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getTransactionTypeInfo(String type) {
    switch (type) {
      case 'deposit':
        return {
          'label': 'Deposit',
          'icon': Icons.add_circle,
          'color': Colors.green,
        };
      case 'withdrawal':
        return {
          'label': 'Withdrawal',
          'icon': Icons.remove_circle,
          'color': Colors.orange,
        };
      case 'rent_payment':
        return {
          'label': 'Rent Payment',
          'icon': Icons.payment,
          'color': Colors.blue,
        };
      case 'refund':
        return {
          'label': 'Refund',
          'icon': Icons.undo,
          'color': Colors.green,
        };
      case 'cancellation_fee':
        return {
          'label': 'Cancellation Fee',
          'icon': Icons.cancel,
          'color': Colors.red,
        };
      default:
        return {
          'label': 'Transaction',
          'icon': Icons.receipt,
          'color': Colors.grey,
        };
    }
  }
}

