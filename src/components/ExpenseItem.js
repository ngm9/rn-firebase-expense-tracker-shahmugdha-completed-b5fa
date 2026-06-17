import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function ExpenseItem({ expense }) {
  const { description, amount, category, paidBy } = expense;

  return (
    <View style={styles.card}>
      <View style={styles.row}>
        <Text style={styles.description}>{description}</Text>
        <Text style={styles.amount}>${amount?.toFixed(2)}</Text>
      </View>
      <View style={styles.row}>
        <Text style={styles.category}>{category}</Text>
        <Text style={styles.paidBy}>Paid by: {paidBy ?? 'Unknown'}</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 14,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOpacity: 0.06,
    shadowOffset: { width: 0, height: 2 },
    shadowRadius: 4,
    elevation: 2,
  },
  row: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 4 },
  description: { fontSize: 15, fontWeight: '600', color: '#1a1a2e', flex: 1 },
  amount: { fontSize: 15, fontWeight: '700', color: '#4A90E2' },
  category: { fontSize: 12, color: '#888' },
  paidBy: { fontSize: 12, color: '#888' },
});
